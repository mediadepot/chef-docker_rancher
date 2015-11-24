#
# Cookbook Name:: docker-rancher
# Recipe:: default
#
# Copyright (C) 2015 Jason Kulatunga
#
# MIT
#

# start the docker service
docker_service 'default' do
  action [:create, :start]
end

rancher_manager 'depot_rancher_server' do
  settings({
    'catalog.url' => 'https://github.com/prachidamle/rancher-catalog.git'
  })
  port '8080'
  notifies :enable, 'rancher_auth_local[depot]', :delayed
  binds ['/etc/profile.d:/etc/profile.d']
end

rancher_auth_local 'depot' do
  admin_password 'd3pot'
  manager_ipaddress node['ipaddress']
  manager_port '8080'
  action :nothing
  notifies :create, 'rancher_agent[depot_rancher_agent]', :delayed
  not_if node['rancher']['flag']['authenticated']
end

rancher_agent 'depot_rancher_agent' do
  manager_ipaddress node['ipaddress']
  single_node_mode true
  manager_port '8080'
  action :nothing
end
