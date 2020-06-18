class MigrateFacts < ActiveRecord::Migration[6.0]
  def up
    execute(migrate_data_to_facts_table_sql)
  end

  def down
    # not intended
  end

  private

  def migrate_data_to_facts_table_sql
    <<~SQL
      WITH
      common_data AS (
        SELECT id      AS station_id
             , 'Song'  AS factable_type
             , NOW()   AS created_at
             , NOW()   AS updated_at
          FROM stations
      ),
      first_broadcasted_facts AS (
        SELECT id                               AS factable_id
             , 'first_broadcasted_at'           AS key
             , first_broadcasted_at::VARCHAR    AS value
          FROM songs
      ),
      latest_broadcasted_facts AS (
        SELECT id                               AS factable_id
             , 'latest_broadcasted_at'          AS key
             , latest_broadcasted_at::VARCHAR   AS value
          FROM songs
      ),
      total_broadcast_facts AS (
        SELECT id                               AS factable_id
             , 'total_broadcasts'               AS key
             , total_broadcasts::VARCHAR        AS value
          FROM songs
      ),
      all_facts AS (
        SELECT * FROM first_broadcasted_facts  UNION ALL
        SELECT * FROM latest_broadcasted_facts UNION ALL
        SELECT * FROM total_broadcast_facts
      )
      INSERT INTO facts (
          station_id
        , factable_id
        , factable_type
        , key
        , value
        , created_at
        , updated_at
      )
      SELECT cd.station_id
           , af.factable_id
           , cd.factable_type
           , af.key
           , af.value
           , cd.created_at
           , cd.updated_at
       FROM all_facts af
      CROSS JOIN common_data cd
         ON CONFLICT (station_id, factable_type, factable_id, key)
         DO UPDATE SET value = EXCLUDED.value
    SQL
  end
end
