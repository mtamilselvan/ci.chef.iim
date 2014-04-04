# Cookbook Name:: im
# Attributes:: default
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and

#<> User and Group name under which the server will be installed and running.
default[:im][:user] = "im"
default[:im][:group] = "im-admin"

#<> Base installation directory.
default[:im][:base_dir] = "/opt/ibm/IM"

#<
# The IM install zip file
#>
default[:im][:install_zip][:file] = nil

#<
# The IM install zip url
#>
default[:im][:install_zip][:url] = nil

