module Facts::Songs::TotalBroadcastsCalculator
  module_function

  def fact_key
    :total_broadcasts
  end

  def call!
    ActiveRecord::Base.transaction do
      ActiveRecord::Base.connection.tap do |connection|
        connection.execute(delete_all_sql)
        connection.execute(upsert_statement_sql)
      end
    end
  end

  def delete_all_sql
    <<~SQL
      DELETE FROM facts WHERE key = '#{fact_key}'
    SQL
  end

  def upsert_statement_sql
    <<~SQL
      WITH
      all_songs_total_broadcasts_per_station AS (
        SELECT station_id             AS station_id
             , song_id                AS factable_id
             , 'Song'                 AS factable_type
             , '#{fact_key}'          AS key
             , count(1)               AS value
          FROM broadcasts
         GROUP BY station_id, song_id
      )
      INSERT INTO facts (station_id, factable_id, factable_type, key, value, created_at, updated_at)
      SELECT station_id
           , factable_id
           , factable_type
           , key
           , value
           , NOW()
           , NOW()
        FROM all_songs_total_broadcasts_per_station
        ON CONFLICT (station_id, factable_type, factable_id, key)
        DO UPDATE SET value = EXCLUDED.value
                    , updated_at = EXCLUDED.updated_at;
    SQL
  end
end
