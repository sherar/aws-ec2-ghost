# AWS EC2 + Ghost with Ansible!

This solution allows [Ghost](https://ghost.org/) to be deployed on [AWS EC2](https://aws.amazon.com/ec2/) and configured with [Ansible](https://www.ansible.com/).

## Getting started

### Pre-requireements:

- Install [Terraform 1.1.9](https://learn.hashicorp.com/tutorials/terraform/install-cli)

To spin up the infrastructure
```
terraform apply
```

To delete all resources
```
terraform destroy
```

## The solution

This infrastructure-as-code solution spins up all networking components in AWS needed to run a AWS EC2 box + AWS EC2 machine where Ghost runs.

Ansible is the tool of choicee for configuring Ghost in the AWS EC2 machine. 



## What can be improved

This repo was created for development purposes so before using this solution in a production environment the following tasks should be achieved:

- **Secrets management configuration**. We need to keep sensitive data in a safe place and retrieve the secrets from there on real time.
- **WAF + ALB + Autoscaling group**. The current t2.micro is not enough for going live. It's required to setup an AWS WAF with core rules (rate-based, OWASP Top10, etc) as well as a Application Load Balancer with Autoscalling group so in case that the load increases we can scale up and later scale down if needed. Also it will be important to make sure the EC2 boxes are running in a private subnet, so the ALB will be the facing internet app.
- **Update to t3.medium for development**. Even when spining up the infrastructure, the Free Tier most common option `t2.micro` is not enough, as Ghost consumes more resources to install it so it's better to use at least `t3.medium` or a more powerful instance type.
- **Use Terraform S3 backend**. At least the Terraform state should live outside the repository in a safe place like a S3 bucket or similar. It shouldn't be stored within the code base.
- **Create a dedicated folder for Ghost static content**. This folder will determine where all visual changes created by developers are stored. We can trigger Terraform+Ansible to update the infrastructure when changes are made to this directory.
- **SSH shouldn't be enabled to the world 0.0.0.0/0**. Instead we could use AWS session manager to interact with the virtual machine when needed. This way we can make sure port 22 (SSH) is closed permamently but we still have a way to SSH to the machine.
- **Document ADR (Architectural Decision Records)**. Add proper documentation on how this decision is archtiected for further reference. An ADR explains why things were doing on a certain way.

