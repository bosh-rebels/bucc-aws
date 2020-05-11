#!/bin/bash

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../.." && pwd )"
cd $ROOT

private_key_prefix=${private_key_prefix:-../../../..}
tfoutput="terraform output --state=envs/aws/terraform.tfstate"
cat <<YAML
access_key_id:     $($tfoutput aws_creds_aws_access_key)
secret_access_key: $($tfoutput aws_creds_aws_secret_key)
default_key_name:  $($tfoutput aws_creds_key_name)
private_key:       ${private_key_prefix}/$($tfoutput aws_creds_key_file)
default_security_groups: [$($tfoutput aws_network_sg_dmz), $($tfoutput aws_network_sg_wide-open)]
region:            $($tfoutput aws_network_region)

subnet_id:         $($tfoutput aws_network_private_subnet)
az:                $($tfoutput aws_network_private_az)
internal_cidr:     $($tfoutput aws_network_prefix).1.0/24
internal_gw:       $($tfoutput aws_network_prefix).1.1
internal_ip:       $($tfoutput aws_network_prefix).1.4

director_name: bucc-walk-thru

instance_type: m4.2xlarge
ephemeral_disk_size: 80_000
spot_bid_price: 1
YAML
