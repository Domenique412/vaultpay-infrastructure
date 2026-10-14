## Overview

VaultPay is a containerized transaction operations dashboard deployed on AWS with Terraform. It provides a web interface for monitoring payment activity, viewing alerts, and writing operational reports to S3.

The infrastructure is organized into three reusable Terraform modules:

- **VPC module:** Creates the network across two Availability Zones, including public, application private, and database private subnets, routing, an Internet Gateway, and a NAT Gateway.

- **Database module:** Deploys an encrypted PostgreSQL RDS instance in private database subnets. Its credentials are generated and managed through AWS Secrets Manager.

- **Application module:** Creates the ECR repository, S3 runtime bucket, IAM permissions, Application Load Balancer, launch template, and Auto Scaling Group that runs the VaultPay Docker container on private EC2 instances.

Public traffic enters through the Application Load Balancer. The load balancer forwards requests to EC2 instances in private subnets, while security groups restrict database access to the application tier on PostgreSQL port 5432. EC2 instances use an IAM role to pull the container image from ECR, retrieve the database secret, write reports to the designated S3 prefix, and connect through AWS Systems Manager without exposing SSH.

## Why I Built It

I built VaultPay to practice designing and deploying a secure, multi-tier AWS environment through Infrastructure as Code. The project helped me apply Terraform concepts including modules, variables, outputs, remote state, dependency management, resource addressing, launch templates, and state preserving refactoring.

It also provided hands-on experience with:

- Network segmentation and private subnets
- Application load balancing and health checks
- Auto Scaling Groups and replaceable compute
- Docker image storage and deployment through Amazon ECR
- PostgreSQL deployment with Amazon RDS
- Secrets Manager integration
- Least-privilege IAM policies
- Security group to security group access rules
- Systems Manager access without public SSH
- Troubleshooting failed user data, unhealthy targets, and HTTP 502 responses

## Outcome

The project produced a working, modular AWS application stack managed through Terraform. VaultPay can be reached through its public load balancer while its application instances and database remain in private subnets.

The completed architecture demonstrates how networking, compute, containers, identity, storage, secrets, load balancing, scaling, and databases work together in a production shaped cloud environment. It also demonstrates the full operational workflow: plan infrastructure changes, apply them, publish the application image, validate live resources, diagnose failures, recover unhealthy instances, and safely destroy the lab environment when finished.
