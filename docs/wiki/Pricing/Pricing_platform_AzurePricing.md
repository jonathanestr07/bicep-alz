# Azure Pricing (platform)

The following is an indicative representation of the Azure Pricing for this solution if deployed.

These prices have been generated automatically using the Bicep templates in this repository.

  > Note:
  > All prices are based off Azure Region, AU East (australiaeast) at [retail pricing](https://learn.microsoft.com/rest/api/cost-management/retail-prices/azure-retail-prices). Your organisations prices may be different based on subscription sku and other discounts.

## Total cost

The total cost to run this solution is the following:

Hourly | Daily | Monthly | Yearly
------ | ----- | ------- | ------
3.4189 AUD | 82.0536 AUD | 2461.608 AUD | 29949.564 AUD

### Currency

All prices are in [AUD](https://www.iso.org/iso-4217-currency-codes.html) and are subject to Microsoft's retail pricing schedule.

## Azure Resources

The following provides a breakdown per each Azure resource discovered in the automation process.

### Azure Firewall (Networking)

serviceName | type | meterName | Hourly (AUD) | Price (AUD) | Monthly (AUD) | Yearly (AUD)
----------- | ---- | --------- | ------------ | ----------- | ------------- | ------------
Azure Firewall | Consumption | Standard Deployment | 1.8793       | 45.1032     | 1353.0960     | 16462.6680

### Additional pricing on Azure Firewall

The following prices are associated with the Azure Firewall service but not are not a deployment cost. I.e. These may be tiering charges for ingress/egress traffic that needs to be considered in your solutions usage.

type | meterName | Price (AUD) | Tiering
---- | --------- | ----------- | -------
Consumption | Standard Data Processed | 0.0241      | _NA_

### Azure Bastion (Networking)

serviceName | type | meterName | Hourly (AUD) | Price (AUD) | Monthly (AUD) | Yearly (AUD)
----------- | ---- | --------- | ------------ | ----------- | ------------- | ------------
Azure Bastion | Consumption | Standard Gateway | 0.436        | 10.464      | 313.920       | 3819.360
Azure Bastion | Consumption | Standard Additional Gateway | 0.2105       | 5.0520      | 151.5600      | 1843.9800

### Additional pricing on Azure Bastion

The following prices are associated with the Azure Bastion service but not are not a deployment cost. I.e. These may be tiering charges for ingress/egress traffic that needs to be considered in your solutions usage.

type | meterName | Price (AUD) | Tiering
---- | --------- | ----------- | -------
Consumption | Standard Data Transfer Out | 0           | First 5 GB
Consumption | Standard Data Transfer Out | 0.1804      | 5 GB to 10240 GB
Consumption | Standard Data Transfer Out | 0.1278      | 10240 GB to 51200 GB
Consumption | Standard Data Transfer Out | 0.1233      | 51200 GB to 153600 GB
Consumption | Standard Data Transfer Out | 0.1203      | Over 153600 GB

### ExpressRoute Gateway (Networking)

serviceName | type | meterName | Hourly (AUD) | Price (AUD) | Monthly (AUD) | Yearly (AUD)
----------- | ---- | --------- | ------------ | ----------- | ------------- | ------------
ExpressRoute | Consumption | ErGw1AZ Gateway | 0.5427       | 13.0248     | 390.7440      | 4754.0520

### VPN Gateway (Networking)

serviceName | type | meterName | Hourly (AUD) | Price (AUD) | Monthly (AUD) | Yearly (AUD)
----------- | ---- | --------- | ------------ | ----------- | ------------- | ------------
VPN Gateway | Consumption | S2S Connection | 0.0234       | 0.5616      | 16.8480       | 204.9840
VPN Gateway | Consumption | VpnGw1AZ  | 0.327        | 7.848       | 235.440       | 2864.520

## Further Additional Charges

Further additional charges to this solution such as data ingress/egress and other Azure resources may not be captured in this file. Please review your Azure Portal and Azure Budgets for final pricing.
