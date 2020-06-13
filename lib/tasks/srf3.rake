namespace :srf3 do
  desc 'Synchronize SRF3'
  task synchronize: :environment do
    Srf::Synchronizer.new.synchronize!
  end
end
