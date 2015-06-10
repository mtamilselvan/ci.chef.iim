
#TODO some way to check if IIM is already installed, and don't do anything if it is. 

# install IBM Instalation Manager

im_user = node[:im][:user]
im_group = node[:im][:group]
im_base_dir = node[:im][:base_dir]
scratch_dir = "#{Chef::Config[:file_cache_path]}/iim"

group im_group do
  not_if { im_group == node['root_group'] }
end

user im_user do
  comment 'IBM Installation Manager'
  gid im_group
  home im_base_dir
  shell '/bin/sh'
  system true
  not_if { im_user == 'root' }
end

directory im_base_dir do
  group im_group
  owner im_user
  mode "0755"
  recursive true
end

directory scratch_dir do
  group im_group
  owner im_user
  mode '0755'
  recursive true
end

zip_file = node[:im][:install_zip][:file]

if not zip_file.nil?
  zip_filename = ::File.basename(zip_file)
else 
  zip_uri = ::URI.parse(node[:im][:install_zip][:url])
  zip_filename = ::File.basename(zip_uri.path)
  zip_file = "#{Chef::Config[:file_cache_path]}/#{zip_filename}" 
  remote_file zip_file do
    source node[:im][:install_zip][:url]
    user im_user
    group im_group
  end
end

package 'unzip' unless platform?('aix')

execute "unpack #{zip_filename}" do
  cwd scratch_dir
  command "unzip #{zip_file}" 
  user im_user
  group im_group
  creates "#{scratch_dir}/userinstc"
end

if im_user == 'root' then
  execute 'imcl install' do
    command "#{scratch_dir}/tools/imcl install com.ibm.cic.agent -repositories #{scratch_dir}/repository.config -installationDirectory #{im_base_dir}/eclipse -accessRights admin -acceptLicense"
  end
else
  execute 'imcl install' do
    command "#{scratch_dir}/tools/imcl install com.ibm.cic.agent -repositories #{scratch_dir}/repository.config -installationDirectory #{im_base_dir}/eclipse -accessRights nonadmin -acceptLicense"
  end
end
