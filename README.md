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
4. Deploy and test a staging environment with
   `fab deploy:name=staging,tag=<branch_or_tag>`.
5. Destroy `<environment>` environment with `fab stack.delete:<environment>`.
6. Deploy and test a production environment with
   `fab deploy:name=production,tag=<branch_or_tag>`.

`fab deploy:name=<environment>,tag=<branch_or_tag>` when no such stack is
deployed is equivalent to:

1. Build and upload new images if needed with
   `fab images.build_and_upload:tag=<new_tag>`
2. Deploy a `<environment>` environment with
   `fab stack.create:name=<environment>,tag=<branch_or_tag>`.
3. Test `<environment>` deployment with `fab tests.fast:<environment>`.

### Update PTero
1. Deploy and test a staging environment with
   `fab deploy:name=staging,tag=<old_tag>`.
2. Apply update to staging environment and test the update with
   `fab deploy:name=staging,tag=<new_tag>`.
3. Destroy staging environment with `fab stack.delete:staging`.
4. Apply update to staging environment and test the update with
   `fab deploy:name=production,tag=<new_tag>`.

`fab deploy:name=<environment>,tag=<new_tag>` when a stack is deployed is
equivalent to:

1. Build and upload new images if needed with
   `fab images.build_and_upload:tag=<new_tag>`
2. Initiate long-running test with
   `fab tests.slow:name=<environment>,tag=<old_tag> &`.
3. Apply update to `<environment>` environment with
   `fab stack.update:name=<environment>,tag=<new_tag>`.
4. Test `<environment>` environment with
    `fab tests.fast:name=<environment>,tag=<new_tag>`.
5. Wait for long-running test to succeed.

### Rollback PTero
1. Apply the update to the stack with
   `fab rollback:name=production`

`fab rollback:name=production` is equivalent to:

1. Apply rollback to production environment with
   `fab stack.update:name=production,tag=<old_tag>`.
2. Test production environment with
   `fab tests.fast:name=production,tag=<old_tag>`.

### Remove Old Images
Delete old service images using `fab images.delete:<ancient_tag>`.

### Remove PTero
Destroy the production environment with `fab stack.delete:production`.


## OpenStack Credentials
Credentials needed by the OpenStack client libraries should be specified in
environment:

    OS_USERNAME=auser
    OS_PASSWORD=apass
    OS_PROJECT_NAME=aproject
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
