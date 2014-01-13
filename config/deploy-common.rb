set :application, "blackbooke"
set :repository,  "git@github.com:gammill/blackbooke.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_to, "/opt/deploy"
#set :deploy_to, "/tmp/deploy/#{application}"

set :user, "bitnami"
set :branch, "master"
ssh_options[:forward_agent] = true

#
# :copy_cache is not needed if deploy_via is :copy...
set :copy_cache, "#{shared_path}/cached-copy"
set :deploy_via, :remote_cache # using :copy will avoid requiring git access from the remote server, but takes forever
#set :deploy_via, :copy # using :remote_cache requires git access from the remote server, but deploys are drastically faster

set :synchronous_connect, true # IMPORTANT, or copies and uploads will hang

ssh_options[:keys] = ["#{ENV['HOME']}/.ssh/youregards-keypair.pem"]



before 'deploy:finalize_update',  'create_public_directory'
after 'deploy:setup', 'set_permissions'
after 'deploy:update_code', 'symlink_current_to_htdocs'

desc 'See remote environment (for testing ssh access)'
task :env, :roles => [:web, :db, :app] do
  run "env"
end

desc 'Create public directory to satisfy capistrano'
task :create_public_directory, :roles => [ :app ] do
  run "mkdir -p #{release_path}/public/stylesheets #{release_path}/public/javascripts #{release_path}/public/images"
end

desc 'Symlink the release to htdocs directory'
task :symlink_current_to_htdocs, :roles => [ :app ] do
  run "rm -f /opt/bitnami/apache2/htdocs && ln -s #{release_path} /opt/bitnami/apache2/htdocs"
end

desc 'Set permissions to user bitnami throughout the deploy directory'
task :set_permissions, :roles => [ :app ] do |variable|
  sudo "chown -R bitnami.bitnami #{deploy_to}"
  sudo "chgrp bitnami /opt/bitnami/apache2/"
  sudo "chmod g+w /opt/bitnami/apache2/"
end