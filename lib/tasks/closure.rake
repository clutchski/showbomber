namespace "javascript" do

  def closurize(format)
    closure_dir = 'lib/tasks/closure'
    js_dir = 'public/javascripts'
    
    cmd = ["python #{closure_dir}/bin/calcdeps.py"]
    cmd << "-i #{js_dir}/ready.js"
    cmd << "-p #{js_dir}"
    cmd << "-c #{closure_dir}/compiler.jar"
    cmd << "-o #{format}"
    cmd << "--output_file=#{js_dir}/app.js"

    sh cmd.join(' ')
  end

  desc "Compile javascripts."
  task "compile" do
    closurize('deps')
  end

  desc "Minify javascripts."
  task "minify" do
    closurize('compiled')
  end


end