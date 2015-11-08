#
# Cookbook Name:: docker_rancher
# Provider:: docker_rancher
#
# Copyright (C) 2015 Jason Kulatunga
#
# MIT
#

use_inline_resources #Notifications are impacted here.  if you do delayed notifications, they will be performed at the end of the resource run
#and not at the end of the chef run.  You do want to use this as it also affects internal resource notifications.

#Create Action
action :create do

  # Pull the rancher/server image
  docker_image new_resource.repo do
    tag new_resource.tag
    action :pull
    notifies :redeploy, "docker_container[#{new_resource.name}]"
  end

  #sudo docker run -d --restart=always -p 8080:8080 rancher/server
  # Run container exposing ports
  docker_container new_resource.name do
    repo new_resource.repo
    tag new_resource.tag
    port "#{new_resource.port}:8080"
    restart_policy new_resource.restart_policy
    env lazy {
      env_settings = []
      new_resource.settings.each{|key,value|
        setting = "CATTLE_#{key.upcase.split('.').join('_')}=#{value}"
        env_settings.push(setting)
      }
      env_settings
    }
  end

  new_resource.updated_by_last_action(true)
end

action :delete do
  new_resource.updated_by_last_action(true)
end
