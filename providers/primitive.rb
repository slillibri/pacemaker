# Author:: Robert Choi
# Cookbook Name:: pacemaker
# Provider:: primitive
#
# Copyright:: 2013, Robert Choi
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

require ::File.join(::File.dirname(__FILE__), 'helper')

# For vagrant env, switch to the following 'require' command.
#require "/srv/chef/file_store/cookbooks/pacemaker/providers/helper"

action :create do
  name = new_resource.name
  agent = new_resource.agent

  unless resource_exists?(name)
    cmd = "crm configure primitive #{name} #{agent}"
  
    if new_resource.params and !(new_resource.params.empty?)
      cmd << " params"
      new_resource.params.each do |key, value|
        cmd << " #{key}=\"#{value}\""
      end
    end

    if new_resource.meta and !(new_resource.meta.empty?)
      cmd << " meta"
      new_resource.meta.each do |key, value|
        cmd << " #{key}=\"#{value}\""
      end
    end

    if new_resource.op and !(new_resource.op.empty?)
      cmd << " op"
      new_resource.op.each do |op|
        op.each_pair do |name, values|
          cmd << " #{name}"
          values.each do |key, value|
            cmd << " #{key}=\"#{value}\""
          end          
        end
      end
    end

    e = execute "configure primitive #{name}" do
      command cmd
    end

#   With the below commands, 'e.updated?' is always 'false' even though the execute command ran successfully.
#    new_resource.updated_by_last_action(e.updated?)
#    if e.updated?
#      Chef::Log.info "Done creating primitive '#{name}'."
#    end

    new_resource.updated_by_last_action(true)
    Chef::Log.info "Configured primitive '#{name}'."
  end
end

action :delete do
  name = new_resource.name
  cmd = "crm resource stop #{name}; crm configure delete #{name}"

    e = execute "delete primitive #{name}" do
      command cmd
      only_if { resource_exists?(name) }
    end

    new_resource.updated_by_last_action(true)
    Chef::Log.info "Deleted primitive '#{name}'."
end
