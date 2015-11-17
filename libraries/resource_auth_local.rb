require 'chef/resource'

class Chef
  class Resource
    class Rancher
      class AuthLocal < Chef::Resource
        #
        # What provider this resource provides
        #
        provides :rancher_auth_local

        def initialize(name, run_context = nil)
          super
          @resource_name = :rancher_auth_local
          @provider = Chef::Provider::Rancher::AuthLocal
          @admin_username = name
          @allowed_actions.push(:enable)
          @action = :enable
        end

        def admin_username(arg = nil)
          set_or_return(
              :admin_username,
              arg,
              :kind_of => String
          )
        end

        def admin_password(arg = nil)
          set_or_return(
              :admin_password,
              arg,
              :required => true,
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
