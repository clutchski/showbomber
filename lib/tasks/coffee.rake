
namespace "coffee" do

  def coffee(watch=false)
    opts = (watch) ? '--watch' : ''
    sh("coffee #{opts} -b -o public/javascripts -c app/scripts")
  end

  desc "Compile coffeescripts."
  task "compile" do
    coffee()
  end

  desc "Watch coffeescripts."
  task "watch" do
    coffee(true)
  end
end
