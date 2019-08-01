########################################################################
# AwsGlobalacceleratorAccelerator +aws_globalaccelerator_accelerator+ terrform resource,
#
# {https://www.terraform.io/docs/providers/aws/r/globalaccelerator_accelerator.html Terraform Docs}
########################################################################
class GeoEngineer::Resources::AwsGlobalacceleratorAccelerator < GeoEngineer::Resource
  validate -> { validate_required_attributes([:name, :ip_address_type, :enabled]) }

  after :initialize, -> { _terraform_id -> { NullObject.maybe(remote_resource)._terraform_id } }
  after :initialize, -> { _geo_id -> { name } }

  def to_terraform_state
    tfstate = super
    tfstate[:primary][:attributes] = {
      'name' => name,
      'ip_address_type' => (ip_address_type || 'IPV4'),
      'enabled' => (enabled || 'true')
    }

    tfstate[:primary][:attributes]['filename'] = filename if filename

    tfstate
  end

  def short_type
    'ga'
  end

  def support_tags?
    false
  end

  def self._fetch_remote_resources(provider)
    client = AwsClients.accelerator(provider)
    client.list_accelerators.accelerators.map(&:to_h).map do |ga|
      ga[:_terraform_id] = ga[:name]
      ga[:_geo_id] = ga[:_geo_id]
      ga
    end
  end
end
