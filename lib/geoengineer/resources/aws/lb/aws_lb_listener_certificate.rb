########################################################################
# AwsLbListenerCertificate is the +aws_lb_listener_certificate+ terrform resource,
#
# {https://www.terraform.io/docs/providers/aws/r/lb_listener_certificate.html Terraform Docs}
########################################################################
class GeoEngineer::Resources::AwsLbListenerCertificate < GeoEngineer::Resource
  validate -> { validate_required_attributes([:listener_arn, :certificate_arn]) }

  after :initialize, -> { _terraform_id -> { "#{listener_arn}:#{certificate_arn}" } }

  def support_tags?
    false
  end
end
