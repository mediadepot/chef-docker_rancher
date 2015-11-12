#
# Cookbook Name:: docker_rancher
# Resource:: docker_rancher_agent
#
# Copyright (C) 2015 Jason Kulatunga
#
# MIT
#

actions :create, :delete, :nothing

default_action :create

attribute :container_name, :name_attribute => true, :kind_of => String, :required => false, :default => 'rancher_agent'

attribute :manager_ipaddress, :kind_of => String, :required => true, :default => ''

attribute :manager_port, :kind_of => String, :required => false, :default => '8080'

attribute :single_node_mode, :kind_of => [ TrueClass, FalseClass ], :required => false, :default => false

attribute :api_token, :kind_of => String, :required => false, :default => ''

attribute :tag, :kind_of => String, :required => false, :default => 'latest'

attribute :repo, :kind_of => String, :required => false, :default => 'rancher/agent'
