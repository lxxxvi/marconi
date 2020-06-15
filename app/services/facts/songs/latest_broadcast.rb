module Facts::Songs::LatestBroadcast
  module_function

  def call!
    ActiveRecord::Base.connection.execute(upsert_statement_sql)
  end

  def upsert_statement_sql
    <<~SQL
      WITH
      all_songs_latest_broadcasts AS (
        SELECT song_id               AS song_id
             , max(broadcasted_at)   AS latest_broadcasted_at
          FROM broadcasts
         GROUP BY song_id
      ),
      songs_with_new_latest_broadcasts AS (
        SELECT s.id                       AS id
             , s.title                    AS title
             , s.artist_id                AS artist_id
             , s.created_at               AS created_at
             , asfb.latest_broadcasted_at  AS latest_broadcasted_at
          FROM all_songs_latest_broadcasts asfb
         INNER JOIN songs s       ON s.id = asfb.song_id
                                 AND COALESCE(s.latest_broadcasted_at, NOW()) != asfb.latest_broadcasted_at
      )
      INSERT INTO songs (
          id
        , title
        , artist_id
        , created_at
        , updated_at
        , latest_broadcasted_at
      )
      SELECT id
           , title
           , artist_id
           , created_at
           , NOW()
           , latest_broadcasted_at
        FROM songs_with_new_latest_broadcasts
          ON CONFLICT (id) DO
      UPDATE
         SET latest_broadcasted_at = EXCLUDED.latest_broadcasted_at
    SQL
  end
end
