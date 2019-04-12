########################################################################
# AwsSecurityGroupRule is the +aws_security_group_rule+ terrform resource,
#
# {https://www.terraform.io/docs/providers/aws/r/security_group_rule.html Terraform Docs}
########################################################################
class GeoEngineer::Resources::AwsSecurityGroupRule < GeoEngineer::Resource
  validate -> { validate_required_attributes([:security_group_id, :type, :protocol, :from_port, :to_port]) }

  after :initialize, -> { _terraform_id -> { "#{security_group_id}:#{type}:#{protocol}:#{from_port}:#{to_port}" } }

  def support_tags?
    false
  end

  # self is a reserved keyword in Ruby which makes the self attribute a tad difficult
  def self_rule(val = nil)
    val ? self['self'] = val : self['self']
  end
end
