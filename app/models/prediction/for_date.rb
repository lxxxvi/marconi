class Prediction::ForDate
  def initialize(date)
    @date = date
  end

  def as_json
    {
      date: @date,
      total: total,
      played: played,
      played_percentage: played_percentage,
      not_played: not_played,
      predictions: predictions
    }
  end

  private

  def raw_predictions
    @raw_predictions ||= Prediction.with_song_and_artist.for_date(@date).ordered
  end

  def predictions
    @predictions ||= raw_predictions.map do |raw_prediction|
      {
        score: raw_prediction.score,
        artist: raw_prediction.song.artist.name,
        song: raw_prediction.song.title,
        result: raw_prediction.result
      }
    end
  end

  def total
    @total ||= predictions.count
  end

  def played
    @played ||= count_result('PLAYED')
  end

  def played_percentage
    return if results_missing?

    @played_percentage ||= (100.0 * played / total).round(1)
  end

  def not_played
    @not_played ||= count_result('NOT PLAYED')
  end

  def results_missing?
    @results_missing ||= predictions.dig(0, :result).nil?
  end

  def count_result(string)
    return if results_missing?

    predictions.count { |prediction| prediction[:result] == string }
  end
end
