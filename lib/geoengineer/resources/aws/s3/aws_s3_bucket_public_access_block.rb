########################################################################
# AwsS3BucketPublicAccessBlock is the +aws_s3_bucket_public_access_block+ terrform resource,
#
# {https://www.terraform.io/docs/providers/aws/r/s3_bucket_public_access_block.html Terraform Docs}
########################################################################
class GeoEngineer::Resources::AwsS3BucketPublicAccessBlock < GeoEngineer::Resource
  validate -> { validate_required_attributes([:bucket, :_bucket_name]) }

  after :initialize, -> { _terraform_id -> { NullObject.maybe(remote_resource)._terraform_id } }
  after :initialize, -> { _geo_id -> { _bucket_name } }

  def to_terraform_state
    tfstate = super
    tfstate[:primary][:attributes] = {
      'block_public_acls' => block_public_acls.to_s || 'false',
      'block_public_policy' => block_public_policy.to_s || 'false',
      'ignore_public_acls' => ignore_public_acls.to_s || 'false',
      'restrict_public_buckets' => restrict_public_buckets.to_s || 'false'
    }
    tfstate
  end

  def support_tags?
    false
  end

  def self._fetch_remote_resources(provider)
    client = AwsClients.s3(provider)
    client.list_buckets.buckets.map(&:to_h).map do |s3b|
      region = client.get_bucket_location(bucket: s3b[:name])

      attributes = {
        _terraform_id: s3b[:name]
      }

      if region == provider.region
        # getting the public access block works onky within the same region
        pab = client.get_public_access_block(
          bucket: s3b[:name]
        ).public_access_block_configuration

        attributes.merge!(pab.to_h)
      end

      s3b.merge(attributes)
    end
  end
end
