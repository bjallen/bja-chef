include_recipe "build-essential"
include_recipe "git"

git "checkout rbenv" do
  repository "https://github.com/sstephenson/rbenv.git"
  reference "master"
  action :checkout
  user "vagrant"
  group "vagrant"
  destination "/home/vagrant/.rbenv"
end

template "/home/vagrant/.rbenvrc" do
  source "rbenvrc.sh.erb"
  user "vagrant"
  group "vagrant"
end

execute "source rbenvrc" do
  command "echo 'source ~/.rbenvrc' >> /home/vagrant/.bashrc"
  not_if "grep 'source ~/.rbenvrc' .bashrc"
end

directory "/home/vagrant/.rbenv/plugins" do
  owner "vagrant"
  group "vagrant"
  mode "0755"
  action :create
end

git "checkout ruby-build" do
  repository "https://github.com/sstephenson/ruby-build.git"
  reference "master"
  action :checkout
  user "vagrant"
  group "vagrant"
  destination "/home/vagrant/.rbenv/plugins/ruby-build"
end

bash "install ree 1.8.7" do
  user "vagrant"
  group "vagrant"
  cwd "/home/vagrant"
  code <<-EOH
  export HOME="/home/vagrant"
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
  CONFIGURE_OPTS="--no-tcmalloc" rbenv install ree-1.8.7-2012.01
  EOH
end