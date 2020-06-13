class Srf::Synchronizer
  def initialize(date = Time.zone.today.yesterday)
    @srf_api = Srf::Api.new(date)
    @errors = []
  end

  def synchronize!
    Rails.logger.info "#{@srf_api.request.url}\n"

    srf_api_broadcasts.each do |srf_api_broadcast|
      srf_api_broadcast.save!
      Rails.logger.info summary(srf_api_broadcast)
    rescue StandardError => e
      Rails.logger.error summary(srf_api_broadcast, e)
    end
  end

  def srf_api_broadcasts
    api_response.songlog.broadcasts
  end

  private

  def api_response
    @api_response ||= @srf_api.call
  end

  def summary(srf_api_broadcast, error = nil)
    [
      ok_or_nok(error),
      srf_api_broadcast.broadcasted_at,
      artist_name_and_song_title(srf_api_broadcast)
    ].join('  ')
  end

  def ok_or_nok(error)
    return green('[OK] ') if error.nil?

    red('[NOK]')
  end

  def artist_name_and_song_title(srf_api_broadcast)
    [
      srf_api_broadcast.srf_api_songlog_song.srf_api_songlog_artist.name,
      srf_api_broadcast.srf_api_songlog_song.title
    ].join(' - ')
  end

  def red(text)
    "\e[31m#{text}\e[0m"
  end

  def green(text)
    "\e[32m#{text}\e[0m"
  end
end
