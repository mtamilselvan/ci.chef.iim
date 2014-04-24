# install IBM Installation Manager

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

if zip_file
  zip_filename = ::File.basename(zip_file)
#else 
#  zip_uri = ::URI.parse(node[:im][:install_zip][:url])
#  zip_filename = ::File.basename(zip_uri.path)
#  zip_file = "#{Chef::Config[:file_cache_path]}/#{zip_filename}" 
#  remote_file zip_file do
#    source node[:im][:install_zip][:url]
#    user im_user
#    group im_group
#    not_if { ::File.exists?(im_install_dir) }
#  end
end

package 'unzip'

execute "install #{zip_filename}" do
  cwd im_base_dir
  command "unzip #{zip_file}" 
  user im_user
  group im_group
  not_if { ::File.exists?("#{im_base_dir}/userinstc") }
end

node.default[:internal_variables][:IM][:version_no] = '9999999'

if im_user == "root" then
    
        ruby_block "get the version number of IM to be installed" do
          block do
            im_version_no = `grep -o -P "(?<=im.internal.version\=)[0-9\._]*" #{im_base_dir}/configuration/config.ini`
   	    im_version_no = im_version_no.rstrip()#TODO throw an exception if the version number was not correctly set

	    #This monstrosity is necessary because the template provider sets all the variables in the erb during compile time. 
	    #The only way to get the variable inside this ruby block - set at execution time (and the file being read wont exist at compile time)
	    #into the template is to explicitly set it inside this block like so:
	    template_r = run_context.resource_collection.find(:template => "#{im_base_dir}/install.xml")
            template_r.variables({ :version_number => im_version_no})
	 end
        end

        template "#{im_base_dir}/install.xml" do
          source "install.xml.erb"
	  #Variables are set in the ruby_block "get the version number of IM to be installed"
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
