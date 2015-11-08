#
# Cookbook Name:: rancher
# Resource:: rancher_server
#
# Copyright (C) 2015 Jason Kulatunga
#
# MIT
#

actions :create, :delete

default_action :create

attribute :container_name, :name_attribute => true, :kind_of => String, :required => false, :default => 'rancher_server'

attribute :port, :kind_of => String, :required => false, :default => '8080'

attribute :tag, :kind_of => String, :required => false, :default => 'latest'

attribute :repo, :kind_of => String, :required => false, :default => 'rancher/server'

attribute :restart_policy, :kind_of => String, :required => false, :default => 'always'

attribute :settings, :kind_of => Hash, :required => false, :default => {}
