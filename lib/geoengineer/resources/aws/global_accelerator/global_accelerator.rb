class GeoEngineer::Resources::GlobalAccelerator < GeoEngineer::Resource
  validate -> { validate_required_attributes([:name, :ip_address_type, :enabled]) }

  after :initialize, -> { _terraform_id -> { name } }

  def to_terraform_state
    tfstate = super
    tfstate[:primary][:attributes] = {
      'name' => name,
      'ip_address_type' => (ip_address_type || "IPV4"),
      'enabled' => (enabled || true)
    }

    tfstate[:primary][:attributes]['filename'] = filename if filename

    tfstate
  end
end
