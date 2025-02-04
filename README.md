
<p align="center"> <img src="https://user-images.githubusercontent.com/50652676/62349836-882fef80-b51e-11e9-99e3-7b974309c7e3.png" width="100" height="100"></p>


<h1 align="center">
    Terraform google gke
</h1>

<p align="center" style="font-size: 1.2rem;">
    Terraform module to create gke resource on google.
     </p>

<p align="center">

<a href="https://www.terraform.io">
  <img src="https://img.shields.io/badge/Terraform-v1.7.4-green" alt="Terraform">
</a>
<a href="https://github.com/slovink/terraform-google-gke/blob/master/LICENSE">
  <img src="https://img.shields.io/badge/License-APACHE-blue.svg" alt="Licence">
</a>

</p>
<p align="center">

<a href='https://www.facebook.com/Slovink.in=https://github.com/slovink/terraform-lables'>
  <img title="Share on Facebook" src="https://user-images.githubusercontent.com/50652676/62817743-4f64cb80-bb59-11e9-90c7-b057252ded50.png" />
</a>
<a href='https://www.linkedin.com/company/101534993/admin/feed/posts/=https://github.com/slovink/terraform-lables'>
  <img title="Share on LinkedIn" src="https://user-images.githubusercontent.com/50652676/62817742-4e339e80-bb59-11e9-87b9-a1f68cae1049.png" />
</a>

# Terraform-google-gke
# Terraform Google Cloud Gke Module
## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Examples](#examples)
- [License](#license)
- [Author](#author)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Introduction
This project deploys a Google Cloud infrastructure using Terraform to create Gke .
## Usage
To use this module, you should have Terraform installed and configured for GCP. This module provides the necessary Terraform configuration for creating GCP resources, and you can customize the inputs as needed. Below is an example of how to use this module:
# Example: gke
```hcl
module "gke" {
  source             = "git::git@github.com:slovink/terraform-google-gke.git?ref=v1.0.0"
  name               = "ops"
  environment        = "test"
  region             = "asia-northeast1"
  image_type         = "UBUNTU_CONTAINERD"
  location           = "asia-northeast1"
  min_master_version = "1.27.3-gke.100"
  network            = module.vpc.vpc_id
  subnetwork         = module.subnet.subnet_id
  service_account    = module.service-account.account_email
  initial_node_count = 1
  min_node_count     = 1
  max_node_count     = 1
  disk_size_gb       = 20
  cluster_enabled    = true
}
```
This example demonstrates how to create various GCP resources using the provided modules. Adjust the input values to suit your specific requirements.

## Examples
For detailed examples on how to use this module, please refer to the [Examples](https://github.com/slovink/terraform-google-gke/tree/master/example) directory within this repository.

## Author
Your Name Replace **MIT** and **slovink** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the **MIT** License - see the [LICENSE](https://github.com/slovink/terraform-google-gke/blob/master/LICENSE) file for details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.2 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.50, < 5.20.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.50, < 5.20.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | git::https://github.com/slovink/terraform-google-labels.git | n/a |

## Resources

| Name | Type |
|------|------|
| [google_container_cluster.primary](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_container_node_pool.node_pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_repair"></a> [auto\_repair](#input\_auto\_repair) | ######################## management ########################### | `bool` | `true` | no |
| <a name="input_auto_upgrade"></a> [auto\_upgrade](#input\_auto\_upgrade) | n/a | `bool` | `true` | no |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | The cluster to create the node pool for. | `string` | `""` | no |
| <a name="input_cluster_create_timeouts"></a> [cluster\_create\_timeouts](#input\_cluster\_create\_timeouts) | ######################## timeouts ########################### | `string` | `"30m"` | no |
| <a name="input_cluster_delete_timeouts"></a> [cluster\_delete\_timeouts](#input\_cluster\_delete\_timeouts) | n/a | `string` | `"30m"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | `""` | no |
| <a name="input_cluster_update_timeouts"></a> [cluster\_update\_timeouts](#input\_cluster\_update\_timeouts) | n/a | `string` | `"30m"` | no |
| <a name="input_disk_size_gb"></a> [disk\_size\_gb](#input\_disk\_size\_gb) | n/a | `number` | `50` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | n/a | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_gke_version"></a> [gke\_version](#input\_gke\_version) | The minimum version of the master. | `string` | `""` | no |
| <a name="input_google_container_cluster_enabled"></a> [google\_container\_cluster\_enabled](#input\_google\_container\_cluster\_enabled) | Flag to control the cluster\_enabled creation. | `bool` | `true` | no |
| <a name="input_google_container_node_pool_enabled"></a> [google\_container\_node\_pool\_enabled](#input\_google\_container\_node\_pool\_enabled) | Flag to control the cluster\_enabled creation. | `bool` | `true` | no |
| <a name="input_image_type"></a> [image\_type](#input\_image\_type) | ######################## node\_config ########################### | `string` | `""` | no |
| <a name="input_initial_node_count"></a> [initial\_node\_count](#input\_initial\_node\_count) | The number of nodes to create in this cluster's default node pool. | `number` | `1` | no |
| <a name="input_kubectl_config_path"></a> [kubectl\_config\_path](#input\_kubectl\_config\_path) | Path to the kubectl config file. Defaults to $HOME/.kube/config | `string` | `""` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] . | `list(any)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The location (region or zone) in which the cluster master will be created, as well as the default node location. | `string` | `""` | no |
| <a name="input_location_policy"></a> [location\_policy](#input\_location\_policy) | n/a | `string` | `"BALANCED"` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | n/a | `string` | `""` | no |
| <a name="input_max_node_count"></a> [max\_node\_count](#input\_max\_node\_count) | n/a | `number` | `7` | no |
| <a name="input_min_node_count"></a> [min\_node\_count](#input\_min\_node\_count) | ######################## Autoscaling ########################### | `number` | `7` | no |
| <a name="input_module_enabled"></a> [module\_enabled](#input\_module\_enabled) | Flag to control the service\_account\_enabled creation. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource. Provided by the client when the resource is created. | `string` | `""` | no |
| <a name="input_network"></a> [network](#input\_network) | A reference (self link) to the VPC network to host the cluster in | `string` | `""` | no |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | The number of nodes to create in this cluster's default node pool. | `number` | `7` | no |
| <a name="input_preemptible"></a> [preemptible](#input\_preemptible) | n/a | `bool` | `false` | no |
| <a name="input_project"></a> [project](#input\_project) | The project ID to host the cluster in | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google Cloud project ID | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | Google Cloud region | `string` | `""` | no |
| <a name="input_remove_default_node_pool"></a> [remove\_default\_node\_pool](#input\_remove\_default\_node\_pool) | deletes the default node pool upon cluster creation. | `bool` | `true` | no |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | The Google Cloud Platform Service Account to be used by the node VMs created by GKE Autopilot or NAP. | `string` | `""` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | A reference (self link) to the subnetwork to host the cluster in | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | n/a |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->
