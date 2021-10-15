## API Gateway Module

A terraform module to provide a private API Gateway within aws which is accessed via a custom domain name and routed through an NLB to a VPC endpoint.
This includes a dummy API as this is required to build the stage and allows for testing. Further APIs can be deployed to the gateway using the parameters that are output to SSM.

The url for the api gateway will be api.<public_zone>

## Usage
```
provider "aws" {
  region = "eu-west-1"
}

module "api_gateway" {
  source              = "https://github.com/and-digital-cloud/terraform-aws-api-gateway.git?ref=X.Y.Z"

  application_service = "service"
  environment         = "dev"
  private_subnet_ids  = data.terraform_remote_state.vpc.outputs.private_subnets
  project             = "project"
  public_zone_name    = data.terraform_remote_state.route53.outputs.public_zone_name
  vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
}

```
Include these in a data-sources.tf file

```
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "<bucket-name>"
    key    = "<key>"
    region = "<region>"
  }
}

data "terraform_remote_state" "route53" {
  backend = "s3"

  config = {
    bucket = "<bucket-name>"
    key    = "<key>"
    region = "<region>"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| aws | ~> 3.29.1 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.29.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| acm | https://github.com/terraform-aws-modules/terraform-aws-acm.git | 3.2 |

## Resources

| Name |
|------|
| [aws_api_gateway_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_account) |
| [aws_api_gateway_base_path_mapping](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_base_path_mapping) |
| [aws_api_gateway_deployment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) |
| [aws_api_gateway_domain_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name) |
| [aws_api_gateway_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) |
| [aws_api_gateway_method](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) |
| [aws_api_gateway_method_settings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) |
| [aws_api_gateway_request_validator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_request_validator) |
| [aws_api_gateway_resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) |
| [aws_api_gateway_rest_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) |
| [aws_api_gateway_rest_api_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api_policy) |
| [aws_api_gateway_stage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) |
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) |
| [aws_cloudwatch_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) |
| [aws_iam_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) |
| [aws_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) |
| [aws_lb_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) |
| [aws_lb_target_group_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) |
| [aws_network_interface](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_interface) |
| [aws_network_interfaces](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_interfaces) |
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) |
| [aws_route53_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) |
| [aws_route53_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) |
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) |
| [aws_security_group_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) |
| [aws_ssm_parameter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) |
| [aws_vpc_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) |
| [aws_vpc_endpoint_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application\_role | The name of the application role, e.g. app\_server | `string` | `"api-gateway"` | no |
| application\_service | The name of the application service, e.g. infrastructure | `string` | n/a | yes |
| compliance | An identifier for workloads designed to adhere to specific compliance requirements. none/pci | `string` | `"pci"` | no |
| confidentiality | An identifier for the specific data-confidentiality level a resource supports. public/internal/confidential/highly confidential | `string` | `"highly confidential"` | no |
| environment | The name of your environment, e.g. /dev/test/uat/prod etc | `string` | n/a | yes |
| prefix | The prefix for the domain name, e.g. api | `string` | `"api"` | no |
| private\_subnet\_ids | The private subnet ids associated with the vpc | `list(string)` | n/a | yes |
| project | The name of your application project | `string` | n/a | yes |
| public\_zone\_name | The public zone that the domain name will be placed within | `string` | n/a | yes |
| vpc\_id | The vpc\_id that the endpoint is placed within | `string` | n/a | yes |
| vpn\_cidr\_block | The cidr block for the vpn | `string` | `"10.7.0.0/24"` | no |

## Outputs

No output.
