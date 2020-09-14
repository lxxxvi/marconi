module CleanedBroadcastsTableCreator
  module_function

  def create!
    ActiveRecord::Base.transaction do
      execute(drop_table_sql)
      execute(create_table_sql)
      execute(add_index_on_foreign_key_sql)
    end

    table_name
  end

  def execute(statement)
    ActiveRecord::Base.connection.execute(statement)
  rescue StandardError => e
    Rails.logger.error "Failing statement: \n\n#{statement}"
    raise e
  end

  def table_name
    :cleaned_broadcasts
  end

  def drop_table_sql
    "DROP TABLE IF EXISTS #{table_name}"
  end

  def create_table_sql
    <<~SQL.squish
      CREATE TABLE #{table_name}
      AS
      WITH broadcasts_with_previous AS (
        SELECT b.id
             , b.song_id
             , b.station_id
             , b.broadcasted_at
             , lag(broadcasted_at) OVER (PARTITION BY station_id, song_id
                                             ORDER BY broadcasted_at ASC) AS previous_broadcasted_at
             , lead(broadcasted_at) OVER (PARTITION BY station_id, song_id
                                             ORDER BY broadcasted_at ASC) AS next_broadcasted_at
          FROM broadcasts b
         ORDER BY broadcasted_at DESC
      ),

      broadcasts_30_minutes_apart AS (
        SELECT *
          FROM broadcasts_with_previous
         WHERE (previous_broadcasted_at IS NULL
             OR broadcasted_at - previous_broadcasted_at > INTERVAL '30 minutes')
      )

      SELECT b.id                                                       AS broadcast_id
           , b.song_id                                                  AS song_id
           , b.station_id                                               AS station_id
           , b.broadcasted_at                                           AS broadcasted_at
           , lag(broadcasted_at) OVER (PARTITION BY station_id, song_id
                                           ORDER BY broadcasted_at ASC) AS previous_broadcasted_at
           , lead(broadcasted_at) OVER (PARTITION BY station_id, song_id
                                           ORDER BY broadcasted_at ASC) AS next_broadcasted_at
        FROM broadcasts_30_minutes_apart b
    SQL
  end

  def add_index_on_foreign_key_sql
    <<~SQL.squish
      CREATE INDEX index_broadcast_id_on_#{table_name}
      ON #{table_name}
      (
        broadcast_id
      )
    SQL
  end
end
