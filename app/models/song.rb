class Song < ApplicationRecord
  include CachedFacts

  validates :title, presence: true
  validates :title, uniqueness: { scope: :artist }

  belongs_to :artist
  has_many :broadcasts, dependent: :destroy
  has_many :external_keys, as: :externally_identifyable, dependent: :destroy
  has_many :facts, as: :factable, dependent: :destroy
end
