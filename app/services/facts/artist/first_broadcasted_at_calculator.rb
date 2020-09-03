class Facts::Artist::FirstBroadcastedAtCalculator < Facts::CalculatorBase
  def fact_key
    :first_broadcasted_at
  end

  def factable_type
    Artist
  end

  def calculated_data_sql
    <<~SQL
      SELECT b.station_id        AS station_id
           , s.artist_id         AS factable_id
           , min(broadcasted_at) AS value
        FROM songs s
       INNER JOIN broadcasts b ON b.song_id = s.id
       GROUP BY b.station_id, s.artist_id
    SQL
  end
end
