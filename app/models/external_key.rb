class ExternalKey < ApplicationRecord
  validates :identifer, presence: true
  belongs_to :station
  belongs_to :externally_identifyable, polymorphic: true

  validates :identifer, uniqueness: { scope: [:station, :externally_identifyable_type] }

  scope :of_station, ->(station) { where(station: station) }
  scope :artists, -> { where(externally_identifyable_type: 'Artist') }
end