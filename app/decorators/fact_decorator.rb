class FactDecorator < BaseDecorator
  VALUE_DECORATOR_METHODS = {
    song: {
      first_broadcasted_at: :to_datetime,
      latest_broadcasted_at: :to_datetime,
      total_broadcasts: :to_i
    },
    station: {
      total_broadcasts: :to_i
    }
  }.freeze
  DEFAULT_DECORATOR_METHOD = :to_s

  def value
    object.value.try(decorator_method) || object.value.try(DEFAULT_DECORATOR_METHOD)
  end

  private

  def decorator_method
    VALUE_DECORATOR_METHODS.dig(factable_type_as_sym, key_as_sym) || DEFAULT_DECORATOR_METHOD
  end

  def factable_type_as_sym
    object.factable_type.downcase.to_sym
  end

  def key_as_sym
    object.key.to_sym
  end
end
