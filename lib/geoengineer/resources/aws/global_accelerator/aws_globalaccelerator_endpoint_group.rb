########################################################################
# AwsGlobalacceleratorEndpointGroup is the +aws_globalaccelerator_endpoint_group+ terrform resource,
#
# {https://www.terraform.io/docs/providers/aws/r/globalaccelerator_endpoint_group.html Terraform Docs}
########################################################################
class GeoEngineer::Resources::AwsGlobalacceleratorEndpointGroup < GeoEngineer::Resource
  validate -> { validate_required_attributes([:listener_arn, :endpoint_id, :weight, :name]) }

  after :initialize, -> { _terraform_id -> { NullObject.maybe(remote_resource)._terraform_id } }
  after :initialize, -> { _geo_id -> { name } }

  def to_terraform_state
    tfstate = super
    tfstate[:primary][:attributes] = {
      'name' => name,
      'listener_arn' => listener_arn,
      'endpoint_id' => endpoint_id,
      'weight' => (weight || '100')
    }

    tfstate[:primary][:attributes]['filename'] = filename if filename

    tfstate
  end

  def short_type
    'endpoint'
  end

  def support_tags?
    false
  end

  def self._fetch_remote_resources(provider)
    client = AwsClients.accelerator(provider)
    client.list_endpoint_groups.endpoint_descriptions.map(&:to_h).map do |endpoint|
      endpoint[:_terraform_id] = endpoint[:listener_arn]
      endpoint[:_geo_id] = endpoint[:_geo_id]
      endpoint
    end
  end
end
