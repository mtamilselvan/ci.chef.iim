
#TODO some way to check if IIM is already installed, and don't do anything if it is. 

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
    comment 'IBM Installation Manager'
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

if not zip_file == ''
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

execute "install #{zip_filename}" do
  cwd im_base_dir
  command "unzip #{zip_file}" 
  user im_user
  group im_group
  not_if { ::File.exists?("#{im_base_dir}/userinstc") }
end

if im_user == "root" then
    
        ruby_block "get the version number of IM to be installed" do
          block do
            im_version_no = Mixlib::ShellOut.new("grep -o -P '(?<=im.internal.version\=)[0-9\._]*' #{im_base_dir}/configuration/config.ini").run_command.stdout.rstrip
            node.run_state['im_version_no'] = im_version_no

            raise "Error setting fetching the version number from #{im_base_dir}/configuration/config.ini - I got #{im_version_no}" unless im_version_no =~ /\A[0-9\._]+\Z/

          end
        end

        template "#{im_base_dir}/install.xml" do
          variables(
            lazy {
              {:version_number => node.run_state['im_version_no']}
            }
          )
          source "install.xml.erb"
          action :create
        end    
    
	execute "installc" do
	  cwd im_base_dir
	  command "./installc -log /tmp/IMinstall.log -acceptLicense -dataLocation #{im_base_dir}/IBM/InstallationManager/" 
	  user im_user
	  group im_group
	end
else 
	execute "userinstc" do
	  cwd im_base_dir
	  command "./userinstc -log /tmp/IMinstall.log -acceptLicense" 
	  user im_user
	  group im_group
	end
end
