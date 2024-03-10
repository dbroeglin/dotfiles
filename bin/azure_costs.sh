#!/bin/sh

# Depends on https://github.com/mivano/azure-cost-cli

# List subscriptions using:
# az account list --all --query "[].{Name:name, Id:id, TenantId:tenantId}" -o table | grep -v 1db47

while [ "$1" != "" ]; do
    case $1 in
        -a )     accumulated_cost=1
                                ;;
    esac
    shift
done

for subscription_id in $(
    az account list --all --query "[].{Id:id}" -o tsv | egrep '^(4003|e5a0|3a57)'
); do
    az account set --subscription $subscription_id

    if [ ${accumulated_cost:-0} -eq 1 ];
    then
        azure-cost accumulatedCost -s $subscription_id -a
    else
        azure-cost dailyCosts -s $subscription_id
    fi
done
