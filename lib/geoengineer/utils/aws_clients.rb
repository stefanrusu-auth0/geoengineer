########################################################################
# AwsClients contains a list of aws-clients for use
# The main reason for their central management is their initialisation testing and stubbing
########################################################################
class AwsClients
  def self.stub!
    @stub_aws = true
  end

  def self.stubbed?
    @stub_aws || false
  end

  def self.client_params(provider = nil, params = nil)
    client_params = { stub_responses: stubbed? }
    client_params[:region] = provider.region if provider
    client_params[:region] = params[:region] if params
    client_params[:retry_limit] = Integer(ENV['AWS_RETRY_LIMIT']) if ENV['AWS_RETRY_LIMIT']
    client_params
  end

  def self.client_cache(provider, client, params = nil)
    provider = nil if stubbed? # we ignore all providers if we are stubbing

    @client_cache ||= {}
    key = "#{client.name}_" + (provider&.terraform_id || GeoEngineer::Resource::DEFAULT_PROVIDER)
    @client_cache[key] ||= client.new(client_params(provider, params))
  end

  def self.clear_cache!
    @client_cache = {}
  end

  # Clients

  def self.acm(provider = nil)
    self.client_cache(
      provider,
      Aws::ACM::Client
    )
  end

  def self.alb(provider = nil)
    require 'aws-sdk-elasticloadbalancingv2'
    self.client_cache(
      provider,
      Aws::ElasticLoadBalancingV2::Client
    )
  end

  def self.api_gateway(provider = nil)
    require 'aws-sdk-apigateway'
    self.client_cache(
      provider,
      Aws::APIGateway::Client
    )
  end

  def self.cloudfront(provider = nil)
    require 'aws-sdk-cloudfront'
    self.client_cache(
      provider,
      Aws::CloudFront::Client
    )
  end

  def self.cloudwatch(provider = nil)
    require 'aws-sdk-cloudwatch'
    self.client_cache(
      provider,
      Aws::CloudWatch::Client
    )
  end

  def self.cloudwatchevents(provider = nil)
    require 'aws-sdk-cloudwatchevents'
    self.client_cache(
      provider,
      Aws::CloudWatchEvents::Client
    )
  end

  def self.cloudwatchlogs(provider = nil)
    require 'aws-sdk-cloudwatchlogs'
    self.client_cache(
      provider,
      Aws::CloudWatchLogs::Client
    )
  end

  def self.directconnect(provider = nil)
    require 'aws-sdk-directconnect'
    self.client_cache(
      provider,
      Aws::DirectConnect::Client
    )
  end

  def self.dax(provider = nil)
    require 'aws-sdk-dax'
    self.client_cache(
      provider,
      Aws::DAX::Client
    )
  end

  def self.dynamo(provider = nil)
    require 'aws-sdk-dynamodb'
    self.client_cache(
      provider,
      Aws::DynamoDB::Client
    )
  end

  def self.ec2(provider = nil)
    require 'aws-sdk-ec2'
    self.client_cache(
      provider,
      Aws::EC2::Client
    )
  end

  def self.elasticache(provider = nil)
    require 'aws-sdk-elasticache'
    self.client_cache(
      provider,
      Aws::ElastiCache::Client
    )
  end

  def self.elasticsearch(provider = nil)
    require 'aws-sdk-elasticsearchservice'
    self.client_cache(
      provider,
      Aws::ElasticsearchService::Client
    )
  end

  def self.elb(provider = nil)
    require 'aws-sdk-elasticloadbalancing'
    self.client_cache(
      provider,
      Aws::ElasticLoadBalancing::Client
    )
  end

  def self.global_accelerator(provider = nil)
    self.client_cache(
      provider,
      Aws::GlobalAccelerator::Client,
      {
        # Global Accelerator won't work without this region endpoint anyway
        region: 'us-west-2'
      }
    )
  end

  def self.iam(provider = nil)
    require 'aws-sdk-iam'
    self.client_cache(
      provider,
      Aws::IAM::Client
    )
  end

  def self.kafka(provider = nil)
    require 'aws-sdk-kafka'
    self.client_cache(
      provider,
      Aws::Kafka::Client
    )
  end

  def self.kinesis(provider = nil)
    require 'aws-sdk-kinesis'
    self.client_cache(
      provider,
      Aws::Kinesis::Client
    )
  end

  def self.firehose(provider = nil)
    require 'aws-sdk-firehose'
    self.client_cache(
      provider,
      Aws::Firehose::Client
    )
  end

  def self.lambda(provider = nil)
    require 'aws-sdk-lambda'
    self.client_cache(
      provider,
      Aws::Lambda::Client
    )
  end

  def self.rds(provider = nil)
    require 'aws-sdk-rds'
    self.client_cache(
      provider,
      Aws::RDS::Client
    )
  end

  def self.redshift(provider = nil)
    require 'aws-sdk-redshift'
    self.client_cache(
      provider,
      Aws::Redshift::Client
    )
  end

  def self.route53(provider = nil)
    require 'aws-sdk-route53'
    self.client_cache(
      provider,
      Aws::Route53::Client
    )
  end

  def self.route53resolver(provider = nil)
    require 'aws-sdk-route53resolver'
    self.client_cache(
      provider,
      Aws::Route53Resolver::Client
    )
  end

  def self.s3(provider = nil)
    require 'aws-sdk-s3'
    self.client_cache(
      provider,
      Aws::S3::Client
    )
  end

  def self.ses(provider = nil)
    require 'aws-sdk-ses'
    self.client_cache(
      provider,
      Aws::SES::Client
    )
  end

  def self.states(provider = nil)
    require 'aws-sdk-states'
    self.client_cache(
      provider,
      Aws::States::Client
    )
  end

  def self.sns(provider = nil)
    require 'aws-sdk-sns'
    self.client_cache(
      provider,
      Aws::SNS::Client
    )
  end

  def self.sqs(provider = nil)
    require 'aws-sdk-sqs'
    self.client_cache(
      provider,
      Aws::SQS::Client
    )
  end

  def self.cloudtrail(provider = nil)
    require 'aws-sdk-cloudtrail'
    self.client_cache(
      provider,
      Aws::CloudTrail::Client
    )
  end

  def self.codebuild(provider = nil)
    require 'aws-sdk-codebuild'
    self.client_cache(
      provider,
      Aws::CodeBuild::Client
    )
  end

  def self.kms(provider = nil)
    require 'aws-sdk-kms'
    self.client_cache(
      provider,
      Aws::KMS::Client
    )
  end

  def self.waf(provider = nil)
    require 'aws-sdk-waf'
    self.client_cache(
      provider,
      Aws::WAF::Client
    )
  end

  def self.emr(provider = nil)
    require 'aws-sdk-emr'
    self.client_cache(
      provider,
      Aws::EMR::Client
    )
  end

  def self.efs(provider = nil)
    require 'aws-sdk-efs'
    self.client_cache(
      provider,
      Aws::EFS::Client
    )
  end

  def self.codedeploy(provider = nil)
    require 'aws-sdk-codedeploy'
    self.client_cache(
      provider,
      Aws::CodeDeploy::Client
    )
  end

  def self.organizations(provider = nil)
    require 'aws-sdk-organizations'
    self.client_cache(
      provider,
      Aws::Organizations::Client
    )
  end

  def self.pinpoint(provider = nil)
    require 'aws-sdk-pinpoint'
    self.client_cache(
      provider,
      Aws::Pinpoint::Client
    )
  end

  def self.acmpca(provider = nil)
    require 'aws-sdk-acmpca'
    self.client_cache(
      provider,
      Aws::ACMPCA::Client
    )
  end

  def self.cloudhsm(provider = nil)
    require 'aws-sdk-cloudhsmv2'
    self.client_cache(
      provider,
      Aws::CloudHSMV2::Client
    )
  end

  def self.acm(provider = nil)
    require 'aws-sdk-acm'
    self.client_cache(
      provider,
      Aws::ACM::Client
    )
  end
end
