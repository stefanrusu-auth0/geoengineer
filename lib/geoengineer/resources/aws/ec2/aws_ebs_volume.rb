########################################################################
# AwsEbsVolume is the +aws_ebs_volume+ terrform resource,
#
# {https://www.terraform.io/docs/providers/aws/r/ebs_volume.html Terraform Docs}
########################################################################
class GeoEngineer::Resources::AwsEbsVolume < GeoEngineer::Resource
  validate -> { validate_required_attributes([:availability_zone]) }
  validate -> { validate_has_tag(:Name) }

  after :initialize, -> { _terraform_id -> { NullObject.maybe(remote_resource)._terraform_id } }
  after :initialize, -> { _geo_id -> { NullObject.maybe(tags)[:Name] } }

  def self._fetch_remote_resources(provider)
    AwsClients.ec2.describe_volumes.volumes.map do |volume|
      volume.merge(
        {
          _terraform_id: volume[:volume_id],
          _geo_id: volume[:tags]&.find { |tag| tag[:key] == "Name" }&.dig(:value)
        }
      )
    end
  end
end
