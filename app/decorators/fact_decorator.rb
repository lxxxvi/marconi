class FactDecorator < BaseDecorator
  VALUE_DECORATOR_METHODS = {
    first_broadcasted_at: :to_datetime,
    latest_broadcasted_at: :to_datetime,
    total_broadcasts: :to_i
  }.freeze
  DEFAULT_DECORATOR_METHOD = :to_s

  def value
    object.value.try(decorator_method) || object.value.try(DEFAULT_DECORATOR_METHOD)
  end

  def decorator_method
    VALUE_DECORATOR_METHODS[object.key.to_sym] || DEFAULT_DECORATOR_METHOD
  end
end
