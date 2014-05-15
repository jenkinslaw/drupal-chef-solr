#
# Cookbook Name:: solr
# Attributes:: default
#
# Copyright 2014, David Kinzer
#
default['solr']['drupal']['version']  = '6.x-3.x-dev'
default['solr']['drupal']['url'] = "http://ftp.drupal.org/files/projects/apachesolr-#{node['solr']['drupal']['version']}.tar.gz"
default['solr']['drupal']['config_files'] = ['schema.xml', 'solrconfig.xml', 'protwords.txt']
default['solr']['drupal']['config_files_path'] =
  "apachesolr-#{node['solr']['drupal']['version']}/solr-conf/solr-4.x"
default['solr']['drupal']['disable_stemming'] = FALSE
