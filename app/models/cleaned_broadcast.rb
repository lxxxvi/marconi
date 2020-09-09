class CleanedBroadcast < ApplicationRecord
  belongs_to :broadcast
  belongs_to :song
  belongs_to :station
  scope :chronologically, -> { order(broadcasted_at: :asc) }
end
