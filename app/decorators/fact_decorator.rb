class FactDecorator < BaseDecorator
  VALUE_DECORATOR_METHODS = {
    facts: {
      artist: {
        first_broadcasted_at: :to_datetime,
        latest_broadcasted_at: :to_datetime,
        total_broadcasts: :to_i,
        average_seconds_between_broadcasts: :to_i
      },
      song: {
        first_broadcasted_at: :to_datetime,
        latest_broadcasted_at: :to_datetime,
        total_broadcasts: :to_i,
        average_seconds_between_broadcasts: :to_i
      },
      station: {
        total_broadcasts: :to_i
      }
    },
    charts_facts: {
      song: {
        latest_chart_appearance_on: :to_date,
        chart_peak_position: :to_i,
        weeks_in_charts: :to_i
      }
    }
  }.freeze
  DEFAULT_DECORATOR_METHOD = :to_s

  def value
    object.value.try(decorator_method) || object.value.try(DEFAULT_DECORATOR_METHOD)
  end

  private

  def decorator_method
    VALUE_DECORATOR_METHODS.dig(
      table_name_as_sym,
      factable_type_as_sym,
      key_as_sym
    ) || DEFAULT_DECORATOR_METHOD
  end

  def table_name_as_sym
    object.class.table_name.to_sym
  end

  def factable_type_as_sym
    object.factable_type.downcase.to_sym
  end

  def key_as_sym
    object.key.to_sym
  end
end
