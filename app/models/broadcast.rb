class Broadcast < ApplicationRecord
  belongs_to :song
  belongs_to :station

  validates :broadcasted_at, presence: true

  scope :of_song, ->(song) { where(song: song) }
end
