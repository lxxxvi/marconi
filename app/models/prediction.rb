class Prediction < ApplicationRecord
  belongs_to :song

  validates :reference_date, :score, presence: true

  scope :for_date, ->(date) { where(reference_date: date) }
  scope :ordered, -> { order(score: :desc) }

  scope :with_song_and_artist, -> { includes(song: :artist).joins(song: :artist) }
end
