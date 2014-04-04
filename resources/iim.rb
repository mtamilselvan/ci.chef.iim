#
# Cookbook Name:: application_wlp
# Provider:: wlp_application
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


attribute :response_file, :kind_of => String, :default => nil
attribute :response_hash, :kind_of => String, :default => nil
attribute :key_file, :kind_of => String, :default => nil
attribute :key_response_file, :kind_of => String, :default => nil
attribute :secure_storage_file, :kind_of => String, :default => nil
attribute :master_password_file, :kind_of => String, :default => nil

actions :install
default_action :install
