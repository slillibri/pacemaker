require ::File.join(::File.dirname(__FILE__), 'helper')

action :create do
    name = new_resource.name
    value = new_resource.value

    unless resource_exists?(name)
        cmd = "crm configure property #{name}=\"#{value}\""
        Chef::Log.debug("configuring property #{cmd}")
        e = execute "configure property #{name}" do
            command cmd
        end
        new_resource.updated_by_last_action(true)
        Chef::Log.info "Configured property '#{name}'."
    end
end
