class PredictionResultService
  def save
    ActiveRecord::Base.connection.execute(prediction_result_sql)
  end

  def prediction_result_sql
    <<~SQL.squish
      WITH broadcasts_with_tz AS (
        SELECT b.*
             , broadcasted_at AT TIME ZONE 'UTC'
                              AT TIME ZONE 'Europe/Zurich' AS broadcasted_at_in_tz
          FROM cleaned_broadcasts b
      )

      , distinct_songs_broadcasts AS (
          SELECT date(broadcasted_at_in_tz) AS date
               , song_id
            FROM broadcasts_with_tz
        GROUP BY date(broadcasted_at_in_tz)
               , song_id
      )

      , with_result AS (
      SELECT p.reference_date
           , p.song_id
           , p.score
           , p.created_at
           , p.updated_at
           , CASE
               WHEN b.song_id IS NOT NULL THEN 'PLAYED'
             END AS result
        FROM predictions p
        LEFT OUTER JOIN distinct_songs_broadcasts b ON b.date = p.reference_date::TIMESTAMP
                                                   AND b.song_id = p.song_id
      )
      INSERT INTO predictions (reference_date, song_id, score, created_at, updated_at, result)
      SELECT reference_date
           , song_id
           , score
           , created_at
           , NOW() AS updated_at
           , result
        FROM with_result
          ON CONFLICT (reference_date, song_id)
          DO UPDATE
                SET result = EXCLUDED.result
                  , updated_at = EXCLUDED.updated_at
    SQL
  end
end
