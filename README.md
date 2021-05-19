## API Gateway Module

A terraform module to provide a private API Gateway within aws which is accessed via a custom domain name and routed through an NLB to a VPC endpoint.
This includes a dummy API as this is required to build the stage. Further APIs can be deployed to the gateway using the parameters that are output to SSM.

## Usage
```
provider "aws" {
  region = "eu-west-1"
}

module "api_gateway" {
  source              = "git::ssh://git@gitlab.com:cef-cloud/core-modules/terraform/api-gateway.git?ref=1.0.0"

  application_service = "rebate"
  environment         = "dev"
  private_subnet_ids  = data.terraform_remote_state.vpc.outputs.private_subnets
  project             = "supplier"
  public_zone_name    = data.terraform_remote_state.route53.outputs.public_zone_name
  vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
}

```

## Providers
| Name | Version |
|------|:-------:|
| aws | `~> 3.29.1` |

## Modules
| Name |
|:----:|
| acm |

## Inputs

| Name | Description | Type | Default | Required|
|------|-------------|------|---------|:-----:|
| application\_role | The name of the application role, e.g. app_server | `string` | `api-gateway` | no |
| application\_service | The name of the application service, e.g. infrastructure | `string` | `N/A` | yes |
| compliance | An identifier for workloads designed to adhere to specific compliance requirements. none/pci | `string` | `pci` | no |
| confidentiality | An identifier for the specific data-confidentiality level a resource supports. public/internal/confidential/highly confidential | `string` | `highly confidential` | no |
| environment | The name of your environment, e.g. dev/test/uat/prod etc | `string` | `N/A` | yes |
| prefix | The prefix for the domain name, e.g. api | `string` | `api` | no |
| private\_subnet\_ids | The private subnet ids associated with the vpc | `list(string)` | `N/A` | no |
| project | The name of your application project, e.g. shared | `string` | `N/A` | yes |
| public\_zone | The public zone that the domain name will be placed within | `string` | `N/A` | yes |
| public\_zone\_id | The id for the public zone that the domain will be placed within | `string` | `N/A` | yes |
| vpc\_id | The vpc_id that the endpoint is placed within | `string` | `N/A` | yes |
| vpc\_cidr\_block | The cidr block for the vpc the endpoint is placed within | `string` | `N/A` | yes |
| vpn\_cidr\_block | The cidr block for the vpn | `string` | `10.7.0.0/24` | no |