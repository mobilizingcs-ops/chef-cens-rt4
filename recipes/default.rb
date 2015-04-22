#
# Cookbook Name:: cens-rt4
# Recipe:: default
#
# Author: Steve Nolen <technolengy@gmail.com>
#
# Copyright (c) 2014.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# require chef-vault
chef_gem 'chef-vault'
require 'chef-vault'

# install/enable nginx
node.set['nginx']['default_site_enabled'] = false
node.set['nginx']['install_method'] = 'repo'
include_recipe 'nginx'

# SSL
item = ChefVault::Item.load('ssl', 'mobilizingcs.org')
file "/etc/ssl/certs/mobilizingcs.org.crt" do
  owner 'root'
  group 'root'
  mode '0777'
  content item['cert']
  notifies :reload, 'service[nginx]', :delayed
end
file "/etc/ssl/private/mobilizingcs.org.key" do
  owner 'root'
  group 'root'
  mode '0600'
  content item['key']
  notifies :reload, 'service[nginx]', :delayed
end

# nginx conf
template '/etc/nginx/sites-available/rt' do
  source 'rt4-nginx.conf.erb'
  mode '0755'
  action :create
  notifies :reload, 'service[nginx]', :delayed
end
nginx_site 'rt' do
  action :enable
end

# manage rt4 fcgi service
cookbook_file "/etc/init.d/rt4-fcgi" do
  source "rt4-fcgi"
  mode 0755
end

service 'rt4-fcgi' do
  action [:start, :enable]
  supports :restart => true, :status => true
end
