########################################################################
# AwsAlbTargetGroupAttachment is the +aws_alb_target_group_attachment+ terrform resource,
#
# {https://www.terraform.io/docs/providers/aws/r/lb_target_group_attachment.html Terraform Docs}
########################################################################
require_relative './aws_lb_target_group_attachment'
class GeoEngineer::Resources::AwsAlbTargetGroupAttachment < GeoEngineer::Resources::AwsLbTargetGroupAttachment
end
