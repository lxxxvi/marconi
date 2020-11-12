namespace :heroku do
  desc 'Runs daily on Heroku'
  task daily: :environment do
    Rake::Task['srf3:synchronize'].invoke
    Rake::Task['broadcasts:create_cleaned_broadcasts'].invoke
    Rake::Task['facts:all'].invoke
    Rake::Task['predict'].invoke
  end
end
