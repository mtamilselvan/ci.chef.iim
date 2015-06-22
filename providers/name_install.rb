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


action :install do

  if package_name.nil? or repositories.nil?
    #Do raise and error and crash. 
  end
  
  install_command_snippet = "#{new_resource.package_name} -repositories #{new_resource.repositories} "
  install_command_snippet << " -installationDirectory #{new_resource.install_directory}" unless install_directory.nil?
  
  _install new_resource.package_name do
    install_command_snippet install_command_snippet 
    maybe_secure_storage_file new_resource.maybe_secure_storage_file
    maybe_master_password_file new_resource.maybe_master_password_file
  end

end
