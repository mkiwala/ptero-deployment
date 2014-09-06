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
3. Configure staging and production stacks in `config.yaml`
   (see below).
4. Deploy a staging environment with
   `fab stack.create:env=staging,tag=<branch_or_tag>`.
5. Test staging deployment with `fab tests.fast:staging`.
6. Destroy staging environment with `fab stack.delete:staging`.
7. Deploy production environment with
   `fab stack.create:env=production,tag=<branch_or_tag>`.
8. Test production deployment with `fab tests.fast:production`.

### Update PTero
1. Deploy a staging environment with
   `fab stack.create:env=staging,tag=<old_tag>`.
2. Test staging environment with `fab tests.fast:env=staging,tag=<old_tag>`.
3. Initiate long-running test with `fab tests.slow:env=staging,tag=<old_tag> &`.
4. Apply update to staging environment with
   `fab update:env=staging,tag=<new_tag>`.
5. Test staging environment with `fab tests.fast:env=staging,tag=<new_tag>`.
6. Wait for long-running test to succeed.
7. Destroy staging environment with `fab stack.delete:staging`.
8. Initiate long-running test with
   `fab tests.slow:env=production,tag=<new_tag> &`.
9. Apply update to production environment with
   `fab stack.update:env=production,tag=<new_tag>`.
10. Test production environment with
    `fab tests.fast:env=production,tag=<new_tag>`.
11. Wait for long-running test to succeed.

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


## Configuration
Heat template parameters used for various stacks, including common
parameters are contained in `config.yaml`.  For example:

    images:
        build:
            build_machine_image: some-vm-image
            base_image_urls:
                default: http://some.place/with/some/image
                shell-command:
                    worker: http://another.place/with/a/different/image

    stacks:
        common:
            public_net_id: some-uuid

        staging:
            stack_name: ptero-staging
            default_shell_command_worker_instances: 1

        production:
            stack_name: ptero-production
            default_shell_command_worker_instances: 4
