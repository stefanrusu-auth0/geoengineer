########################################################################
# NullResource is the +null_resource+ terrform resource,
#
# {https://www.terraform.io/docs/provisioners/null_resource.html Provisioners Without a Resource}
########################################################################
class GeoEngineer::Resources::NullResource < GeoEngineer::Resource
  after :initialize, -> { _terraform_id -> { "null_resource:#{id}" } }

  def support_tags?
    false
  end
end
