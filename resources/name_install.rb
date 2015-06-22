#
# Cookbook Name:: iim
# Provider:: iim_NameInstall
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

Installs an IBM Offering using the IBM Installation Manager.

@action install Installs an IBM Offering

@section Examples

Installing an offering.



#>
=end

actions :install
default_action :install

#<> @attribute secure_storage_file Sets the secureStorageFile imcl option.
attribute :secure_storage_file, :kind_of => String, :default => nil
#<> @attribute master_password_file Sets the masterPasswordFile imcl option.
attribute :master_password_file, :kind_of => String, :default => nil
#<> @attribute repositories The repository to search, multiple repositories may be specified with a comma seperated list.
attribute :repositories, :kind_of => String, :default => nil
#<> @attribute install_directory The directory to install the package into.
attribute :install_directory, :kind_of => String, :default => nil
