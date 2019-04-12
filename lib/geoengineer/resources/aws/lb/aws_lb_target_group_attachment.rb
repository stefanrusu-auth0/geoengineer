########################################################################
# AwsLbTargetGroupAttachment is the +aws_alb_target_group_attachment+ terrform resource,
#
# {https://www.terraform.io/docs/providers/aws/r/lb_target_group_attachment.html Terraform Docs}
########################################################################
class GeoEngineer::Resources::AwsLbTargetGroupAttachment < GeoEngineer::Resource
  validate -> { validate_required_attributes([:target_group_arn, :target_id]) }

  after :initialize, -> { _terraform_id -> { "#{target_group_arn}:#{target_id}" } }

  def support_tags?
    false
  end
end
