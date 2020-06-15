class Broadcast < ApplicationRecord
  belongs_to :song
  belongs_to :station

  validates :broadcasted_at, presence: true

  scope :of_song, ->(song) { where(song: song) }
  scope :ordered_chronologically, -> { order(broadcasted_at: :asc) }
end
