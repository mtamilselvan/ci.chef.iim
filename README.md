# Description

This cookbook installs IBM Installation Manager and provides lightweight resource/providers (LWRPs) that can be used to install IBM products using the IBM Installation Manager. You can use the iim_name_install LWRP to install the package using the default configuration options, or you can have full control over the configuration of your installation by using the iim_response_file_install LWRP with a response file that defines your configuration.

For further details about the IBM Installation Manager, see http://www-01.ibm.com/support/knowledgecenter/SSDV2W_1.8.0/com.ibm.cic.agent.ui.doc/helpindex_imic.html?cp=SSDV2W_1.8.0%2F0&lang=en




# Requirements

## Platform:

* Linux

## Cookbooks:

*No dependencies defined*

# Attributes

* `node[:im][:user]` - User and Group name under which the server will be installed and running. Defaults to `"im"`.
* `node[:im][:group]` -  Defaults to `"im-admin"`.
* `node[:im][:user_home_dir]` - Home directory for +im user+. The attribute is ignored if +im user+ is root.
For nonAdmin access mode, IBM Installation 'Manager (IM)'s registry is found at +user_home_dir/etc/.ibm/registry/InstallationManager.dat+
The registry path MUST NOT be equal to a parent directory or a subdirectory of +base_dir+. Defaults to `"/home/im"`.
* `node[:im][:base_dir]` - Base installation directory. Defaults to `"/opt/IBM/InstallationManager"`.
* `node[:im][:data_dir]` - Data directory. Defaults to `"/var/ibm/InstallationManager"`.
* `node[:im][:install_zip][:file]` - The IM install zip file. Set this if the installer is on a local filesystem. Defaults to `"nil"`.
* `node[:im][:install_zip][:url]` - The IM install zip url. Set this if the installer is on a remote fileserver. Defaults to `"nil"`.
* `node[:im][:access_mode]` - The mode in which the installation is run. Valid options are: 'admin' 'nonAdmin' and 'group'. Defaults to `"nonAdmin"`.
* `node[:im][:secure_storeage_file]` - A default secure storage file, which is only used if the cookbook that calls the provider does not supply its own secure storage file. Defaults to `"nil"`.
* `node[:im][:master_password_file]` - A default master password file, which is only used if the cookbook that calls the provider does not supply its own master password and secure storage files. Defaults to `"nil"`.

# Recipes

* iim::default

# Resources

* [iim_install](#iim_install)
* [iim_name_install](#iim_name_install) - Installs an IBM product by executing the IBM Installation Manager using the default configuration options.
* [iim_response_file_install](#iim_response_file_install) - Installs an IBM product by executing the IBM Installation Manager with a response file.

## iim_install


A backend resource wrapped by +name_install+ and +response_file_install+

### Actions

- install:  Default action.

### Attribute Parameters

- install_command_snippet:  Defaults to <code>nil</code>.
- secure_storage_file:  Defaults to <code>nil</code>.
- master_password_file:  Defaults to <code>nil</code>.

## iim_name_install


Installs an IBM product by executing the IBM Installation Manager using the default configuration options.

### Actions

- install: Installs an IBM Offering Default action.

### Attribute Parameters

- secure_storage_file: Sets the +secureStorageFile+ +imcl+ option. Defaults to <code>nil</code>.
- master_password_file: Sets the +masterPasswordFile+ +imcl+ option. Defaults to <code>nil</code>.
- repositories: The repository to search. Multiple repositories can be specified with a comma-separated list. Defaults to <code>nil</code>.
- install_directory: The directory in which to install the package. Defaults to <code>nil</code>.

### examples

Installing from a repository

```ruby
iim_name_install Package.Name do
  repositories "repository.ibm.com"
end
```

Installing from a password protected repository

```ruby
iim_name_install Package.Name do
  repositories "repository.ibm.com"
  secure_storage_file /path/to/secure_storage_file
  master_password_file /path/to/master_password_file
end
```

## iim_response_file_install


Installs an IBM product by executing the IBM Installation Manager with a response file.

### Actions

- install: Installs an IBM Product Default action.

### Attribute Parameters

- response_file: The response file for the IBM Installation Manager. Takes priority over +response_hash+ Defaults to <code>nil</code>.
- response_hash: A hash representation of the response file's xml content. Defaults to <code>nil</code>.
- secure_storage_file: Sets the +secureStorageFile+ +imcl+ option. Defaults to <code>nil</code>.
- master_password_file: Sets the +masterPasswordFile+ +imcl+ option. Defaults to <code>nil</code>.

### Examples

Installing an offering using a response hash.

```ruby
iim_response_file_install 'Websphere 8.5.5' do
  response_hash(
        :'clean' => true,
        :'temporary' => false,
        :'server' => {
                :'repository' => {
                        :'location' => 'http://some.url'
                }
        },
        :'profile' => {
                :'id' => 'IBM Websphere Application Server V8.5',
                :'installLocation' => '/some/dir',
                :'data' => [
                        {:'key' => 'cic.selector.os', :'value' => 'linux'},
                        {:'key' => 'cic.selector.ws', :'value' => 'gtk'},
                        {:'key' => 'cic.selector.arch', :'value' => 'x86_64'},
                        {:'key' => 'cic.selector.nl', :'value' => 'en'},
                ]
        },
        :'install' => {
                :'modify' => false,
                :'offering' => [
                        {
                                :'id' => 'com.ibm.websphere.BASE.v85',
                                :'version' => 'someversion',
                                :'profile' => 'IBM Websphere Application Server V8.5',
                                :'features' => 'core.feature',
                                :'installFixes' => 'none'
                        }
                ]
        }
)
end
```

Installs an IBM product by using a response file. The template resource must be provided by the user

```ruby
im_response_file = '/var/tmp/my-response-file'

template im_response_file do
  source 'response-file.xml.erb'
  variables(
    :repository_url => 'some_url'
  )
end

iim_response_file_install 'Websphere 8.5.5' do
  response_file im_response_file
end
```

# Author

Author:: Benjamin Confino

Author:: Felix Simmendinger (<felix.simmendinger@coremedia.com>)

Author:: Julian Dunn
