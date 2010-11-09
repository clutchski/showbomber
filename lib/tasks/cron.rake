#
# Rakefile to control Heroku's cron task.
#


require 'lib/apis/wfmu.rb'


desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  puts 'Running cron.'
  WFMU::run
  puts 'Finished run cron.'
end
