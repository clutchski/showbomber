#
# Rakefile to control Heroku's cron task.
#


require './lib/etl/etl.rb'


desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  puts 'Running cron.'
  ETL::run
  puts 'Finished run cron.'
end
