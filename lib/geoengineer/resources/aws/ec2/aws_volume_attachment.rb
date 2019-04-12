########################################################################
# AwsVolumeAttachment is the +aws_volume_attachment+ terrform resource,
#
# {https://www.terraform.io/docs/providers/aws/r/volume_attachment.html Terraform Docs}
########################################################################
class GeoEngineer::Resources::AwsVolumeAttachment < GeoEngineer::Resource
  validate -> { validate_required_attributes([:device_name, :volume_id, :instance_id]) }

  after :initialize, -> { _terraform_id -> { "#{instance_id}:#{volume_id}:#{device_name}" } }

  def support_tags?
    false
  end
end
