class Srf::Synchronizer
  def initialize(date)
    @srf_api = Srf::Api.new(date)
    @errors = []
  end

  def synchronize!
    srf_api_broadcasts.each(&:save!)
  end

  def srf_api_broadcasts
    api_response.songlog.broadcasts
  end

  private

  def api_response
    @api_response ||= @srf_api.call
  end
end
