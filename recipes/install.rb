# install IBM Instalation Manager

im_user = node[:im][:user]
im_group = node[:im][:group]

im_base_dir = "#{node[:im][:base_dir]}"

# Don't create 'root' group - allows execution as root
if im_group != "root"
  group im_group do
  end
end

# Don't create 'root' user - allows execution as root
if im_user != "root"
  user im_user do
    comment 'IBM Instalation Manager'
    gid im_group
    home im_base_dir
    shell '/bin/bash'
    system true
  end
end

directory im_base_dir do
  group im_group
  owner im_user
  mode "0755"
  recursive true
end

zip_file = "#{node[:im][:install_zip][:file]}"

if zip_file
  zip_filename = ::File.basename(zip_file)
#else 
#  zip_uri = ::URI.parse(node[:im][:install_zip][:url])
#  zip_filename = ::File.basename(zip_uri.path)
#  zip_file = "#{Chef::Config[:file_cache_path]}/#{zip_filename}" 
#  remote_file zip_file do
#    source node[:im][:install_zip][:url]
#    user node[:im][:user]
#    group node[:im][:group]
#    not_if { ::File.exists?(im_install_dir) }
#  end
end

package 'unzip'

execute "install #{zip_filename}" do
  cwd node[:im][:base_dir]
  command "unzip #{zip_file}" 
  user node[:im][:user]
  group node[:im][:group]
  not_if { ::File.exists?("#{im_base_dir}/userinstc") }
end

execute "userinstc" do
  cwd node[:im][:base_dir]
  command "./userinstc -log someLogFile -acceptLicense" 
  user node[:im][:user]
  group node[:im][:group]
end
