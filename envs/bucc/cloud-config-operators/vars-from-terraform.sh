#!/bin/bash

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../.." && pwd )"
cd $ROOT

tfoutput="terraform output --state=envs/aws/terraform.tfstate"
cat <<YAML
az:            $($tfoutput aws_network_private_az)
subnet_id:     $($tfoutput aws_network_private_subnet)
internal_cidr: $($tfoutput aws_network_prefix).1.0/24
internal_gw:   $($tfoutput aws_network_prefix).1.1

dmz_subnet_id:           $($tfoutput aws_network_dmz_subnet)
cf_services_subnet_id:   $($tfoutput aws_network_cf-services_subnet)
YAML
