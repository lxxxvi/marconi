module Facts::Songs::TotalBroadcasts
  module_function

  def call!
    ActiveRecord::Base.connection.execute(upsert_statement_sql)
  end

  def upsert_statement_sql
    <<~SQL
      WITH
      songs_with_total_broadcasts AS (
        SELECT song_id      AS song_id
             , count(*)     AS total_broadcasts
          FROM broadcasts
         GROUP BY song_id
      ),
      songs_with_new_total_broadcasts AS (
        SELECT s.id                   AS id
             , s.title                AS title
             , s.artist_id            AS artist_id
             , s.created_at           AS created_at
             , swtb.total_broadcasts  AS total_broadcasts
          FROM songs_with_total_broadcasts swtb
         INNER JOIN songs s     ON swtb.song_id = s.id
                               AND swtb.total_broadcasts != s.total_broadcasts
      )
      INSERT INTO songs (
          id
        , title
        , artist_id
        , created_at
        , updated_at
        , total_broadcasts
      )
      SELECT id
           , title
           , artist_id
           , created_at
           , NOW()
           , total_broadcasts
        FROM songs_with_new_total_broadcasts
          ON CONFLICT (id) DO
      UPDATE
         SET total_broadcasts = EXCLUDED.total_broadcasts
    SQL
  end
end
