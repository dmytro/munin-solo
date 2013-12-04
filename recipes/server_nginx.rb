#
# Cookbook Name:: munin
# Recipe:: server_nginx
#
# Copyright 2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "nginx"


%w(default 000-default).each do |disable_site|
  nginx_site disable_site do
    enable false
    notifies :reload, 'service[nginx]'
  end
end

munin_conf = File.join(node['nginx']['dir'], 'sites-available', 'munin.conf')

template munin_conf do
  source 'nginx.conf.erb'
  mode 0644
  variables(
    :public_domain => node['munin']['public_domain'],
    :nginx_fastcgi_support => node['munin']['nginx_fastcgi_support'],
    :docroot => node['munin']['docroot'],
    :log_dir => node['nginx']['log_dir'],
    :listen_port => node['munin']['web_server_port'],
    :htpasswd_file => File.join(node['munin']['basedir'], 'htpasswd.users')
  )
  if(::File.symlink?(munin_conf))
    notifies :reload, 'service[nginx]'
  end
end

nginx_site 'munin.conf'
