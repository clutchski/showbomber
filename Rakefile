# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

Radio::Application.load_tasks


namespace "javascript" do

  desc "Watch coffee script, closure deps"
  task "dev" => ['coffee:compile', 'javascript:compile', 'coffee:watch']

  desc "Prepare js for deployment"
  task "deploy" => ['coffee:compile', 'javascript:minify']

  desc "Clean compiled javascript"
  task "clean" do
    sh 'find public/javascripts -name "*.js" | grep -v vendor | xargs rm -f'
  end
end
