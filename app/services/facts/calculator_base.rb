class Facts::CalculatorBase
  class UnknownFactKey < StandardError
    def initialize(fact_key)
      super("Unknown fact_key #{fact_key.inspect}, see Fact.keys for valid keys")
    end
  end

  class UnknownFactableType < StandardError
    def initialize(factable_type)
      super("Unknown factable_type #{factable_type.inspect}. Must be type of ActiveRecord::Base")
    end
  end

  def call!
    validate_fact_key!
    validate_factable_type!

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
             , NOW()                  AS created_at
             , NOW()                  AS updated_at
      ),
      calculated_data AS (
        #{calculated_data_sql}
      )
      INSERT INTO facts (station_id, factable_id, factable_type, key, value, created_at, updated_at)
      SELECT cd.station_id
           , cd.factable_id
           , sd.factable_type
           , sd.key
           , cd.value
           , sd.created_at
           , sd.updated_at
        FROM calculated_data cd
        CROSS JOIN static_data sd
        ON CONFLICT (station_id, factable_type, factable_id, key)
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

  # calculated_data_sql should be an SQL SELECT statement that returns three columns
  #
  # * station_id
  # * factable_id
  # * value
  def calculated_data_sql
    raise 'implement in subclass'
  end

  def validate_fact_key!
    return if Fact.keys.include?(fact_key.to_s)

    raise UnknownFactKey, fact_key
  end

  def validate_factable_type!
    return if factable_type.try(:new).is_a?(ActiveRecord::Base)

    raise UnknownFactKey, factable_type
  end
end
