#
# Cookbook Name:: iim
# Provider:: iim_ResponseFileInstall
#
# (C) Copyright IBM Corporation 2013.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

=begin
#<

Installs an IBM product by executing the IBM Installation Manager with a response file. A response file or response file template must be provided by the user.

@action install Installs an IBM Product.

@section Examples

Installs an IBM product from a repository by executing the IBM Installation Manager with a response file. 

```ruby
im_response_file = '/var/tmp/my-response-file'

template im_response_file do
  source 'response-file.xml.erb'
  variables(
    :repository_url => 'some_url',
    :install_dir => 'some_dir'
  )
end

iim_response_file_install 'Websphere 8.5.5' do
  response_file im_response_file
end
```

An example response file template

```ruby
iim_response_file_install 'Websphere 8.5.5' do
  response_hash(
        :'clean' => true,
        :'temporary' => false,
        :'server' => {
                :'repository' => {
                        :'location' => '<%= @repository_url %>'
                }
        },
        :'profile' => {
                :'id' => 'IBM Websphere Application Server V8.5',
                :'installLocation' => '<%= @install_dir %>',
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

#>
=end

actions :install
default_action :install

#<> @attribute response_file The response file for the IBM Installation Manager. Takes priority over `response_hash`.
attribute :response_file, :kind_of => String, :default => nil
#<> @attribute response_hash A hash representation of the response file's xml content.
attribute :response_hash, :kind_of => Hash, :default => nil
#<> @attribute secure_storage_file Sets the `secureStorageFile` `imcl` option.
attribute :secure_storage_file, :kind_of => String, :default => nil
#<> @attribute master_password_file Sets the `masterPasswordFile` `imcl` option.
attribute :master_password_file, :kind_of => String, :default => nil

