

<p align="center"> <img src="https://user-images.githubusercontent.com/50652676/62349836-882fef80-b51e-11e9-99e3-7b974309c7e3.png" width="100" height="100"></p>


<h1 align="center">
    Terraform gcp  gke
</h1>

<p align="center" style="font-size: 1.2rem;">
    Terraform module to create Storage resource on gcp .
     </p>

<p align="center">

<a href="https://www.terraform.io">
  <img src="https://img.shields.io/badge/Terraform-v1.1.7-green" alt="Terraform">
</a>
<a href="LICENSE.md">
  <img src="https://img.shields.io/badge/License-APACHE-blue.svg" alt="Licence">
</a>






## Prerequisites

This module has a few dependencies:

- [Terraform 1.x.x](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [Go](https://golang.org/doc/install)







## Examples


**IMPORTANT:** Since the `master` branch used in `source` varies based on new modifications, we suggest that you use the release versions [here](https://github.com/slovink/terraform-gcp-gke /releases).


### Simple Example
Here is an example of how you can use this module in your inventory structure:
  ```hcl
module "gke" {
  source = "../"

  name                               = "gke"
  environment                        = var.environment
  label_order                        = var.label_order

  network                            = module.vpc.vpc_id
  subnetwork                         = module.subnet.id
  module_enabled                     = true
  google_container_cluster_enabled   = true
  location                           = "europe-west3"
  remove_default_node_pool           = false
  gke_version                        = "1.25.6-gke.1000"
  initial_node_count                 = 1
  google_container_node_pool_enabled = true
  node_count                         = 1
  cluster_name                       = "test-gke"
  project_id                         = var.gcp_project_id
  region                             = var.gcp_region
  service_account                    = ""

}
  ```



## Feedback
If you come accross a bug or have any feedback, please log it in our [issue tracker](https://github.com/slovink/terraform-gcp-/issues), or feel free to drop us an email at [devops@slovink.com](mailto:devops@slovink.com).

If you have found it worth your time, go ahead and give us a ★ on [our GitHub](https://github.com/slovink/terraform-gcp-gke )!



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.2 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 5.45.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.45.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | git::https://github.com/slovink/terraform-google-labels.git | feature/precommit-134 |

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.intra_egress](https://registry.terraform.io/providers/hashicorp/google/5.45.0/docs/resources/compute_firewall) | resource |
| [google_container_cluster.primary](https://registry.terraform.io/providers/hashicorp/google/5.45.0/docs/resources/container_cluster) | resource |
| [google_container_node_pool.node_pool](https://registry.terraform.io/providers/hashicorp/google/5.45.0/docs/resources/container_node_pool) | resource |
| [random_shuffle.available_zones](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle) | resource |
| [google_compute_subnetwork.gke_subnetwork](https://registry.terraform.io/providers/hashicorp/google/5.45.0/docs/data-sources/compute_subnetwork) | data source |
| [google_compute_zones.available](https://registry.terraform.io/providers/hashicorp/google/5.45.0/docs/data-sources/compute_zones) | data source |
| [google_container_engine_versions.region](https://registry.terraform.io/providers/hashicorp/google/5.45.0/docs/data-sources/container_engine_versions) | data source |
| [google_container_engine_versions.zone](https://registry.terraform.io/providers/hashicorp/google/5.45.0/docs/data-sources/container_engine_versions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_cluster_firewall_rules"></a> [add\_cluster\_firewall\_rules](#input\_add\_cluster\_firewall\_rules) | Create additional firewall rules | `bool` | `true` | no |
| <a name="input_cluster_ipv4_cidr"></a> [cluster\_ipv4\_cidr](#input\_cluster\_ipv4\_cidr) | The IP address range of the kubernetes pods in this cluster. Default is an automatically assigned CIDR. | `string` | `"10.240.0.0/14"` | no |
| <a name="input_enable_private_nodes"></a> [enable\_private\_nodes](#input\_enable\_private\_nodes) | Whether nodes have internal IP addresses only | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_firewall_priority"></a> [firewall\_priority](#input\_firewall\_priority) | Priority rule for firewall rules | `number` | `1000` | no |
| <a name="input_google_container_cluster_enabled"></a> [google\_container\_cluster\_enabled](#input\_google\_container\_cluster\_enabled) | Flag to control the cluster\_enabled creation. | `bool` | `true` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region. | `string` | `"latest"` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] . | `list(any)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The location (region or zone) in which the cluster master will be created, as well as the default node location. | `string` | `""` | no |
| <a name="input_master_ipv4_cidr_block"></a> [master\_ipv4\_cidr\_block](#input\_master\_ipv4\_cidr\_block) | The IP address range of the kubernetes pods in this cluster. Default is an automatically assigned CIDR. | `string` | `"172.16.0.0/28"` | no |
| <a name="input_module_enabled"></a> [module\_enabled](#input\_module\_enabled) | Flag to control the service\_account\_enabled creation. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource. Provided by the client when the resource is created. | `string` | `""` | no |
| <a name="input_network"></a> [network](#input\_network) | A reference (self link) to the VPC network to host the cluster in | `string` | `""` | no |
| <a name="input_network_policy"></a> [network\_policy](#input\_network\_policy) | Enable network policy addon | `bool` | `false` | no |
| <a name="input_network_policy_provider"></a> [network\_policy\_provider](#input\_network\_policy\_provider) | The network policy provider. | `string` | `"CALICO"` | no |
| <a name="input_node_metadata"></a> [node\_metadata](#input\_node\_metadata) | Specifies how node metadata is exposed to the workload running on the node | `string` | `"GKE_METADATA"` | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | List of maps containing node pools | `list(map(any))` | <pre>[<br>  {<br>    "name": "default-node-pool"<br>  }<br>]</pre> | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google Cloud project ID | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | Google Cloud region | `string` | `""` | no |
| <a name="input_regional"></a> [regional](#input\_regional) | Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!) | `bool` | `false` | no |
| <a name="input_release_channel"></a> [release\_channel](#input\_release\_channel) | The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`. | `string` | `"REGULAR"` | no |
| <a name="input_remove_default_node_pool"></a> [remove\_default\_node\_pool](#input\_remove\_default\_node\_pool) | deletes the default node pool upon cluster creation. | `bool` | `true` | no |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | The Google Cloud Platform Service Account to be used by the node VMs created by GKE Autopilot or NAP. | `string` | `""` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | A reference (self link) to the subnetwork to host the cluster in | `string` | `""` | no |
| <a name="input_subnetworkName"></a> [subnetworkName](#input\_subnetworkName) | The subnetwork to host the cluster in (required) | `string` | `"kubernetes-subnet"` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Timeout for cluster operations. | `map(string)` | `{}` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | The zones to host the cluster in (optional if regional cluster / required if zonal) | `list(string)` | <pre>[<br>  "us-east1-b"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | n/a |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->