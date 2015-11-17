#
# Cookbook Name:: docker_rancher
# Provider:: rancher_agent
#
# Copyright (C) 2015 Jason Kulatunga
#
# MIT
#
require_relative 'http_request'
require 'chef/provider/lwrp_base'

#Create Action
class Chef
  class Provider
    class Rancher
      class Agent < Chef::Provider::LWRPBase
        use_inline_resources #Notifications are impacted here.  if you do delayed notifications, they will be performed at the end of the resource run
        #and not at the end of the chef run.  You do want to use this as it also affects internal resource notifications.


        def whyrun_supported?
          true
        end

        # enabling local authenication on rancher should only happen once.
        # to ensure that this doesn't occur multiple times, this
        action :create do

          endpoint = "http://#{new_resource.manager_ipaddress}"
          endpoint += ":#{new_resource.manager_port}" if new_resource.manager_port
          command_url = endpoint

          if(node['rancher']['flag']['authenticated'])
            Chef::Log.warn('The rancher.flag.authenticated flag is set. This implies that the rancher manager requires ' +
                             'authentication.')
          end

          if node['rancher']['automation_api_key'] && node['rancher']['automation_api_secret']

            request_options = {
                :username=>node['rancher']['automation_api_key'],
                :password=>node['rancher']['automation_api_secret'],
            }
            #generate a rancher registration token
            registration_data = {'name' => node['hostname']}
            payload = post("#{endpoint}/v1/registrationtokens",{},registration_data,{},request_options)
            Chef::Log.info("#{payload}")

            #wait a few seconds while the token is generated
            sleep 5

            token_payload = get("#{endpoint}/v1/registrationtokens/#{payload['id']}",{},registration_data,{},request_options)
            Chef::Log.info("#{token_payload}")

            command_url = token_payload['registrationUrl']

            Chef::Log.info("Registering agent using token #{command_url}")
          else
            Chef::Log.warn('The automation_api_key and/or automation_api_secret are not set.' +
              'Unauthenticated agent will be created')
          end

          # Pull the rancher/agent image
          docker_image new_resource.repo do
            tag new_resource.tag
            action :pull
            #notifies :redeploy, "docker_container[#{new_resource.name}]"
          end

          #docker run -e CATTLE_AGENT_IP=10.0.2.15 --privileged -v /var/run/docker.sock:/var/run/docker.sock rancher/agent "http://10.0.2.15:8080"
          # Run container exposing ports
          c = docker_container new_resource.name do
            repo new_resource.repo
            tag new_resource.tag
            privileged true
            command command_url
            env lazy {
                  env_settings = []
                  if(new_resource.single_node_mode)
                    env_settings.push("CATTLE_AGENT_IP=#{new_resource.manager_ipaddress}")
                  end
                  env_settings
                }
            binds [ '/var/run/docker.sock:/var/run/docker.sock' ]
          end

          new_resource.updated_by_last_action(c.updated_by_last_action?)

        end

      end
    end
  end
end
