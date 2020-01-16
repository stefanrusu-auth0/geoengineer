########################################################################
# AwsKmsKey is the +aws_kms_key+ terrform resource,
#
# {https://www.terraform.io/docs/providers/aws/r/kms_key.html}
########################################################################
class GeoEngineer::Resources::AwsKmsKey < GeoEngineer::Resource
  validate -> { validate_required_attributes([:description]) }

  after :initialize, -> { _terraform_id -> { NullObject.maybe(remote_resource)._terraform_id } }
  after :initialize, -> { _geo_id -> { NullObject.maybe(tags)[:Name] } }
  after :initialize, -> { _arn -> { NullObject.maybe(remote_resource)._arn } }

  def _policy_file(path, binding_obj = nil)
    _json_file(:policy, path, binding_obj)
  end

  def self._fetch_all_keys(provider)
    resp = AwsClients.kms(provider).list_keys({ limit: 1000 })
    keys = resp[:keys]

    while resp.truncated
      marker = resp.next_marker
      resp = AwsClients.kms(provider).list_keys({ limit: 1000, marker: marker })
      keys += resp[:keys]
    end

    keys
  end

  def self._fetch_remote_resources(provider)
    keys = _fetch_all_keys(provider).map do |i|
      AwsClients.kms(provider).describe_key({ key_id: i.key_id }).key_metadata.to_h
    end

    keys.map do |k|
      k[:_terraform_id] = k[:key_id]
      k[:_arn] = k[:arn]
      k[:_geo_id] = k[:description]
      k
    end
  end
end
