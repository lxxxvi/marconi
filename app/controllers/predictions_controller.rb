class PredictionsController < ApplicationController
  def index
    render json: Prediction::ForDate.new(date_param).as_json
  end

  private

  def date_param
    @date_param ||= read_date_param
  end

  def read_date_param
    return Time.zone.today if params[:date] == 'today'

    Date.parse(params[:date])
  end
end
