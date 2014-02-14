require 'mina/bundler'
require 'mina/rails'
require 'mina/git'

set :domain, '4ye-evaluation.mindpin.com'
set :deploy_to, '/web/2013/4ye_evaluation'
set :current_path, 'current'
set :repository, 'git://gitcafe.com/ben7th/android-4ye-web.git'
set :branch, 'evaluation'
set :user, 'root'

set :shared_paths, [
  'log', 
  'tmp/pids',
  'config/database.yml',
  "config/mongoid.yml",
  'config/initializers/r.rb',
  '.ruby-version', 
  'deploy/sh/property.yaml'
]

task :environment do
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]

  queue! %[mkdir -p "#{deploy_to}/shared/config/initializers"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[mkdir -p "#{deploy_to}/shared/deploy/sh"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/deploy/sh"]
  
  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue! %[touch "#{deploy_to}/shared/config/mongoid.yml"]
  queue! %[touch "#{deploy_to}/shared/config/initializers/r.rb"]
  queue! %[touch "#{deploy_to}/shared/.ruby-version"]
  queue! %[touch "#{deploy_to}/shared/deploy/sh/property.yaml"]

  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
  queue  %[echo "-----> Be sure to edit 'shared/config/mongoid.yml'."]
  queue  %[echo "-----> Be sure to edit 'shared/config/initializers/r.rb'."]
  queue  %[echo "-----> Be sure to edit 'shared/.ruby-version'."]
  queue  %[echo "-----> Be sure to edit 'shared/deploy/sh/property.yaml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    queue! "bundle"
    # invoke :'bundle:install'
    # invoke :'rails:db_migrate'
    queue! "rake db:create RAILS_ENV=production"
    queue! "rake db:migrate RAILS_ENV=production"
    invoke :'rails:assets_precompile'

    to :launch do
      queue %[
        source /etc/profile
        ./deploy/sh/unicorn.sh stop
        ./deploy/sh/unicorn.sh start
      ]
    end
  end
end

desc "update code only"
task :update_code => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
  end
end

desc "restart server"
task :restart => :environment do
  queue %[
    source /etc/profile
    cd #{deploy_to}/#{current_path}
    ./deploy/sh/unicorn.sh stop
    ./deploy/sh/unicorn.sh start
  ]
end
