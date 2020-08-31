class Facts::Artist::TotalBroadcastsCalculator < Facts::CalculatorBase
  def fact_key
    :total_broadcasts
  end

  def factable_type
    Artist
  end

  def calculated_data_sql
    <<~SQL
      SELECT b.station_id     AS station_id
           , s.artist_id      AS factable_id
           , count(*)         AS value
        FROM broadcasts b
       INNER JOIN songs s ON s.id = b.song_id
       GROUP BY b.station_id, s.artist_id
    SQL
  end
end
