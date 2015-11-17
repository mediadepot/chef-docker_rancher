#
# Cookbook Name:: docker_rancher
# Provider:: docker_rancher_auth_local
#
# Copyright (C) 2015 Jason Kulatunga
#
# MIT
#
require 'json'
require_relative 'http_request'
require 'chef/provider/lwrp_base'

#Create Action
class Chef
  class Provider
    class Rancher
      class ApiKey < Chef::Provider::LWRPBase
        use_inline_resources #Notifications are impacted here.  if you do delayed notifications, they will be performed at the end of the resource run
        #and not at the end of the chef run.  You do want to use this as it also affects internal resource notifications.


        def whyrun_supported?
          true
        end

        # enabling local authenication on rancher should only happen once.
        # to ensure that this doesn't occur multiple times, this
        action :create do
          if(node['rancher']['flag']['authenticated'] && (!node['rancher']['automation_api_key'] || !node['rancher']['automation_api_secret']))
            Chef::Log.warn('The rancher.flag.authenticated flag is set. This implies that the rancher manager requires ' +
                               'authentication. The automation_api_key and automation_api_secret are not set.')
          end

          endpoint = "http://#{new_resource.manager_ipaddress}"
          endpoint += ":#{new_resource.manager_port}" if new_resource.manager_port
          # first step iscr to eate an api token

          data = {'accountId' => '1a1'}
          data['name'] = new_resource.key_name if new_resource.key_name
          data['description'] = new_resource.description if new_resource.description

          response = post("#{endpoint}/v1/apikeys",{},data)
          payload = JSON.parse(response)
          Chef::Log.info("#{payload}")

        end

        private


      end
    end
  end
end
