namespace "build" do

  desc "Watch coffee script, closure deps"
  task "development" =>  ['coffee:compile', 'javascript:compile', 'coffee:watch']

  desc "Prepare js for deployment"
  task "production" => ['coffee:compile', 'javascript:minify']

end
