class Station < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :broadcasts, dependent: :destroy
end
