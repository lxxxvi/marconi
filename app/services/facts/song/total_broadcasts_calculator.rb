class Facts::Song::TotalBroadcastsCalculator < Facts::CalculatorBase
  def fact_key
    :total_broadcasts
  end

  def factable_type
    Song
  end

  def calculated_data_sql
    <<~SQL.squish
      SELECT station_id             AS station_id
           , song_id                AS factable_id
           , count(1)               AS value
        FROM broadcasts
       GROUP BY station_id, song_id
    SQL
  end
end
