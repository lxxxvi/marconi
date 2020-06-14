class MigrateBroadcastExternalKeys < ActiveRecord::Migration[6.0]
  def up
    ActiveRecord::Base.transaction do
      copy_from_external_keys_to_broadcasts
      delete_external_keys
    end
  end

  def down
    # not intended
  end

  private

  def copy_from_external_keys_to_broadcasts
    execute(copy_from_external_keys_to_broadcasts_sql)
  end

  def delete_external_keys
    execute(delete_external_keys_sql)
  end

  def copy_from_external_keys_to_broadcasts_sql
    <<~SQL
      WITH migrated_broadcasts AS (
        SELECT ek.externally_identifyable_id   AS broadcast_id
             , ek.identifier                   AS target_external_key
             , b.song_id                       AS song_id
             , b.station_id                    AS station_id
             , b.broadcasted_at                AS broadcasted_at
             , b.created_at                    AS created_at
             , b.updated_at                    AS updated_at
          FROM external_keys ek
         INNER JOIN broadcasts b ON b.id = ek.externally_identifyable_id
                                AND COALESCE(b.external_key, '') != ek.identifier
         WHERE ek.externally_identifyable_type = 'Broadcast'
      )
      INSERT INTO broadcasts (
          id
        , external_key
        , song_id
        , station_id
        , broadcasted_at
        , created_at
        , updated_at
      )
      SELECT mb.broadcast_id
           , mb.target_external_key
           , mb.song_id
           , mb.station_id
           , mb.broadcasted_at
           , mb.created_at
           , mb.updated_at
        FROM migrated_broadcasts mb
        ON CONFLICT (id)
        DO UPDATE
        SET external_key = EXCLUDED.external_key
    SQL
  end

  def delete_external_keys_sql
    <<~SQL
      DELETE
        FROM external_keys
       WHERE externally_identifyable_type = 'Broadcast'
    SQL
  end
end
