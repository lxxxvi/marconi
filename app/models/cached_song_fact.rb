class CachedSongFact < ApplicationRecord
  belongs_to :song
  belongs_to :station
end
