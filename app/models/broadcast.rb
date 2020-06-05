class Broadcast < ApplicationRecord
  belongs_to :song
  belongs_to :station
  has_many :external_keys, as: :externally_identifyable
end
