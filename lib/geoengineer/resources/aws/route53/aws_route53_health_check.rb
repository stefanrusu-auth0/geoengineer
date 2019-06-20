########################################################################
# AwsRoute53HealthCheck is the +aws_route53_health_check+ terrform resource,
#
# {https://www.terraform.io/docs/providers/aws/r/route53_health_check.html Terraform Docs}
########################################################################
class GeoEngineer::Resources::AwsRoute53HealthCheck < GeoEngineer::Resource
  validate -> { validate_required_attributes([:type, :failure_threshold, :request_interval]) }
  validate -> { validate_has_tag(:Name) }

  after :initialize, -> { _terraform_id -> { NullObject.maybe(remote_resource)._terraform_id } }
  after :initialize, -> { _geo_id -> { NullObject.maybe(tags)[:Name] } }

  def self._all_health_checks(provider)
    AwsClients.route53(provider).list_health_checks.health_checks.map(&:to_h)
  end

  def self._fetch_remote_resources(provider)
    _all_health_checks(provider).map do |health_check|
      health_check.merge(
        {
          _terraform_id: health_check[:id]
        }
      )
    end
  end
end
