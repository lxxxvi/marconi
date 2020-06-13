class ExternalKey < ApplicationRecord
  validates :identifier, presence: true
  belongs_to :station
  belongs_to :externally_identifyable, polymorphic: true

  validates :identifier, uniqueness: { scope: %i[station externally_identifyable_type] }

  scope :of_station, ->(station) { where(station: station) }
  scope :artists, -> { where(externally_identifyable_type: 'Artist') }
  scope :songs, -> { where(externally_identifyable_type: 'Song') }
  scope :broadcasts, -> { where(externally_identifyable_type: 'Broadcast') }
end
