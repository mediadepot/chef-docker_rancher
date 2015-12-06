#
# Cookbook Name:: docker_rancher
# Resource:: rancher_agent
#
# Copyright (C) 2015 Jason Kulatunga
#
# MIT
#
require 'chef/resource'

class Chef
  class Resource
    class Rancher
      class Agent < Chef::Resource
        #
        # What provider this resource provides
        #
        provides :rancher_agent

        def initialize(name, run_context = nil)
          super
          @resource_name = :rancher_agent
          @provider = Chef::Provider::Rancher::Agent
          @container_name = name
          @allowed_actions.push(:create, :delete, :nothing)
          @action = :create
        end

        def container_name(arg = nil)
          set_or_return(
              :container_name,
              arg,
              :kind_of => String
          )
        end

        def manager_ipaddress(arg = nil)
          set_or_return(
              :manager_ipaddress,
              arg,
              :required => true,
              :kind_of => String
          )
        end

        def manager_port(arg = nil)
          set_or_return(
              :manager_port,
              arg,
              :required => false,
              :kind_of => String
          )
        end

        def single_node_mode(arg = nil)
          set_or_return(
              :single_node_mode,
              arg,
              :required => false,
              :kind_of => [TrueClass, FalseClass],
              :default => false
          )
        end

        def tag(arg = nil)
          set_or_return(
              :tag,
              arg,
              :required => false,
              :kind_of => String,
              :default => 'latest'
          )
        end

        def repo(arg = nil)
          set_or_return(
              :repo,
              arg,
              :required => false,
              :kind_of => String,
              :default => 'rancher/agent'
          )
          end

        def labels(arg = nil)
          set_or_return(
              :labels,
              arg,
              :required => false,
              :kind_of => Array,
              :default => ''
          )
        end
      end
    end
  end
end
