########################################################################
# AwsAcmCertificate is the +aws_acm_certificate+ terrform resource
#
# {https://www.terraform.io/docs/providers/aws/r/acm_certificate.html}
########################################################################
class GeoEngineer::Resources::AwsAcmCertificate < GeoEngineer::Resource
  # the purpose for this resource is to support importing existing certificates
  validate -> { validate_required_attributes([:private_key, :certificate_body, :certificate_chain]) }
  validate -> { validate_has_tag(:Name) }

  after :initialize, -> { _terraform_id -> { NullObject.maybe(remote_resource)._terraform_id } }
  after :initialize, -> { _geo_id -> { NullObject.maybe(tags)[:Name] } }

  def self._all_remote_certificates(provider)
    AwsClients.acm.list_certificates.certificate_summary_list.map(&:to_h)
  end

  def self._fetch_remote_resources(provider)
    _all_remote_certificates(provider).map do |certificate|
      tags = AwsClients.acm.list_tags_for_certificate(certificate_arn: certificate[:certificate_arn]).tags.map(&:to_h)

      certificate.merge(
        {
          _terraform_id: certificate[:certificate_arn],
          _geo_id: tags&.find { |tag| tag[:key] == "Name" }&.dig(:value)
        }
      )
    end
  end
end
