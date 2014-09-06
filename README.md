# PTero Deployment Scripts
This repository contains the scripts necessary to deploy and update all PTero
services.

## Description
- Describe deployment architecture
    - single points of failure?
    - particular areas to monitor?
- Deployment technologies
    - heat
    - puppet
    - fabric

## Howto

### Deploy PTero
1. Install tool requirements with `pip install -r requirements.txt`.
2. Setup OpenStack credentials (see below).
3. Configure staging and production environments in `environments.yaml`
   (see below).
4. Build and uploadservice images with
   `fab images.build:<branch_or_tag> images.upload:<branch_or_tag>`.
5. Deploy a staging environment with
   `fab stack.create:env=staging,tag=<branch_or_tag>`.
6. Test staging deployment with `fab tests.fast:staging`.
7. Destroy staging environment with `fab stack.delete:staging`.
8. Deploy production environment with
   `fab stack.create:env=production,tag=<branch_or_tag>`.
9. Test production deployment with `fab tests.fast:production`.

### Update PTero
1. Build and upload service images with
   `fab images.build:<new_tag> images.upload:<new_tag>`.
2. Deploy a staging environment with
   `fab stack.create:env=staging,tag=<old_tag>`.
3. Test staging environment with `fab tests.fast:env=staging,tag=<old_tag>`.
4. Initiate long-running test with `fab tests.slow:env=staging,tag=<old_tag> &`.
5. Apply update to staging environment with
   `fab update:env=staging,tag=<new_tag>`.
6. Test staging environment with `fab tests.fast:env=staging,tag=<new_tag>`.
7. Wait for long-running test to succeed.
8. Destroy staging environment with `fab stack.delete:staging`.
9. Initiate long-running test with
   `fab tests.slow:env=production,tag=<new_tag> &`.
10. Apply update to production environment with
   `fab stack.update:env=production,tag=<new_tag>`.
11. Test production environment with
    `fab tests.fast:env=production,tag=<new_tag>`.
12. Wait for long-running test to succeed.

### Rollback PTero
1. Apply rollback to production environment with
   `fab stack.update:env=production,tag=<old_tag>`.
2. Test production environment with
   `fab tests.fast:env=production,tag=<old_tag>`.

### Remove Old Images
Delete old service images using `fab images.delete:<ancient_tag>`.

### Remove PTero
Destroy staging environment with `fab stack.delete:production`.


## OpenStack Credentials
Credentials needed by the OpenStack CLI tools should be specified in
environment.  That typically means setting the following environment variables:

    OS_USERNAME=auser
    OS_PASSWORD=apass
    OS_PROJECT_NAME=aproject
    OS_TENANT_NAME=aproject
    OS_AUTH_URL=http://openstack.example.com/v3


## Configuring environments
Heat template parameters used for various environments, including common
parameters are contained in `environments.yaml`.  For example:

    common:
        public_net_id: some-uuid

    staging:
        stack_name: ptero-staging
        default_shell_command_worker_instances: 1

    production:
        stack_name: ptero-production
        default_shell_command_worker_instances: 4
