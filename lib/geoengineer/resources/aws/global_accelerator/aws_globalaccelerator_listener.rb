########################################################################
# AwsGlobalacceleratorListener is the +aws_globalaccelerator_listener+ terrform resource,
#
# {https://www.terraform.io/docs/providers/aws/r/globalaccelerator_listener.html Terraform Docs}
########################################################################
class GeoEngineer::Resources::AwsGlobalacceleratorListener < GeoEngineer::Resource
  validate -> { validate_required_attributes([:accelerator_arn, :port_range, :protocol]) }

  after :initialize, -> { _terraform_id -> { NullObject.maybe(remote_resource)._terraform_id } }
  after :initialize, -> { _geo_id -> { "#{accelerator_arn}:#{protocol}:#{port_range}" } }

  def short_type
    'listener'
  end

  def support_tags?
    false
  end

  def self._fetch_remote_resources(provider)
    client = AwsClients.global_accelerator(provider)

    listeners = []

    client.list_accelerators.accelerators.each do |acc|
      client.list_listeners(accelerator_arn: acc.accelerator_arn).listeners.each do |list|
        list = list.to_h
        list[:_terraform_id] = list[:listener_arn]

        listeners << list
      end
    end

    listeners
  end
end
