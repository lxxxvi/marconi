class Facts::Station::TotalBroadcastsCalculator < Facts::CalculatorBase
  def fact_key
    :total_broadcasts
  end

  def factable_type
    Station
  end

  def calculated_data_sql
    <<~SQL
      SELECT station_id AS station_id
           , station_id AS factable_id
           , count(*)   AS value
        FROM broadcasts
       GROUP BY station_id
    SQL
  end
end
