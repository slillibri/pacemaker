actions :create, :delete
default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :value, :kind_of => String, :required => true
