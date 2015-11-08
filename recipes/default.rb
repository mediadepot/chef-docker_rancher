#
# Cookbook Name:: chef-rancher
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# start the docker service
docker_service 'default' do
  action [:create, :start]
end

rancher_server 'depot_rancher_server' do
  settings({
    'catalog.url' => 'https://github.com/prachidamle/rancher-catalog.git'
  })
end

rancher_agent 'depot_rancher_agent' do
  manager_ipaddress node['ipaddress']
  single_node_mode true
end
