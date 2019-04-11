########################################################################
# AwsKeyPair is the +aws_key_pair+ terrform resource,
#
# {https://www.terraform.io/docs/providers/aws/r/key_pair.html Terraform Docs}
########################################################################
class GeoEngineer::Resources::AwsKeyPair < GeoEngineer::Resource
  validate -> { validate_required_attributes([:key_name, :public_key]) }

  after :initialize, lambda {
    _terraform_id -> { "ssh_key_pair.#{id}" }
  }

  def support_tags?
    false
  end
end
