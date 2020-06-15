module Facts::Songs::FirstBroadcast
  module_function

  def call!
    ActiveRecord::Base.connection.execute(upsert_statement_sql)
  end

  def upsert_statement_sql
    <<~SQL
      WITH
      all_songs_first_broadcasts AS (
        SELECT song_id               AS song_id
             , min(broadcasted_at)   AS first_broadcasted_at
          FROM broadcasts
         GROUP BY song_id
      ),
      songs_with_new_first_broadcasts AS (
        SELECT s.id                       AS id
             , s.title                    AS title
             , s.artist_id                AS artist_id
             , s.created_at               AS created_at
             , asfb.first_broadcasted_at  AS first_broadcasted_at
          FROM all_songs_first_broadcasts asfb
         INNER JOIN songs s       ON s.id = asfb.song_id
                                 AND COALESCE(s.first_broadcasted_at, NOW()) != asfb.first_broadcasted_at
      )
      INSERT INTO songs (
          id
        , title
        , artist_id
        , created_at
        , updated_at
        , first_broadcasted_at
      )
      SELECT id
           , title
           , artist_id
           , created_at
           , NOW()
           , first_broadcasted_at
        FROM songs_with_new_first_broadcasts
          ON CONFLICT (id) DO
      UPDATE
         SET first_broadcasted_at = EXCLUDED.first_broadcasted_at
    SQL
  end
end
