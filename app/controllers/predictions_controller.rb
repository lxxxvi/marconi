class PredictionsController < ApplicationController
  def index
    response = { date: date_param }

    response[:predictions] = predictions.map do |prediction|
      {
        score: prediction.score,
        artist: prediction.song.artist.name,
        song: prediction.song.title,
        result: prediction.result
      }
    end

    render json: response
  end

  private

  def predictions
    @predictions ||= Prediction.with_song_and_artist.for_date(date_param).ordered
  end

  def date_param
    @date_param ||= read_date_param
  end

  def read_date_param
    return Time.zone.today if params[:date] == 'today'

    Date.parse(params[:date])
  end
end
