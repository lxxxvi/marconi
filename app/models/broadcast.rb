class Broadcast < ApplicationRecord
  belongs_to :song
  belongs_to :station
  has_many :external_keys, as: :externally_identifyable

  validates :broadcasted_at, presence: true

  scope :of_song, ->(song) { where(song: song) }
  scope :broadcasted_at_around, ->(time) {
    where(broadcasted_at: Range.new(time - 15.minutes, time + 15.minutes))
  }
end
