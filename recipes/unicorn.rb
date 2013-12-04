#
# Cookbook Name:: nginx
# Recipe:: server
#
# Copyright 2012, Dmytro Kovalov
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

# required for unicorn_connections_ munin plugin
gem_package "raindrops"

template "/etc/munin/plugin-conf.d/unicorn" do 
  group "root"
  mode 0755
  source 'plugin-conf.d/unicorn.erb' 
end
 
munin_plugin "unicorn_status" do
  plugin "unicorn_status"
  create_file true
  notifies :restart, resources(:service => "munin-node")
end

munin_plugin "unicorn_connections_" do
  plugin "unicorn_connections_6880"
  create_file true
  notifies :restart, resources(:service => "munin-node")
end
