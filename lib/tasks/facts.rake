namespace :facts do
  desc 'Gathers all facts'
  task all: :environment do
    Rake::Task['facts:songs:all'].invoke
  end

  namespace :songs do
    desc 'Gathers all facts for songs'
    task all: :environment do
      Rake::Task['facts:songs:first_broadcasted'].invoke
    end

    desc 'Gathers first broadcasts for songs'
    task first_broadcasted: :environment do
      Facts::Songs::FirstBroadcasted.call!
    end
  end
end
