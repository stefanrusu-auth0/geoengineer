########################################################################
# Variables are mapped 1:1 to terraform variables
#
# {https://www.terraform.io/docs/configuration/variables.html Input Variables}
########################################################################
class GeoEngineer::Variable
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
    sb = ['']
    sb << "variable #{@id.inspect} { "
    sb.concat terraform_attributes.map do |k, v|
      "  #{k.to_s.inspect} = #{v.inspect}"
    end
    sb << '}'

    sb.join "\n"
  end
end
