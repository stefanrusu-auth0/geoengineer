########################################################################
# AwsSqsQueuePolicy is the +aws_sqs_queue_policy+ terrform resource,
#
# {https://www.terraform.io/docs/providers/aws/r/sqs_queue_policy.html Terraform Docs}
########################################################################
class GeoEngineer::Resources::AwsSqsQueuePolicy < GeoEngineer::Resource
  validate -> { validate_required_attributes([:queue_url, :policy]) }

  after :initialize, -> {
    _terraform_id -> {
      queue_url
    }
  }

  def to_terraform_state
    tfstate = super
    tfstate[:primary][:attributes] = {
      "queue_url" => queue_url,
      "policy" => policy
    }
    tfstate
  end

  def support_tags?
    false
  end

  def self._fetch_remote_resources(provider)
    queue_policies = []

    AwsClients.sqs(provider).list_queues['queue_urls'].map do |queue_url|
      queue = AwsClients.sqs(provider).get_queue_attributes(
        {
          queue_url: queue_url,
          attribute_names: ['Policy']
        }
      )

      unless queue.attributes.Policy.blank?
        queue_policies << {
          _terraform_id: queue_url,
          _geo_id: queue_url,
          queue_url: queue_url,
          policy: queue.attributesPolicy
        }
      end

      queue_policies
    end
  end
end
