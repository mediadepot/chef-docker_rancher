#
# Cookbook Name:: docker_rancher
# Provider:: docker_rancher_agent
#
# Copyright (C) 2015 Jason Kulatunga
#
# MIT
#

use_inline_resources #Notifications are impacted here.  if you do delayed notifications, they will be performed at the end of the resource run
#and not at the end of the chef run.  You do want to use this as it also affects internal resource notifications.

#Create Action
action :create do

  # Pull the rancher/agent image
  docker_image new_resource.repo do
    tag new_resource.tag
    action :pull
    #notifies :redeploy, "docker_container[#{new_resource.name}]"
  end

  #sudo docker run -d --restart=always -p 8080:8080 rancher/server
  # Run container exposing ports
  docker_container new_resource.name do
    repo new_resource.repo
    tag new_resource.tag
    privileged true
    command "http://#{new_resource.manager_ipaddress}#{new_resource.manager_port.empty? ? '': ":#{new_resource.manager_port}"}"
    restart_policy new_resource.restart_policy
    env lazy {
          env_settings = []
          if(new_resource.single_node_mode)
            env_settings.push("CATTLE_AGENT_IP=#{new_resource.manager_ipaddress}")
          end
          env_settings
        }
    binds [ '/var/run/docker.sock:/var/run/docker.sock' ]
  end

  new_resource.updated_by_last_action(true)
end

action :delete do
  new_resource.updated_by_last_action(true)
end
