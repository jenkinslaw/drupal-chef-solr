#
# Cookbook Name:: solr
# Recipe:: drupal
#
# Copyright 2014, David Kinzer
#

ark "apachesolr-#{node['solr']['drupal']['version']}" do
  url node['solr']['drupal']['url']
  version node['solr']['drupal']['version']
  path "/tmp"  
  action :put
end

ruby_block 'configure apachesolr-drupal' do
  block do
    require 'fileutils'
    node['solr']['drupal']['config_files'].each do |file|
      FileUtils.cp(
        "/tmp/#{node['solr']['drupal']['config_files_path']}/#{file}",
        "#{node['solr']['data_dir']}/#{node['solr']['config']}/#{file}"
      )
    end
  end
  not_if {
    node['solr']['drupal']['config_files'].reduce(true) do |identical, file|
    break unless identical
    identical && File.identical?(
      "/tmp/#{node['solr']['drupal']['config_files_path']}/#{file}",
      "#{node['solr']['data_dir']}/#{node['solr']['config']}/#{file}"
    )
    end
  }
  notifies :restart, "service[solr]"
end

if node['solr']['drupal']['disable_stemming']
  content_type_a = "text"
  content_type_b = "text_und"
else
  content_type_a = "text_und"
  content_type_b = "text"
end

bash "Disable solr stemming." do
  cwd node['solr']['drupal']['config_files_path']
  code <<<-EOH
  sed -i 's/<field name="content" type="#{content_type_a}"/<field name="content" type="#{content_type_b}"/g' schema.xml
  EOH
end
