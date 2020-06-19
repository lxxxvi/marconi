class Fact < ApplicationRecord
  belongs_to :station, optional: true
  belongs_to :factable, polymorphic: true

  validates :key, uniqueness: { scope: %i[station_id factable_id factable_type] }

  enum key: {
    first_broadcasted_at: 'first_broadcasted_at',
    latest_broadcasted_at: 'latest_broadcasted_at',
    total_broadcasts: 'total_broadcasts'
  }

  def decorated_value
    decorate.value
  end

  def decorate
    @decorate ||= FactDecorator.new(self)
  end
end
