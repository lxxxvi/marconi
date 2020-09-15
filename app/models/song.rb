class Song < ApplicationRecord
  include CachedFacts

  validates :title, :ch_charts_scraper_status, presence: true
  validates :title, uniqueness: { scope: :artist }

  belongs_to :artist
  has_many :broadcasts, dependent: :destroy
  has_many :external_keys, as: :externally_identifyable, dependent: :destroy
  has_many :facts, as: :factable, dependent: :destroy
  has_many :charts_facts, as: :factable, dependent: :destroy

  enum ch_charts_scraper_status: {
    new: 'new',
    url_not_found: 'url_not_found',
    incorrect_url: 'incorrect_url',
    outdated: 'outdated',
    updated: 'updated'
  }, _prefix: :ch_charts_scraper_status

  after_initialize :initialize_ch_charts_scraper_status

  scope :ch_charts_scraper_enabled, -> { where(ch_charts_scraper_enabled: true) }

  def charts_fact(country, key)
    charts_facts.of_country(country).of_key(key).first_or_initialize
  end

  def decorate
    @decorate ||= SongDecorator.new(self)
  end

  private

  def initialize_ch_charts_scraper_status
    self.ch_charts_scraper_status ||= self.class.ch_charts_scraper_statuses.values.first
    self.ch_charts_scraper_status_updated_at ||= Time.zone.now
  end
end
