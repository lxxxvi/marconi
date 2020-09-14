class Facts::Song::FirstBroadcastedAtCalculator < Facts::CalculatorBase
  def fact_key
    :first_broadcasted_at
  end

  def factable_type
    Song
  end

  def calculated_data_sql
    <<~SQL.squish
      SELECT station_id             AS station_id
           , song_id                AS factable_id
           , min(broadcasted_at)    AS value
        FROM broadcasts
       GROUP BY station_id, song_id
    SQL
  end
end
