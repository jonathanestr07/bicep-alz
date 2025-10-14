# Add-DNSConditionalForwardersforAzurePrivateDNSZones.ps1

Adds or removes DNS conditional forwarders for Azure Private DNS Zones on Windows DNS servers.

## Script

```powershell
./scripts/Add-DNSConditionalForwardersforAzurePrivateDNSZones.ps1
```

### Notes

- This script must be run with an account that is a domain administrator.
- This script must be run on a Windows DNS server, and the DNSServer module must be installed.
- This script assumes you'll run this for each Windows DNS server you need the conditional forwarders on. It does not create AD-integrated zones as that would cause issues if Windows DNS servers are in Azure.

## Description

This script manages DNS conditional forwarders for a list of Azure Private DNS Zones.
It can add new conditional forwarders with specified IP addresses or remove all existing conditional forwarders based on the provided parameters.

## Parameters

Name | Default Value | Description
---- | ------------- | -----------
Remove | False         | If specified, the script will remove all existing conditional forwarder zones. This may be necessary to clean up old or incorrect conditional forwarders. You'll be prompted to confirm the removal of each conditional forwarder.
IpAddresses | _null_        | Specifies the IP addresses for the DNS forwarders. This parameter is required when adding new conditional forwarders. Typically the IP would be the IP address of the Azure DNS resolver in Azure, or the IP address of the virtual machine Windows DNS server(s) hosted in Azure.

## Examples

### Example 1

```powershell
.\Add-DNSConditionalForwardersforAzurePrivateDNSZones.ps1 -IpAddresses '10.11.17.4', '10.11.17.5'
Adds DNS conditional forwarders for the specified domains with the provided IP addresses.
```

### Example 2

```powershell
.\Add-DNSConditionalForwardersforAzurePrivateDNSZones.ps1 -Remove
Removes all existing DNS conditional forwarder zones.
```
