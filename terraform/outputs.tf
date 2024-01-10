# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# --- root/outputs.tf ---

output "vpcs" {
  description = "VPCs created."
  value = {
    oregon = {
      spoke      = { for k, v in module.oregon_spoke_vpcs : k => v.vpc_attributes.id }
      inspection = module.oregon_inspection_vpc.vpc_attributes.id
      legacy     = module.oregon_legacy_vpc.vpc_attributes.id
    }
    ohio = {
      spoke      = { for k, v in module.ohio_spoke_vpcs : k => v.vpc_attributes.id }
      inspection = module.ohio_inspection_vpc.vpc_attributes.id
      legacy     = module.ohio_legacy_vpc.vpc_attributes.id
    }
  }
}

output "cloud_wan" {
  description = "AWS Cloud WAN resources."
  value = {
    global_network_id = aws_networkmanager_global_network.global_network.id
    core_network_id   = aws_networkmanager_core_network.core_network.id
    attachments = {
      oregon = {
        spoke      = { for k, v in module.oregon_spoke_vpcs : k => v.core_network_attachment.id }
        inspection = module.oregon_inspection_vpc.core_network_attachment.id
        tgw_rt     = aws_networkmanager_transit_gateway_route_table_attachment.oregon_cwan_tgw_rt_attachment.id
      }
      ohio = {
        spoke      = { for k, v in module.ohio_spoke_vpcs : k => v.core_network_attachment.id }
        inspection = module.ohio_inspection_vpc.core_network_attachment.id
        tgw_rt     = aws_networkmanager_transit_gateway_route_table_attachment.ohio_cwan_tgw_rt_attachment.id
      }
    }
  }
}

output "transit_gateway" {
  description = "AWS Transit Gateway resources."
  value = {
    oregon    = aws_ec2_transit_gateway.oregon_tgw.id
    ohio = aws_ec2_transit_gateway.ohio_tgw.id
  }
}