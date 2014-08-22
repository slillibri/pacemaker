require ::File.join(::File.dirname(__FILE__), 'helper')

action :create do
    name = new_resource.name
    value = new_resource.value

    unless resource_exists?(name)
        cmd = "crm configure rsc_default #{name}=\"#{value}\""
        Chef::Log.debug("configuring rsc_default #{cmd}")
        e = execute "configure rsc_default #{name}" do
            command cmd
        end
        new_resource.updated_by_last_action(true)
        Chef::Log.info "Configured rsc_default '#{name}'."
    end
end
