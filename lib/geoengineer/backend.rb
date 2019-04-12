########################################################################
# Backends are mapped 1:1 to terraform backends
#
# {https://www.terraform.io/docs/backends/index.html Terraform Docs}
########################################################################

# This implementation does not support recursion i.e providers with nested
# attributes. Most probably it also doesn't support multiple backends per
# project (an area not well documented by Terraform). For most providers,
# this is sufficient.
class GeoEngineer::Backend
  include HasAttributes

  attr_reader :id

  def initialize(id, &block)
    @id = id
    instance_exec(self, &block) if block_given?
  end

  def terraform_id
    if self.alias
      "#{id}.#{self.alias}"
    else
      id
    end
  end

  def to_terraform_json
    { id.to_s => terraform_attributes }
  end

  def to_terraform
    sb = ['terraform {']
    sb << [%(  backend "#{@id.inspect}" {)]
    sb.concat terraform_attributes.map do |k, v|
      "    #{k.to_s.inspect} = #{v.inspect}"
    end
    sb << ['  }']
    sb << ['}']

    sb.join "\n"
  end
end
