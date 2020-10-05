class Artist < ApplicationRecord
  include CachedFacts
  include Ilike

  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :songs, dependent: :destroy
  has_many :external_keys, as: :externally_identifyable, dependent: :destroy
  has_many :facts, as: :factable, dependent: :destroy
end
