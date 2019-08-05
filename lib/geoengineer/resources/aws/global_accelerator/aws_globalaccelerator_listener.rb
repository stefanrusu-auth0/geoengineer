class GeoEngineer::Resources::AwsGlobalacceleratorListener< GeoEngineer::Resource
  validate -> { validate_required_attributes([:accelerator_arn, :name]) }

  after :initialize, -> { _terraform_id -> { NullObject.maybe(remote_resource)._terraform_id } }
  after :initialize, -> { _geo_id -> { name } }

  def to_terraform_state
    tfstate = super
    tfstate[:primary][:attributes] = {
      'name' => name,
      'accelerator_arn' => accelerator_arn
    }

    tfstate[:primary][:attributes]['filename'] = filename if filename

    tfstate
  end

  def short_type
    'listener'
  end

  def support_tags?
    false
  end

  def self._fetch_remote_resources(provider)
    client = AwsClients.accelerator(provider)
    client.list_listeners.listeners.map(&:to_h).map do |listener|
      listener[:_terraform_id] = listener[:listener_arn]
      listener[:_geo_id] = listener[:_geo_id]
      listener
    end
  end
end
