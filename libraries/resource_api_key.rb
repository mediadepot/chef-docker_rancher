require 'chef/resource'

class Chef
  class Resource
    class Rancher
      class ApiKey < Chef::Resource
        #
        # What provider this resource provides
        #
        provides :rancher_api_key

        def initialize(name, run_context = nil)
          super
          @resource_name = :rancher_api_key
          @provider = Chef::Provider::Rancher::ApiKey
          @key_name = name
          @allowed_actions.push(:create, :deactivate, :activate, :delete)
          @action = :create
        end

        def key_name(arg = nil)
          set_or_return(
              :key_name,
              arg,
              :kind_of => String
          )
        end

        def description(arg = nil)
          set_or_return(
              :description,
              arg,
              :required => false,
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
      end
    end
  end
end
