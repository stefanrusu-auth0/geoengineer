########################################################################
# AwsSnsPlatformApplication is the +aws_sns_platform_application+ terrform resource,
#
# {https://www.terraform.io/docs/providers/aws/r/sns_platform_application.html Terraform Docs}
########################################################################
class GeoEngineer::Resources::AwsSnsPlatformApplication < GeoEngineer::Resource
  validate -> { validate_required_attributes([:name, :platform, :platform_credential]) }

  after :initialize, -> {
    _terraform_id -> {
      "arn:aws:sns:#{environment.region}:#{environment.account_id}:app/#{platform}/#{name}"
    }
  }

  def support_tags?
    false
  end

  # we don't really care
  def self._fetch_remote_resources(provider)
    []
  end
end
