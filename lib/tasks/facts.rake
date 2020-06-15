namespace :facts do
  desc 'Gathers all facts'
  task all: :environment do
    Rake::Task['facts:songs:all'].invoke
  end

  namespace :songs do
    desc 'Gathers all facts for songs'
    task all: :environment do
      Rake::Task['facts:songs:first_broadcast'].invoke
      Rake::Task['facts:songs:latest_broadcast'].invoke
    end

    desc 'Gathers first broadcasts for songs'
    task first_broadcast: :environment do
      Facts::Songs::FirstBroadcast.call!
    end

    desc 'Gathers latest broadcasts for songs'
    task latest_broadcast: :environment do
      Facts::Songs::LatestBroadcast.call!
    end
  end
end
