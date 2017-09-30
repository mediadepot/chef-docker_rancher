#
# Cookbook Name:: docker_rancher
# Resource:: rancher_manager
#
# Copyright (C) 2015 Jason Kulatunga
#
# MIT
#
require 'chef/resource'

class Chef
  class Resource
    class Rancher
      class Manager < Chef::Resource
        #
        # What provider this resource provides
        #
        provides :rancher_manager

        def initialize(name, run_context = nil)
          super
          @resource_name = :rancher_manager
          @provider = Chef::Provider::Rancher::Manager
          @container_name = name
          @allowed_actions.push(:create, :delete, :nothing)
          @action = :create
        end

        def container_name(arg = nil)
          set_or_return(
              :container_name,
              arg,
              :kind_of => String,
              :default => 'rancher_server'
          )
        end

        def port(arg = nil)
          set_or_return(
              :port,
              arg,
              :required => false,
              :kind_of => String
          )
        end

        def tag(arg = nil)
          set_or_return(
              :tag,
              arg,
              :required => false,
              :kind_of => String,
              :default => 'stable'
          )
        end

        def repo(arg = nil)
          set_or_return(
              :repo,
              arg,
              :required => false,
              :kind_of => String,
              :default => 'rancher/server'
          )
        end

        def restart_policy(arg = nil)
          set_or_return(
              :restart_policy,
              arg,
              :required => false,
              :kind_of => String,
              :default => 'always'
          )
        end

        def settings(arg = nil)
          set_or_return(
              :settings,
              arg,
              :required => false,
              :kind_of => Hash,
              :default => {}
          )
        end

        def env(arg = nil)
          set_or_return(
              :env,
              arg,
              :required => false,
              :kind_of => Array,
              :default => []
          )
        end

        def binds(arg = nil)
          set_or_return(
              :binds,
              arg,
              :required => false,
              :kind_of => Array,
              :default => []
          )
        end
      end
    end
  end
end
