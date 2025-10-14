# Copilot Instructions for Azure Landing Zone Bicep Repository

## Repository Overview

This repository contains Azure Landing Zone Platform implementation using Bicep Infrastructure as Code (IaC), developed and maintained by Insight Services APAC. It provides a scalable, modular approach to deploying enterprise-grade Azure environments with proper governance, security, and networking controls.

## Key Concepts

### Azure Landing Zones

- **Platform Landing Zones**: Centralised services (networking, identity, management) operated by central teams
- **Application Landing Zones**: Subscriptions for specific applications/workloads, categorized as centrally managed, technology platforms, or workload-delegated

### Repository Structure

- **src/modules/**: Reusable Bicep modules organized by Azure resource namespace
- **src/orchestration/**: Complete deployment patterns leveraging existing modules
- **docs/wiki/**: Comprehensive documentation and guidance
- **scripts/**: PowerShell automation and helper scripts
- **tests/**: Pester tests for validation

## Development Guidelines

### Bicep Best Practices

1. Follow [Microsoft Bicep best practices](https://learn.microsoft.com/azure/azure-resource-manager/bicep/best-practices)
2. Use the configured Bicep analyser rules in `src/bicepconfig.json`
3. Implement proper parameter validation and documentation
4. Use consistent naming conventions and resource tagging
5. Leverage modules for reusability and maintainability

### Code Quality Standards

- All Bicep code must pass linting and validation
- Follow the Well-Architected Framework principles:
  - Reliability
  - Security  
  - Cost Optimisation
  - Operational Excellence
  - Performance Efficiency

### Module Development

When creating or modifying Bicep modules:

- Place reusable components in `src/modules/`
- Organize by Azure resource provider namespace
- Include comprehensive parameter documentation
- Implement proper error handling and validation
- Follow consistent output patterns

### Orchestration Patterns

For deployment orchestrations in `src/orchestration/`:

- **platformConnectivity/**: Network infrastructure and connectivity
- **platformIdentity/**: Identity and access management
- **platformManagement/**: Monitoring, logging, and governance
- **privilegedIdentityManagement/**: PIM configurations

## Testing and Validation

### Required Testing

- Run PSRule analysis using the workspace task "PSRule: Run analysis"
- Execute Pester tests in the `tests/` directory
- Validate Bicep templates using `bicep build` and `az deployment validate`
- Test deployment in isolated environments before production

### PowerShell Scripts

Leverage existing scripts in the `scripts/` directory:

- `Test-BicepModules.ps1`: Validate Bicep modules
- `Deploy-AzureResources.ps1`: Deployment automation
- `Confirm-LandingZonePrerequisites.ps1`: Pre-deployment validation

## Branching and Contribution

### Branch Naming

Use these patterns:

- `feature/<feature-name>` or `feature/<issue-id>`
- `bug/<bug-name>` or `bug/<issue-id>`
- `<handle>/<description>`

### Pull Request Process

1. Create feature branch from `main`
2. Implement changes following coding standards
3. Run tests and validation locally
4. Submit PR with comprehensive description
5. Address review feedback promptly
6. Ensure CI/CD pipeline passes

## Azure Resource Patterns

### Common Resource Types

When working with these Azure resources, follow established patterns:

- **Networking**: Hub-spoke topology, VNet peering, private endpoints
- **Identity**: Azure AD integration, PIM, custom roles
- **Security**: NSGs, Azure Firewall, Key Vault, Defender for Cloud
- **Monitoring**: Log Analytics, Application Insights, Azure Monitor
- **Governance**: Management Groups, Azure Policy, resource tags

### Configuration Management

- Use parameter files for environment-specific configurations
- Leverage Azure Policy for governance and compliance
- Implement proper RBAC and least-privilege access
- Configure monitoring and alerting consistently

## Documentation Standards

### Code Documentation

- Include comprehensive module descriptions
- Document all parameters with types and descriptions
- Provide usage examples in module READMEs
- Maintain inline comments for complex logic

### Wiki Maintenance

Keep documentation current in `docs/wiki/`:

- Update Getting Started guide for new features
- Maintain architectural diagrams and designs
- Document troubleshooting procedures
- Include customer usage examples

## Security Considerations

### Secrets Management

- Never commit secrets or sensitive data
- Use Azure Key Vault for secret storage
- Implement managed identities where possible
- Follow least-privilege access principles

### Network Security

- Implement defense-in-depth strategies
- Use private endpoints for PaaS services
- Configure NSGs and Azure Firewall rules appropriately
- Enable network monitoring and logging

## Deployment Patterns

### Platform Deployment Order

1. Management Groups and governance
2. Platform identity subscription
3. Platform connectivity (networking)
4. Platform management (monitoring/logging)
5. Application landing zones

### Environment Promotion

- Validate in development environments first
- Use infrastructure-as-code for consistency
- Implement proper change management
- Maintain deployment documentation

## Troubleshooting

### Common Issues

- Bicep compilation errors: Check syntax and module references
- Deployment failures: Validate resource dependencies and permissions
- Policy conflicts: Review management group policy assignments
- Network connectivity: Verify NSG rules and routing tables

### Debugging Tools

- Use Azure CLI/PowerShell for resource investigation
- Leverage Azure Monitor for performance troubleshooting
- Check Activity Logs for deployment issues
- Utilise PSRule for compliance validation

## Integration Patterns

### CI/CD Integration

- GitHub Actions workflows for automated validation
- PSRule integration for policy compliance
- Automated testing and deployment pipelines
- Artifact management and versioning

### Monitoring Integration

- Centralised logging with Log Analytics
- Azure Monitor dashboards and alerts
- Performance monitoring and optimisation
- Security monitoring with Sentinel integration

---

When working with this repository, always prioritise security, scalability, and maintainability. Leverage the existing patterns and modules where possible, and contribute improvements back to benefit the entire team and customer base.
