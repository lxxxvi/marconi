namespace :facts do
  desc 'Gathers all facts'
  task all: :environment do
    Rake::Task['facts:songs:all'].invoke
    Rake::Task['facts:stations:all'].invoke
    Rake::Task['facts:artists:all'].invoke
  end

  namespace :artists do
    desc 'Gathers all facts for artists'
    task all: :environment do
      Rake::Task['facts:artists:total_broadcasts'].invoke
    end

    desc 'Gathers total broadcasts for artists'
    task total_broadcasts: :environment do
      Facts::Artist::TotalBroadcastsCalculator.new.call!
    end
  end

  namespace :stations do
    desc 'Gathers all facts for stations'
    task all: :environment do
      Rake::Task['facts:stations:total_broadcasts'].invoke
    end

    desc 'Gathers total broadcasts for stations'
    task total_broadcasts: :environment do
      Facts::Station::TotalBroadcastsCalculator.new.call!
    end
  end

  namespace :songs do
    desc 'Gathers all facts for songs'
    task all: :environment do
      Rake::Task['facts:songs:first_broadcast'].invoke
      Rake::Task['facts:songs:latest_broadcast'].invoke
      Rake::Task['facts:songs:total_broadcasts'].invoke
      Rake::Task['facts:songs:average_seconds_between_broadcasts'].invoke
    end

    desc 'Gathers first broadcasts for songs'
    task first_broadcast: :environment do
      Facts::Song::FirstBroadcastedAtCalculator.new.call!
    end

    desc 'Gathers latest broadcasts for songs'
    task latest_broadcast: :environment do
      Facts::Song::LatestBroadcastedAtCalculator.new.call!
    end

    desc 'Gathers total broadcasts for songs'
    task total_broadcasts: :environment do
      Facts::Song::TotalBroadcastsCalculator.new.call!
    end

    desc 'Gathers average seconds between broadcasts for songs'
    task average_seconds_between_broadcasts: :environment do
      Facts::Song::AverageSecondsBetweenBroadcastsCalculator.new.call!
    end
  end
end
