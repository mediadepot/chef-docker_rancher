#
# Cookbook Name:: docker_rancher
# Provider:: rancher_auth_local
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
      class AuthLocal < Chef::Provider::LWRPBase
        use_inline_resources #Notifications are impacted here.  if you do delayed notifications, they will be performed at the end of the resource run
#and not at the end of the chef run.  You do want to use this as it also affects internal resource notifications.


        def whyrun_supported?
          true
        end

        # enabling local authenication on rancher should only happen once.
        # to ensure that this doesn't occur multiple times, this
        action :enable do
          if(node['rancher']['flag']['authenticated'])
            Chef::Log.warn('The rancher.flag.authenticated flag is already set. This rancher manager may already require ' +
                               'authentication. If so, this resource will fail to execute properly. You can fix this by adding '+
                               '"only_if node[:rancher][:flag][:authenticated]" to the resource')
          end

          endpoint = "http://#{new_resource.manager_ipaddress}"
          endpoint += ":#{new_resource.manager_port}" if new_resource.manager_port
          # first, find the default environment id
          env = get_default_environment(endpoint)
          # second, create a new api key in the environment
          payload = create_api_key(env)

          #now use this api token for all further processing on this chef node
          node.set['rancher']['automation_api_key'] = payload['publicValue']
          node.set['rancher']['automation_api_secret'] = payload['secretValue']

          #create the localAuthConfig request
          enable_local_auth(endpoint)

          node.set['rancher']['flag']['authenticated'] = true
          new_resource.updated_by_last_action(true)
        end

        private

        def get_default_environment(endpoint)
          # first, find the default environment id
          envs_payload = get("#{endpoint}/v1/projects")
          Chef::Log.info("#{envs_payload}")

          ndx = envs_payload['data'].find_index{ |env|
            env['name'] == 'Default'
          }
          return envs_payload['data'][ndx]
        end

        def create_api_key(env)
          apikeys_endpoint = env['links']['apiKeys']
          api_data = {}
          api_data['name'] = 'automation_api_key'
          api_data['description'] = 'Api key used by the docker_rancher cookbook'

          payload = post(apikeys_endpoint,{},api_data)
          Chef::Log.info("#{payload}")
          return payload
        end

        def enable_local_auth(endpoint)
          local_auth_data = {
              'type' => 'localAuthConfig',
              'accessMode' => 'unrestricted',
              'enabled' => true,
              'name' => 'Admin user',
              'username' => @new_resource.admin_username,
              'password' => @new_resource.admin_password
          }
          payload = post("#{endpoint}/v1/localAuthConfig",{},local_auth_data,{},{
              :username=>node['rancher']['automation_api_key'],
              :password=>node['rancher']['automation_api_secret'],
          })
          Chef::Log.info("#{payload}")
        end

      end
    end
  end
end
