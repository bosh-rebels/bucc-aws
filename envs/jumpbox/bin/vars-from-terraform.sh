#!/bin/bash

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../.." && pwd )"
cd $ROOT

tfoutput="terraform output --state=envs/aws/terraform.tfstate"
cat <<YAML
access_key_id:     $($tfoutput aws_creds_aws_access_key)
secret_access_key: $($tfoutput aws_creds_aws_secret_key)
default_key_name:  $($tfoutput aws_creds_key_name)
private_key:       ../../$($tfoutput aws_creds_key_file)
default_security_groups: [$($tfoutput aws_network_sg_dmz)]
region:            $($tfoutput aws_network_region)

subnet_id:         $($tfoutput aws_network_dmz_subnet)
az:                $($tfoutput aws_network_dmz_az)
internal_cidr:     $($tfoutput aws_network_prefix).0.0/24
internal_gw:       $($tfoutput aws_network_prefix).0.1
internal_ip:       $($tfoutput aws_network_prefix).0.4

external_ip:       $($tfoutput box_jumpbox_public_ip)

spot_bid_price: 10
YAML
