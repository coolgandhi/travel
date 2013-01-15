namespace :rake do 
  desc "Run the super-awesome rake task"
  task :super_awesome do
    rake = fetch(:rake, 'rake')
    rails_env = fetch(:rails_env, 'production')

    run "cd '#{current_path}' && #{rake} ./lib/tasks/travelertypemetadata.r db:populate RAILS_ENV=#{rails_env}"
  end
end