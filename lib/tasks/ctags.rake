
desc "Generate tags file"
task :ctags do 
  sh('ctags -R --exclude="*vendor*" --exclude="*.js" .')
end
