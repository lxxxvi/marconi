class Fact < ApplicationRecord
  include FactDecoratable

  belongs_to :station
  belongs_to :factable, polymorphic: true

  validates :key, :value, :epoch_year, :epoch_week, presence: true
  validates :key, uniqueness: { scope: %i[station_id factable_id factable_type epoch_year epoch_week] }

  enum key: {
    first_broadcasted_at: 'first_broadcasted_at',
    latest_broadcasted_at: 'latest_broadcasted_at',
    total_broadcasts: 'total_broadcasts',
    average_seconds_between_broadcasts: 'average_seconds_between_broadcasts'
  }
end
