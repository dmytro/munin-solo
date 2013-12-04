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


package "logtail" # Required for nginx_traffic

# http://zeldor.biz/2011/01/nginx-plugins-for-munin/

[ "nginx_memory", "nginx_request", "nginx_status", "nginx_traffic" ].each do  |plg|
  munin_plugin plg do
    plugin plg
    create_file true
    notifies :restart, "service[munin-node]"
  end
end

template "#{node['munin']['basedir']}/plugin-conf.d/nginx_traffic" do
  source "plugin-conf.d/nginx_traffic.erb"
  mode 0644
  notifies :restart, resources(:service => "munin-node")
end
