# Policy Assignments - ALZ Default

## Management Group (decommissioned)

Name | DisplayName | Description | Scope | NotScopes
---- | ----------- | ----------- | ----- | ---------
Enforce-ALZ-Decomm | Enforce ALZ Decommissioned Guardrails | This initiative will help enforce and govern subscriptions that are placed within the decommissioned Management Group as part of your Subscription decommissioning process. See https://aka.ms/alz/policies for more information. | *     |  

## Management Group (intRoot)

Name | DisplayName | Description | Scope | NotScopes
---- | ----------- | ----------- | ----- | ---------
Deploy-MDFC-Config-H224 | Deploy Microsoft Defender for Cloud configuration | Deploy Microsoft Defender for Cloud configuration and Security Contacts | *     |  
Deploy-MDEndpoints | [Preview]: Deploy Microsoft Defender for Endpoint agent | Deploy Microsoft Defender for Endpoint agent on applicable images. | *     |  
Deploy-MDEndpointsAMA | Configure multiple Microsoft Defender for Endpoint integration settings with Microsoft Defender for Cloud | Configure the multiple Microsoft Defender for Endpoint integration settings with Microsoft Defender for Cloud (WDATP, WDATP_EXCLUDE_LINUX_PUBLIC_PREVIEW, WDATP_UNIFIED_SOLUTION etc.). See: https://learn.microsoft.com/azure/defender-for-cloud/integration-defender-for-endpoint for more information. | *     |  
Deploy-AzActivity-Log | Deploy Diagnostic Settings for Activity Log to Log Analytics workspace | Ensures that Activity Log Diagnostics settings are set to push logs into Log Analytics workspace. | *     |  
Deploy-ASC-Monitoring | Enable Monitoring in Microsoft Defender for Cloud | Enable Monitoring in Microsoft Defender for Cloud. | *     |  
Deploy-Diag-Logs | Enable allLogs category group resource logging for supported resources to Log Analytics | Resource logs should be enabled to track activities and events that take place on your resources and give you visibility and insights into any changes that occur. This initiative deploys diagnostic setting using the allLogs category group to route logs to an Event Hub for all supported resources. | *     |  
Enforce-ACSB | Enforce Azure Compute Security Baseline compliance auditing | This initiative assignment enables Azure Compute Security Baseline compliance auditing for Windows and Linux virtual machines. | *     |  
Deploy-MDFC-OssDb | Configure Advanced Threat Protection to be enabled on open-source relational databases | Enable Advanced Threat Protection on your non-Basic tier open-source relational databases to detect anomalous activities indicating unusual and potentially harmful attempts to access or exploit databases. See https://aka.ms/AzDforOpenSourceDBsDocu. | *     |  
Deploy-MDFC-SqlAtp | Configure Azure Defender to be enabled on SQL Servers and SQL Managed Instances | Enable Azure Defender on your SQL Servers and SQL Managed Instances to detect anomalous activities indicating unusual and potentially harmful attempts to access or exploit databases. | *     |  
Audit-Location-Match | Audit that the resource location matches its resource group location | Audit resource location matches resource group location | *     |  
Audit-ZoneResiliency | Resources should be Zone Resilient | Resources should be Zone Resilient. | *     |  
Audit-UnusedResources | Unused resources driving cost should be avoided | This Policy initiative is a group of Policy definitions that help optimize cost by detecting unused but chargeable resources. Leverage this Policy initiative as a cost control to reveal orphaned resources that are driving cost. | *     |  
Audit-TrustedLaunch | Audit virtual machines for Trusted Launch support | Trusted Launch improves security of a Virtual Machine which requires VM SKU, OS Disk & OS Image to support it (Gen 2). To learn more about Trusted Launch, visit https://aka.ms/trustedlaunch. | *     |  
Deny-UnmanagedDisk | Deny virtual machines and virtual machine scale sets that do not use managed disk | Deny virtual machines that do not use managed disk. It checks the managed disk property on virtual machine OS Disk fields. | *     |  
Deny-Classic-Resources | Deny the deployment of classic resources | Denies deployment of classic resource types under the assigned scope. | *     |  

## Management Group (landingZones)

Name | DisplayName | Description | Scope | NotScopes
---- | ----------- | ----------- | ----- | ---------
Deny-IP-Forwarding | Network interfaces should disable IP forwarding | This policy denies the network interfaces which enabled IP forwarding. The setting of IP forwarding disables Azure's check of the source and destination for a network interface. This should be reviewed by the network security team. | *     |  
Deny-MgmtPorts-Internet | Management port access from the Internet should be blocked | This policy denies any network security rule that allows management port access from the Internet | *     |  
Deny-Subnet-Without-Nsg | Subnets should have a Network Security Group | This policy denies the creation of a subnet without a Network Security Group to protect traffic across subnets. | *     |  
Deploy-VM-Backup | Configure backup on virtual machines without a given tag to a new recovery services vault with a default policy | Enforce backup for all virtual machines by deploying a recovery services vault in the same location and resource group as the virtual machine. Doing this is useful when different application teams in your organization are allocated separate resource groups and need to manage their own backups and restores. You can optionally exclude virtual machines containing a specified tag to control the scope of assignment. See https://aka.ms/AzureVMAppCentricBackupExcludeTag. | *     |  
Enable-DDoS-VNET | Virtual networks should be protected by Azure DDoS Protection Standard | Protect your virtual networks against volumetric and protocol attacks with Azure DDoS Protection Standard. For more information, visit https://aka.ms/ddosprotectiondocs. | *     |  
Deny-Storage-http | Secure transfer to storage accounts should be enabled | Audit requirement of Secure transfer in your storage account. Secure transfer is an option that forces your storage account to accept requests only from secure connections (HTTPS). Use of HTTPS ensures authentication between the server and the service and protects data in transit from network layer attacks such as man-in-the-middle, eavesdropping, and session-hijacking. | *     |  
Deploy-AKS-Policy | Deploy Azure Policy Add-on to Azure Kubernetes Service clusters | Use Azure Policy Add-on to manage and report on the compliance state of your Azure Kubernetes Service (AKS) clusters. For more information, see https://aka.ms/akspolicydoc. | *     |  
Deny-Priv-Escalation-AKS | Kubernetes clusters should not allow container privilege escalation | Do not allow containers to run with privilege escalation to root in a Kubernetes cluster. This recommendation is part of CIS 5.2.5 which is intended to improve the security of your Kubernetes environments. This policy is generally available for Kubernetes Service (AKS), and preview for AKS Engine and Azure Arc enabled Kubernetes. For more information, see https://aka.ms/kubepolicydoc. | *     |  
Deny-Priv-Containers-AKS | Kubernetes cluster should not allow privileged containers | Do not allow privileged containers creation in a Kubernetes cluster. This recommendation is part of CIS 5.2.1 which is intended to improve the security of your Kubernetes environments. This policy is generally available for Kubernetes Service (AKS), and preview for AKS Engine and Azure Arc enabled Kubernetes. For more information, see https://aka.ms/kubepolicydoc. | *     |  
Enforce-AKS-HTTPS | Kubernetes clusters should be accessible only over HTTPS | Use of HTTPS ensures authentication and protects data in transit from network layer eavesdropping attacks. This capability is currently generally available for Kubernetes Service (AKS), and in preview for AKS Engine and Azure Arc enabled Kubernetes. For more info, visit https://aka.ms/kubepolicydoc. | *     |  
Enforce-TLS-SSL-Q225 | Deny or Deploy and append TLS requirements and SSL enforcement on resources without Encryption in transit | Choose either Deploy if not exist and append in combination with audit or Select Deny in the Policy effect. Deny polices shift left. Deploy if not exist and append enforce but can be changed, and because missing exsistense condition require then the combination of Audit. | *     |  
Deploy-AzSqlDb-Auditing | Configure SQL servers to have auditing enabled to Log Analytics workspace | To ensure the operations performed against your SQL assets are captured, SQL servers should have auditing enabled. If auditing is not enabled, this policy will configure auditing events to flow to the specified Log Analytics workspace. | *     |  
Deploy-SQL-Threat | Deploy Threat Detection on SQL servers | This policy ensures that Threat Detection is enabled on SQL Servers. | *     |  
Deploy-SQL-TDE | Deploy TDE on SQL servers | This policy ensures that Transparent Data Encryption is enabled on SQL Servers. | *     |  
Deploy-vmArc-ChangeTrack | Enable ChangeTracking and Inventory for Arc-enabled virtual machines | Enable ChangeTracking and Inventory for Arc-enabled virtual machines. Takes Data Collection Rule ID as parameter and asks for an option to input applicable locations. | *     |  
Deploy-VM-ChangeTrack | Enable ChangeTracking and Inventory for virtual machines | Enable ChangeTracking and Inventory for virtual machines. Takes Data Collection Rule ID as parameter and asks for an option to input applicable locations and user-assigned identity for Azure Monitor Agent. | *     |  
Deploy-VMSS-ChangeTrack | Enable ChangeTracking and Inventory for virtual machine scale sets | Enable ChangeTracking and Inventory for virtual machine scale sets. Takes Data Collection Rule ID as parameter and asks for an option to input applicable locations and user-assigned identity for Azure Monitor Agent. | *     |  
Deploy-vmHybr-Monitoring | Enable Azure Monitor for Hybrid Virtual Machines | Enable Azure Monitor for Hybrid Virtual Machines in the specified scope (Management group, Subscription or resource group). | *     |  
Deploy-VM-Monitor-24 | Enable Azure Monitor for VMs | Enable Azure Monitor for the virtual machines (VMs) in the specified scope (management group, subscription or resource group). Takes Log Analytics workspace as parameter. | *     |  
Deploy-VMSS-Monitor-24 | Enable Azure Monitor for Virtual Machine Scale Sets | Enable Azure Monitor for the Virtual Machine Scale Sets in the specified scope (Management group, Subscription or resource group). Takes Log Analytics workspace as parameter. Note: if your scale set upgradePolicy is set to Manual, you need to apply the extension to the all VMs in the set by calling upgrade on them. In CLI this would be az vmss update-instances. | *     |  
Deploy-MDFC-DefSQL-AMA | Enable Defender for SQL on SQL VMs and Arc-enabled SQL Servers | Microsoft Defender for SQL collects events from the agents and uses them to provide security alerts and tailored hardening tasks (recommendations). | *     |  
Enforce-GR-KeyVault | Enforce recommended guardrails for Azure Key Vault | This initiative assignment enables recommended ALZ guardrails for Azure Key Vault. | *     |  
Enforce-ASR | Enforce enhanced recovery and backup policies | This initiative assignment enables recommended ALZ guardrails for Azure Recovery Services. | *     |  
Enable-AUM-CheckUpdates | Configure periodic checking for missing system updates on azure virtual machines and Arc-enabled virtual machines. | Configure auto-assessment (every 24 hours) for OS updates. You can control the scope of assignment according to machine subscription, resource group, location or tag. Learn more about this for Windows: https://aka.ms/computevm-windowspatchassessmentmode, for Linux: https://aka.ms/computevm-linuxpatchassessmentmode. | *     |  
Audit-AppGW-WAF | Web Application Firewall (WAF) should be enabled for Application Gateway | Assign the WAF should be enabled for Application Gateway audit policy. | *     |  
Deny-Resource-Locations | Limit allowed locations for Resources | Specifies the allowed locations (regions) where Resources can be deployed. | *     |  
Deny-RSG-Locations | Limit allowed locations for Resource Groups | Specifies the allowed locations (regions) where Resource Groups can be deployed. | *     |  
Deploy-SQL-Security | Deploy-SQL-Security | Deploy-SQL-Security. | *     |  

## Management Group (landingZonesCorp)

Name | DisplayName | Description | Scope | NotScopes
---- | ----------- | ----------- | ----- | ---------
Deny-Public-Endpoints | Public network access should be disabled for PaaS services | This policy initiative is a group of policies that prevents creation of Azure PaaS services with exposed public endpoints. | *     |  
Deploy-Private-DNS-Zones | Configure Azure PaaS services to use private DNS zones | This policy initiative is a group of policies that ensures private endpoints to Azure PaaS services are integrated with Azure Private DNS zones. | *     |  
Deny-Public-IP-On-NIC | Deny network interfaces having a public IP associated | This policy denies network interfaces from having a public IP associated to it under the assigned scope. | *     |  
Deny-HybridNetworking | Deny the deployment of vWAN/ER/VPN gateway resources | Denies deployment of vWAN/ER/VPN gateway resources in the Corp landing zone. | *     |  
Audit-PeDnsZones | Audit Private Link Private DNS Zone resources | Audits the deployment of Private Link Private DNS Zone resources in the Corp landing zone. | *     |  

## Management Group (platform)

Name | DisplayName | Description | Scope | NotScopes
---- | ----------- | ----------- | ----- | ---------
Deploy-vmArc-ChangeTrack | Enable ChangeTracking and Inventory for Arc-enabled virtual machines | Enable ChangeTracking and Inventory for Arc-enabled virtual machines. Takes Data Collection Rule ID as parameter and asks for an option to input applicable locations. | *     |  
Deploy-VM-ChangeTrack | Enable ChangeTracking and Inventory for virtual machines | Enable ChangeTracking and Inventory for virtual machines. Takes Data Collection Rule ID as parameter and asks for an option to input applicable locations and user-assigned identity for Azure Monitor Agent. | *     |  
Deploy-VMSS-ChangeTrack | Enable ChangeTracking and Inventory for virtual machine scale sets | Enable ChangeTracking and Inventory for virtual machine scale sets. Takes Data Collection Rule ID as parameter and asks for an option to input applicable locations and user-assigned identity for Azure Monitor Agent. | *     |  
Deploy-vmHybr-Monitoring | Enable Azure Monitor for Hybrid Virtual Machines | Enable Azure Monitor for Hybrid Virtual Machines in the specified scope (Management group, Subscription or resource group). | *     |  
Deploy-VM-Monitor-24 | Enable Azure Monitor for VMs | Enable Azure Monitor for the virtual machines (VMs) in the specified scope (management group, subscription or resource group). Takes Log Analytics workspace as parameter. | *     |  
Deploy-MDFC-DefSQL-AMA | Enable Defender for SQL on SQL VMs and Arc-enabled SQL Servers | Microsoft Defender for SQL collects events from the agents and uses them to provide security alerts and tailored hardening tasks (recommendations). | *     |  
DenyAction-DeleteUAMIAMA | Do not allow deletion of the User Assigned Managed Identity used by AMA | This policy provides a safeguard against accidental removal of the User Assigned Managed Identity used by AMA by blocking delete calls using deny action effect. | ${current_scope_resource_id} |  
Deploy-VMSS-Monitor-24 | Enable Azure Monitor for Virtual Machine Scale Sets | Enable Azure Monitor for the Virtual Machine Scale Sets in the specified scope (Management group, Subscription or resource group). Takes Log Analytics workspace as parameter. Note: if your scale set upgradePolicy is set to Manual, you need to apply the extension to the all VMs in the set by calling upgrade on them. In CLI this would be az vmss update-instances. | *     |  
Enforce-GR-KeyVault | Enforce recommended guardrails for Azure Key Vault | This initiative assignment enables recommended ALZ guardrails for Azure Key Vault. | *     |  
Enforce-ASR | Enforce enhanced recovery and backup policies | This initiative assignment enables recommended ALZ guardrails for Azure Recovery Services. | *     |  
Enable-AUM-CheckUpdates | Configure periodic checking for missing system updates on azure virtual machines and Arc-enabled virtual machines. | Configure auto-assessment (every 24 hours) for OS updates. You can control the scope of assignment according to machine subscription, resource group, location or tag. Learn more about this for Windows: https://aka.ms/computevm-windowspatchassessmentmode, for Linux: https://aka.ms/computevm-linuxpatchassessmentmode. | *     |  

## Management Group (platformConnectivity)

Name | DisplayName | Description | Scope | NotScopes
---- | ----------- | ----------- | ----- | ---------
Enable-DDoS-VNET | Virtual networks should be protected by Azure DDoS Protection Standard | Protect your virtual networks against volumetric and protocol attacks with Azure DDoS Protection Standard. For more information, visit https://aka.ms/ddosprotectiondocs. | *     |  

## Management Group (platformIdentity)

Name | DisplayName | Description | Scope | NotScopes
---- | ----------- | ----------- | ----- | ---------
Deny-Public-IP | Deny the creation of public IP | This policy denies creation of Public IPs under the assigned scope. | *     |  
Deny-MgmtPorts-Internet | Management port access from the Internet should be blocked | This policy denies any network security rule that allows management port access from the Internet | *     |  
Deny-Subnet-Without-Nsg | Subnets should have a Network Security Group | This policy denies the creation of a subnet without a Network Security Group to protect traffic across subnets. | *     |  
Deploy-VM-Backup | Configure backup on virtual machines without a given tag to a new recovery services vault with a default policy | Enforce backup for all virtual machines by deploying a recovery services vault in the same location and resource group as the virtual machine. Doing this is useful when different application teams in your organization are allocated separate resource groups and need to manage their own backups and restores. You can optionally exclude virtual machines containing a specified tag to control the scope of assignment. See https://aka.ms/AzureVMAppCentricBackupExcludeTag. | *     |  

## Management Group (platformManagement)

Name | DisplayName | Description | Scope | NotScopes
---- | ----------- | ----------- | ----- | ---------
Deploy-Log-Analytics | Deploy-Log-Analytics | Deploy-Log-Analytics. | *     |  

## Management Group (sandbox)

Name | DisplayName | Description | Scope | NotScopes
---- | ----------- | ----------- | ----- | ---------
Enforce-ALZ-Sandbox | Enforce ALZ Sandbox Guardrails | This initiative will help enforce and govern subscriptions that are placed within the Sandobx Management Group. See https://aka.ms/alz/policies for more information. | *     |  
