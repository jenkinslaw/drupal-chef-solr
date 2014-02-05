#
# Cookbook Name:: solr
# Recipe:: default
#
# Copyright 2013, David Radcliffe
#

include_recipe 'java'

if platform_family?('debian')
  initd_template = 'initd.debian.erb'
else
  initd_template = 'initd.erb'
end

ark 'solr' do
  url node['solr']['url']
  version node['solr']['version']
  home_dir node['solr']['dir']
  action :install
end

directory node['solr']['data_dir'] do
  owner 'root'
  group 'root'
  action :create
end

template '/var/lib/solr.start' do
  source 'solr.start.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables(
    :solr_dir => node['solr']['dir'],
    :solr_home => node['solr']['data_dir'],
    :port => node['solr']['port'],
    :pid_file => '/var/run/solr.pid',
    :log_file => '/var/log/solr.log'
  )
end

template '/etc/init.d/solr' do
  source initd_template
  owner 'root'
  group 'root'
  mode '0755'
  variables(
    :solr_dir => node['solr']['dir'],
    :solr_home => node['solr']['data_dir'],
    :port => node['solr']['port'],
    :pid_file => '/var/run/solr.pid',
    :log_file => '/var/log/solr.log'
  )
end

service 'solr' do
  supports :restart => true, :status => true
  action [:enable, :start]
end
