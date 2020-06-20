module Facts::CalculatorValidations
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

  def validate_all!
    validate_fact_key!
    validate_factable_type!
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
