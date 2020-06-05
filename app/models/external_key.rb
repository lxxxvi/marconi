class ExternalKey < ApplicationRecord
  validates :identifer, presence: true
  belongs_to :station
  belongs_to :externally_identifyable, polymorphic: true

  validates :identifer, uniqueness: { scope: [:station, :externally_identifyable_type]}
end
