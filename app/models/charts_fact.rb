class ChartsFact < ApplicationRecord
  include FactDecoratable

  validates :country, :key, :value, presence: true
  belongs_to :factable, polymorphic: true

  scope :of_country, ->(country) { where(country: country) }
  scope :of_key, ->(key) { where(key: key) }

  enum key: {
    latest_chart_appearance_on: 'latest_chart_appearance_on',
    chart_peak_position: 'chart_peak_position',
    weeks_in_charts: 'weeks_in_charts'
  }
end
