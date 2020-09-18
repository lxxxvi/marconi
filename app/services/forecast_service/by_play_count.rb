class ForecastService::ByPlayCount
  def initialize(forecast_date, time_frame = 3.weeks)
    @upper_date = forecast_date
    @lower_date = forecast_date - time_frame
  end

  def forecast_song_ids
    @forecast_song_ids ||= execute(most_played_sql).map { _1['song_id'] }
  end

  def actual_song_ids
    @actual_song_ids ||= execute(actual_sql).map { _1['song_id'] }
  end

  def correctly_predicted_song_ids
    @correctly_predicted_song_ids ||= forecast_song_ids & actual_song_ids
  end

  def correctly_predicted_song_ids_ratio
    correctly_predicted_song_ids.size.to_f / forecast_song_ids.size.to_f
  end

  def execute(sql)
    ActiveRecord::Base.connection.execute(sql)
  end

  def most_played_sql
    <<~SQL.squish
      WITH input AS (
        SELECT '#{@lower_date.to_s(:db)}'::TIMESTAMP AS lower_date
             , '#{@upper_date.to_s(:db)}'::TIMESTAMP AS upper_date
      ),

      broadcasts_with_tz AS (
        SELECT b.*
             , b.broadcasted_at AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Zurich' AS broadcasted_at_in_tz
          FROM cleaned_broadcasts b
         WHERE station_id = (SELECT id FROM stations WHERE name = 'SRF3')
      ),

      broadcasts_in_time_window AS (
        SELECT *
          FROM broadcasts_with_tz
         CROSS JOIN input i
         WHERE broadcasted_at_in_tz BETWEEN i.lower_date AND i.upper_date
           AND EXTRACT(hour FROM broadcasted_at_in_tz) BETWEEN 5 AND 18
      ),

      broadcasts_in_time_window_grouped AS (
        SELECT song_id
             , count(*) AS play_count
          FROM broadcasts_in_time_window
         GROUP BY song_id
        HAVING count(*) > 1
      ),

      broadcasts_past_in_time_window_ranked AS (
        SELECT song_id
             , play_count
             , RANK() OVER (ORDER BY play_count DESC) AS play_count_rank
          FROM broadcasts_in_time_window_grouped
      )

      SELECT song_id
        FROM broadcasts_past_in_time_window_ranked
       WHERE play_count_rank < 10
    SQL
  end

  def actual_sql
    <<~SQL.squish
      WITH broadcasts_with_tz AS (
        SELECT b.*
             , b.broadcasted_at AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Zurich' AS broadcasted_at_in_tz
          FROM cleaned_broadcasts b
         WHERE station_id = (SELECT id FROM stations WHERE name = 'SRF3')
      )

      SELECT DISTINCT song_id
        FROM broadcasts_with_tz b
       WHERE date(broadcasted_at_in_tz) = '#{@upper_date.to_s(:db)}'::TIMESTAMP
         AND EXTRACT(hour FROM broadcasted_at_in_tz) BETWEEN 5 AND 18
    SQL
  end
end
