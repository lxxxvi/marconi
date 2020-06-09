class Song < ApplicationRecord
  validates :title, presence: true
  validates :title, uniqueness: { scope: :artist }

  belongs_to :artist
  has_many :broadcasts, dependent: :destroy
  has_many :external_keys, as: :externally_identifyable
end