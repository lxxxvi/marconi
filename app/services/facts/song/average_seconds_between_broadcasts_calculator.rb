class Facts::Song::AverageSecondsBetweenBroadcastsCalculator < Facts::CalculatorBase
  def fact_key
    :average_seconds_between_broadcasts
  end

  def factable_type
    Song
  end

  def calculated_data_sql
    <<~SQL.squish
      WITH songs_with_multiple_broadcasts_facts AS (
        SELECT station_id                       AS station_id
             , factable_type                    AS factable_type
             , factable_id                      AS factable_id
             , CAST(value AS INT)               AS total_broadcasts
          FROM facts
         WHERE key = 'total_broadcasts'
           AND factable_type = 'Song'
           AND CAST(value AS INT) > 1
      ),

      songs_with_first_broadcasted_at_facts AS (
        SELECT swmbf.station_id                                   AS station_id
             , swmbf.factable_type                                AS factable_type
             , swmbf.factable_id                                  AS factable_id
             , swmbf.total_broadcasts                             AS total_broadcasts
             , CAST(fba.value AS TIMESTAMP)                       AS first_broadcasted_at
             , CAST('#{Time.zone.now.to_s(:db)}' AS TIMESTAMP)    AS reference_time
          FROM songs_with_multiple_broadcasts_facts swmbf
         INNER JOIN facts fba  ON fba.station_id = swmbf.station_id
                              AND fba.factable_type = swmbf.factable_type
                              AND fba.factable_id = swmbf.factable_id
                              AND fba.key = 'first_broadcasted_at'
      ),

      songs_with_seconds_since_first_broadcast AS (
        SELECT station_id                       AS station_id
             , factable_id                      AS factable_id
             , first_broadcasted_at             AS first_broadcasted_at
             , total_broadcasts                 AS total_broadcasts
             , CAST(
                  EXTRACT(
                    EPOCH FROM (reference_time - first_broadcasted_at)
                  ) AS INT
               )                                AS seconds_since_first_broadcast
          FROM songs_with_first_broadcasted_at_facts
      )

      SELECT station_id AS station_id
           , factable_id    AS factable_id
           , seconds_since_first_broadcast / (total_broadcasts - 1) AS value
        FROM songs_with_seconds_since_first_broadcast
    SQL
  end
end
