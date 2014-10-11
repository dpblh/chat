# config valid only for Capistrano 3.1
lock '3.2.1'
set :rvm_type, :user
# set :rvm_ruby_version, '2.0.0p481'
application = 'chat'
shared_path = ''
set :application, application
set :repo_url, 'git@github.com:dpblh/chat.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/var/www/#{application}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'setup'
  task :setup do
    on roles(:all) do
      execute "mkdir  #{shared_path}/config/"

      upload!('shared/database.yml', "#{shared_path}/config/database.yml")
      upload!('shared/oauth.yml', "#{shared_path}/config/oauth.yml")
      upload!('shared/private_pub.yml', "#{shared_path}/config/private_pub.yml")
      upload!('shared/secrets.yml', "#{shared_path}/config/secrets.yml")

      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:create'
        end
      end

    end
  end

  desc 'create symlink'
  task :symlink do
    on roles(:all) do
      execute "rm #{release_path}/config/database.yml"
      execute "rm #{release_path}/config/oauth.yml"
      execute "rm #{release_path}/config/private_pub.yml"
      execute "rm #{release_path}/config/secrets.yml"

      execute "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      execute "ln -s #{shared_path}/config/oauth.yml #{release_path}/config/oauth.yml"
      execute "ln -s #{shared_path}/config/private_pub.yml #{release_path}/config/private_pub.yml"
      execute "ln -s #{shared_path}/config/secrets.yml #{release_path}/config/secrets.yml"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :updating, 'deploy:symlink'

  before :setup, 'deploy:starting'
  before :setup, 'deploy:updating'
  before :setup, 'bundler:install'

end

namespace :private_pub do
  desc 'Start private_pub server'
  task :start do
    run "cd #{current_path};rackup private_pub.ru -s thin -E production -D -P tmp/pids/private_pub.pid"
  end

  desc 'Stop private_pub server'
  task :stop do
    run "cd #{current_path};if [ -f tmp/pids/private_pub.pid ] && [ -e /proc/$(cat tmp/pids/private_pub.pid) ]; then kill -9 `cat tmp/pids/private_pub.pid`; fi"
  end

  desc 'Restart private_pub server'
  task :restart do
    find_and_execute_task('private_pub:stop')
    find_and_execute_task('private_pub:start')
  end
end

