class Facts::CalculatorBase
  include Facts::CalculatorValidations

  def call!
    validate_all!
    execute(upsert_statement_sql)
  end

  private

  def execute(sql_statement)
    ActiveRecord::Base.connection.execute(sql_statement)
  end

  def upsert_statement_sql
    <<~SQL
      WITH
      static_data AS (
        SELECT '#{factable_type}'     AS factable_type
             , '#{fact_key}'          AS key
             , #{epoch_year}          AS epoch_year
             , #{epoch_week}          AS epoch_week
             , NOW()                  AS created_at
             , NOW()                  AS updated_at
      ),
      calculated_data AS (
        #{calculated_data_sql}
      )
      INSERT INTO facts (
          station_id
        , factable_id
        , factable_type
        , key
        , value
        , epoch_year
        , epoch_week
        , created_at
        , updated_at
      )
      SELECT cd.station_id
           , cd.factable_id
           , sd.factable_type
           , sd.key
           , cd.value
           , sd.epoch_year
           , sd.epoch_week
           , sd.created_at
           , sd.updated_at
        FROM calculated_data cd
        CROSS JOIN static_data sd
        ON CONFLICT (station_id, factable_type, factable_id, key, epoch_year, epoch_week)
        DO UPDATE SET value = EXCLUDED.value
                    , updated_at = EXCLUDED.updated_at
    SQL
  end

  def fact_key
    raise 'implement in subclass'
  end

  def factable_type
    raise 'implement in subclass'
  end

  # override in subclass if required
  def epoch_year
    Fact.column_defaults['epoch_year']
  end

  # override in subclass if required
  def epoch_week
    Fact.column_defaults['epoch_week']
  end

  # calculated_data_sql should be an SQL SELECT statement that returns three columns
  #
  # * station_id
  # * factable_id
  # * value
  def calculated_data_sql
    raise 'implement in subclass'
  end
end
