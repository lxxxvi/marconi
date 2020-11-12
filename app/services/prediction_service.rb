# rubocop:disable Metrics/ClassLength
class PredictionService
  def initialize(args = {})
    @reference_date = args[:reference_date] || Time.zone.today.to_s(:db)
    @week_term_weight = args[:week_term_weight] || 0.1
    @month_term_weight = args[:month_term_weight] || 0.9
  end

  def save
    ActiveRecord::Base.transaction do
      run(delete_prediction_sql)
      run(insert_prediction_sql)
    end
  end

  private

  def run(query)
    ActiveRecord::Base.connection.execute(query)
  end

  def delete_prediction_sql
    "DELETE FROM predictions WHERE reference_date = '#{@reference_date}'"
  end

  def insert_prediction_sql
    <<~SQL.squish
      WITH calculated_predictions AS (
        #{predictions_sql}
      )
      INSERT INTO predictions (reference_date, song_id, score, created_at, updated_at)
      SELECT reference_date
           , song_id
           , score
           , NOW() AS created_at
           , NOW() AS updated_at
        FROM calculated_predictions
    SQL
  end

  def predictions_sql
    <<~SQL.squish
      WITH params AS (
        SELECT '#{@reference_date}'::TIMESTAMP AS reference_date
             , '#{@week_term_weight}'::FLOAT   AS week_term_weight
             , '#{@month_term_weight}'::FLOAT  AS month_term_weight
      )
      , broadcasts_with_tz AS (
        SELECT b.*
             , broadcasted_at AT TIME ZONE 'UTC'
                              AT TIME ZONE 'Europe/Zurich' AS broadcasted_at_in_tz
          FROM cleaned_broadcasts b
      )

      , scoped_broadcasts AS (
        SELECT *
          FROM broadcasts_with_tz
         WHERE EXTRACT(hour FROM broadcasted_at_in_tz) BETWEEN 5 AND 18
      )

      , songs_on_reference_date AS (
        SELECT DISTINCT song_id
          FROM scoped_broadcasts
         CROSS JOIN params
         WHERE DATE(broadcasted_at_in_tz) = params.reference_date
      )

      , week_term AS (
        SELECT song_id
             , count(*) / 7.0 AS score
          FROM scoped_broadcasts
         CROSS JOIN params
         WHERE broadcasted_at_in_tz BETWEEN DATE(params.reference_date) - INTERVAL '8 days'
                                        AND DATE(params.reference_date)
         GROUP BY song_id
      )

      , month_term AS (
        SELECT song_id
             , count(*) / 30.0 AS score
          FROM scoped_broadcasts
         CROSS JOIN params
         WHERE broadcasted_at_in_tz BETWEEN DATE(params.reference_date) - INTERVAL '31 days'
                                        AND DATE(params.reference_date)
         GROUP BY song_id
      )

      , songs_with_scores AS (
        SELECT s.id AS song_id
             , COALESCE(wt.score, 0) AS week_term_score
             , COALESCE(mt.score, 0) AS month_term_score
          FROM songs s
          LEFT OUTER JOIN week_term wt  ON wt.song_id = s.id
          LEFT OUTER JOIN month_term mt ON mt.song_id = s.id
      )

      , songs_with_scores_weighted AS (
        SELECT song_id
             , week_term_score
             , week_term_score   * params.week_term_weight  AS week_term_score_weighted
             , month_term_score
             , month_term_score  * params.month_term_weight AS month_term_score_weighted
          FROM songs_with_scores
         CROSS JOIN params
      )

      , songs_with_scores_weighted_sum AS (
        SELECT s.*
             , (
                 s.week_term_score_weighted +
                 s.month_term_score_weighted
               ) AS term_scores_weighted_sum
          FROM songs_with_scores_weighted s
      )

      SELECT t.song_id                                      AS song_id
           , round(t.term_scores_weighted_sum::NUMERIC, 3)  AS score
           , DATE(params.reference_date)                    AS reference_date
        FROM songs_with_scores_weighted_sum t
       CROSS JOIN params
       ORDER BY term_scores_weighted_sum DESC
       LIMIT 150
    SQL
  end
end
# rubocop:enable Metrics/ClassLength
