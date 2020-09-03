class CachedArtistFact < ApplicationRecord
  belongs_to :artist
  belongs_to :station
end
