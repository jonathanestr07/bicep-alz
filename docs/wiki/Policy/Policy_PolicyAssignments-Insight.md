# Policy Assignments - Insight

## Management Group (intRoot)

Name | DisplayName | Description | Scope | NotScopes
---- | ----------- | ----------- | ----- | ---------
Deploy-Update-Manager | Configure periodic checking of System updates | This initiative assignment configures periodic checking of Azure and Azure Arc Virtual Machines. | *     |  
Deploy-Automanage-Custom | Deploy Azure Automanage Custom Configuration Profile | Apply Automanage with a customized Configuration Profile to Azure virtual machines. | *     |  
Enforce-Governance | Enforce Azure Governance Guardrails | Enforce Azure Governance Guardrails for Tagging, Hybrid Use Benefits and other governance constructs. | *     |  
Deploy-Flow-Logs | Deploy a NSG Flow Log to associated Network Security Groups | Configures flow log for specific network security group. It will allow to log information about IP traffic flowing through an network security group. Flow log helps to identify unknown or undesired traffic, verify network isolation and compliance with enterprise access rules, analyze network flows from compromised IPs and network interfaces. | *     |  
Enforce-Naming-Standards | Enforce Azure Naming Standards | This Policy Assignment Enforces Azure Naming Standards across Azure Resources. | *     |  
Deploy-Activity-Log-Sta | Deploy Diagnostic Settings for Activity Log to Azure Storage | Ensures that Activity Log Diagnostics settings are set to push logs into a Storage Account for Long term retention. | *     |  
Deploy-DNSZone-Link-`[copyIndex()]` | Deploy Private DNS Zone Virtual Network Link to Virtual Networks | This policy deploys the Private DNS Zone Virtual Network Link to Virtual Networks if it doesn't exist. | *     |  
Deploy-ServiceHealth | Deploy Service Health Alert for Subscription | Deploy Service Health Alert for a given region, incident type and list of impacted services. | *     |  

## Management Group (landingZones)

Name | DisplayName | Description | Scope | NotScopes
---- | ----------- | ----------- | ----- | ---------
Deploy-Azure-CIS | CIS Microsoft Azure Foundations Benchmark v1.4.0 | The Center for Internet Security (CIS) is a nonprofit entity whose mission is to 'identify, develop, validate, promote, and sustain best practice solutions for cyber defense.' CIS benchmarks are configuration baselines and best practices for securely configuring a system. These policies address a subset of CIS Microsoft Azure Foundations Benchmark v1.4.0 controls. For more information, visit https://aka.ms/cisazure130-initiative | *     |  
Deploy-ISO-27001-2013 | ISO 27001:2013 | The International Organization for Standardization (ISO) 27001 standard provides requirements for establishing, implementing, maintaining, and continuously improving an Information Security Management System (ISMS). These policies address a subset of ISO 27001:2013 controls. Additional policies will be added in upcoming releases. For more information, visit https://aka.ms/iso27001-init | *     |  
Deploy-NIST-800-53 | NIST SP 800-53 Rev. 5 | National Institute of Standards and Technology (NIST) SP 800-53 Rev. 5 provides a standardized approach for assessing, monitoring and authorizing cloud computing products and services to manage information security risk. These policies address a subset of NIST SP 800-53 R5 controls. Additional policies will be added in upcoming releases. For more information, visit https://aka.ms/nist800-53r5-initiative | *     |  
Deploy-ISM-Protected | Australian Government ISM PROTECTED | This initiative includes policies that address a subset of Australian Government Information Security Manual (ISM) controls. Additional policies will be added in upcoming releases. For more information, visit https://aka.ms/auism-initiative. | *     |  
Deny-Azure-Resources | Deny Azure Resources | This policy denies the creation of specific Azure resources. | *     |  

## Management Group (platform)

Name | DisplayName | Description | Scope | NotScopes
---- | ----------- | ----------- | ----- | ---------
Deny-Resource-Delete | Deny Azure Resource Deletion for specific Azure Resources | Deny Resource Deletion for identified Azure Resources. | *     |  
