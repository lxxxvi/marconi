module Ilike
  extend ActiveSupport::Concern

  included do
    scope :ilike, ->(hash) {
      or_filter = hash.map do |attribute, values|
        or_filter = Array(values).map do |value|
          sanitize_sql(["#{attribute} ILIKE :value", { value: value }])
        end
      end.join(' OR ')

      where(or_filter)
    }
  end
end
