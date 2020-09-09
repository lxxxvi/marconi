namespace :broadcasts do
  desc 'Creates cleaned_broadcasts table'
  task create_cleaned_broadcasts: :environment do
    CleanedBroadcastsTableCreator.create!
  end
end
