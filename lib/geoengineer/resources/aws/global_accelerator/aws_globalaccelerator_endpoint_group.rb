########################################################################
# AwsGlobalacceleratorEndpointGroup is the +aws_globalaccelerator_endpoint_group+ terrform resource,
#
# {https://www.terraform.io/docs/providers/aws/r/globalaccelerator_endpoint_group.html Terraform Docs}
########################################################################
class GeoEngineer::Resources::AwsGlobalacceleratorEndpointGroup < GeoEngineer::Resource
  validate -> { validate_required_attributes([:listener_arn]) }

  after :initialize, -> { _terraform_id -> { NullObject.maybe(remote_resource)._terraform_id } }
  after :initialize, -> { _geo_id -> { listener_arn } }

  def short_type
    'endpoint'
  end

  def support_tags?
    false
  end

  def self._fetch_remote_resources(provider)
    client = AwsClients.global_accelerator(provider)

    endpoints = []

    client.list_accelerators.accelerators.each do |acc|
      client.list_listeners({ accelerator_arn: acc.accelerator_arn }).listeners.each do |list|
        client.list_endpoint_groups({ listener_arn: list.listener_arn }).endpoint_groups.each do |endpoint|
          endpoint = endpoint.to_h
          endpoint[:_terraform_id] = endpoint[:endpoint_group_arn]

          endpoints << endpoint
        end
      end
    end

    endpoints
  end
end
