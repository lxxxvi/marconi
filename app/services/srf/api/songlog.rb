class Srf::Api::Songlog
  def initialize(songlog)
    @songlog = songlog
  end

  def items
    @items ||= @songlog.map(&method(:to_songlog_item))
  end

  private

  def to_songlog_item(item)
    Songlog::Item.new(item)
  end
end
