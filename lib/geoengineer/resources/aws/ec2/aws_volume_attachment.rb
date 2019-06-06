########################################################################
# AwsVolumeAttachment is the +aws_volume_attachment+ terrform resource,
#
# {https://www.terraform.io/docs/providers/aws/r/volume_attachment.html Terraform Docs}
########################################################################
class GeoEngineer::Resources::AwsVolumeAttachment < GeoEngineer::Resource
  validate -> { validate_required_attributes([:device_name, :volume_id, :instance_id]) }

  after :initialize, -> { _terraform_id -> { NullObject.maybe(remote_resource)._terraform_id } }
  after :initialize, -> { _geo_id -> { "#{device_name}:#{instance_id}:#{volume_id}" } }

  def support_tags?
    false
  end

  def self._fetch_remote_resources(provider)
    volumes = []

    AwsClients.ec2.describe_instances.reservations.map(&:instances).flatten.map(&:to_h).each do |instance|
      instance[:block_device_mappings].each do |device|
        device_name = device[:device_name]
        instance_id = instance[:instance_id]
        volume_id = device[:ebs][:volume_id]

        device[:instance_id] = instance_id
        device[:_terraform_id] = "vai-#{Crc32.hashcode("#{device_name}-#{instance_id}-#{volume_id}-")}"
        volumes << device
      end
    end

    volumes
  end
end
