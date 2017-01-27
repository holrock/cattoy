# config valid only for current version of Capistrano
lock '3.7.1'

set :application, 'cattoy'
set :repo_url, 'https://github.com/holrock/cattoy.git'

set :keep_releases, 5

set :migration_role, :db
set :migration_servers, -> { primary(fetch(:migration_role)) }
set :conditionally_migrate, true
set :assets_roles, [:app]
#set :normalize_asset_timestamps, %w{public/images public/javascripts public/stylesheets}
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle')
#set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
#set :linked_files, fetch(:linked_files, []).push('config/puma.rb', 'config/secrets.yml')

# puma
set :puma_conf,      "#{shared_path}/config/puma.rb"
set :puma_threads,    [4, 16]
set :puma_workers,    0
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
      execute "mkdir #{shared_path}/config -p"
    end
  end

end
before 'deploy:started', 'puma:make_dirs'

namespace :deploy do
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  #desc 'Restart application'
  #task :restart do
    #on roles(:app), in: :sequence, wait: 5 do
      #invoke 'puma:restart'
    #end
  #end

  #after :publishing, :restart
end
