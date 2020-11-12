task predict: :environment do
  PredictionResultService.new.save
  PredictionService.new.save
end
