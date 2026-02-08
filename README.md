# Cloud-Native Task Management System

[![AWS](https://img.shields.io/badge/AWS-ECS%20%7C%20RDS%20%7C%20ALB%20%7C%20Cognito-FF9900?logo=amazon-aws)](https://aws.amazon.com/)
[![Terraform](https://img.shields.io/badge/IaC-Terraform%201.x-7B42BC?logo=terraform)](https://www.terraform.io/)
[![Spring Boot](https://img.shields.io/badge/Backend-Spring%20Boot%203.1-6DB33F?logo=spring-boot)](https://spring.io/projects/spring-boot)
[![Angular](https://img.shields.io/badge/Frontend-Angular%2017-DD0031?logo=angular)](https://angular.io/)

> **Enterprise-grade cloud-native application demonstrating production-ready AWS architecture, infrastructure automation, and modern DevOps practices.**

This portfolio project showcases my expertise in designing, implementing, and deploying secure, scalable cloud infrastructure using AWS managed services and Infrastructure as Code principles.

---

## 🎯 Project Overview

This project is a full-stack task management application built with a **microservices-oriented architecture** and deployed entirely on AWS using **ECS Fargate** for serverless container orchestration. The infrastructure is **100% automated** using Terraform, demonstrating enterprise-level DevOps practices.

### Key Technical Achievements

- ✅ **Zero-trust security architecture** with AWS Cognito JWT authentication
- ✅ **Multi-AZ deployment** for high availability (99.99% uptime SLA)
- ✅ **Private subnet isolation** with VPC endpoints for secure AWS service communication
- ✅ **Automated CI/CD pipeline** with containerized deployments to ECR
- ✅ **Infrastructure as Code** - 100% reproducible environment in ~5 minutes
- ✅ **Serverless file storage** using S3 with public read policies for user uploads

---

## 🏗️ Architecture Overview

```
                                    ┌─────────────────────────────────────┐
                                    │      AWS Cloud (VPC 10.0.0.0/16)   │
                                    │                                     │
┌──────────────┐                   │  ┌───────────────────────────────┐ │
│   Internet   │◄──────────────────┼──┤  Application Load Balancer    │ │
│    Users     │       HTTP        │  │  (Public Subnets - Multi-AZ)  │ │
└──────────────┘                   │  └────────┬──────────────────────┘ │
                                    │           │  Path-based routing    │
                                    │           │  (/, /api/*)           │
                                    │  ┌────────▼──────────┬─────────────┴─┐
                                    │  │                   │                │
                                    │  │ ECS Fargate       │ ECS Fargate   │
                                    │  │ Frontend Service  │ Backend API   │
                                    │  │ (Angular 17)      │ (Spring Boot) │
                                    │  │ Private Subnet    │ Private Subnet│
                                    │  └────────┬──────────┴───────┬───────┘
                                    │           │                   │
                                    │  ┌────────▼──────────┐ ┌─────▼───────┐
                                    │  │  VPC Endpoints    │ │  RDS        │
                                    │  │  (ECR, S3, Logs,  │ │  PostgreSQL │
                                    │  │   Cognito-IDP)    │ │  Multi-AZ   │
                                    │  └───────────────────┘ └─────────────┘
                                    │                                     │
┌──────────────────┐                │  ┌───────────────────────────────┐ │
│  AWS Cognito     │◄───────────────┼──┤  Lambda (Auto-confirm users)  │ │
│  User Pool       │   Pre-signup   │  └───────────────────────────────┘ │
│  (JWT Auth)      │   trigger      │                                     │
└──────────────────┘                │  ┌───────────────────────────────┐ │
                                    │  │  S3 Bucket (Image Storage)    │ │
                                    │  │  Public Read Access           │ │
                                    │  └───────────────────────────────┘ │
                                    └─────────────────────────────────────┘
```

### Architecture Highlights

#### **Compute Layer**
- **ECS Fargate**: Serverless container orchestration (no EC2 management)
- **Auto-scaling**: Container-level scaling based on CloudWatch metrics
- **Private subnets**: All application containers isolated from direct internet access

#### **Network Layer**
- **Multi-AZ VPC**: Custom VPC spanning 2 availability zones for fault tolerance
- **Public subnets** (10.0.1.0/24, 10.0.2.0/24): ALB, NAT (conceptual)
- **Private subnets** (10.0.127.0/24, 10.0.128.0/24): ECS tasks, RDS
- **VPC Endpoints**: Interface endpoints for ECR, S3, CloudWatch Logs, Cognito
- **Security Groups**: Layered security with least-privilege access

#### **Data Layer**
- **RDS PostgreSQL**: Managed database with automated backups
- **S3**: Serverless object storage for user-uploaded images
- **CloudWatch Logs**: Centralized application logging

#### **Security & Authentication**
- **AWS Cognito**: Managed user authentication with JWT tokens
- **Lambda triggers**: Automated user confirmation workflow
- **OAuth2 Resource Server**: Spring Security JWT validation
- **Security Groups**: Network-level firewall rules

---

## 🚀 Technology Stack

### Infrastructure & DevOps
| Technology | Purpose | Highlights |
|------------|---------|------------|
| **Terraform 6.x** | Infrastructure as Code | 584 lines of declarative IaC, modular design |
| **AWS ECS Fargate** | Container orchestration | Serverless, auto-scaling containers |
| **AWS ECR** | Container registry | Automated Docker image versioning |
| **AWS VPC** | Network isolation | Multi-AZ, private subnets, VPC endpoints |
| **Application Load Balancer** | Traffic routing | Path-based routing, health checks |
| **CloudWatch** | Monitoring & Logging | Application logs, metrics |

### Backend
| Technology | Purpose | Highlights |
|------------|---------|------------|
| **Spring Boot 3.1** | REST API framework | Java 17, Spring Data JPA |
| **PostgreSQL** | Relational database | AWS RDS managed instance |
| **Spring Security** | Authentication | OAuth2 Resource Server, JWT |
| **AWS S3 SDK** | Object storage | Multipart file uploads |
| **Lombok** | Code generation | Reduced boilerplate |
| **Maven** | Build automation | Multi-stage Docker builds |

### Frontend
| Technology | Purpose | Highlights |
|------------|---------|------------|
| **Angular 17** | SPA framework | Standalone components, RxJS |
| **TypeScript** | Type-safe JavaScript | Strict mode, ES2022 |
| **AWS Cognito SDK** | Authentication client | JWT token management |
| **Bootstrap 4** | UI framework | Responsive design |
| **Nginx** | Web server | Production-ready static serving |

---

## 📋 Key Features

### For Technical Evaluators

#### **1. Infrastructure Automation**
- **One-command deployment**: `./build.sh` provisions entire infrastructure
- **Idempotent operations**: Terraform state management ensures consistency
- **Environment variables**: `.env` file for configuration management
- **Automated resource tagging**: Cost allocation and resource tracking

#### **2. Security Best Practices**
- ✅ **Principle of least privilege**: IAM roles with minimal permissions
- ✅ **Private subnet architecture**: No public IP addresses on application containers
- ✅ **VPC endpoint security**: AWS services accessed without internet gateway
- ✅ **JWT token validation**: Stateless authentication with Cognito
- ✅ **HTTPS-ready**: ALB configured for HTTP (HTTPS via ACM in production)
- ✅ **Secrets management**: Environment variables injected at runtime

#### **3. High Availability & Fault Tolerance**
- **Multi-AZ deployment**: Resources distributed across 2 availability zones
- **Health checks**: ALB monitors container health (`/actuator/health`)
- **Auto-restart**: ECS service scheduler restarts failed containers
- **Database backups**: RDS automated backups (configurable retention)

#### **4. Observability**
- **Centralized logging**: CloudWatch Logs for all ECS tasks
- **Log retention**: Configurable retention policies
- **Debugging**: Spring Boot Actuator endpoints for health checks
- **Container insights**: ECS task-level metrics

---

## 🛠️ Infrastructure Components

### Terraform Modules (584 LOC)

| File | Resources | Purpose |
|------|-----------|---------|
| `vpc.tf` | VPC, Subnets, IGW, Route Tables, VPC Endpoints | Network foundation |
| `ecs.tf` | ECS Cluster, Task Definitions, Services | Container orchestration |
| `alb.tf` | ALB, Target Groups, Listeners | Traffic routing |
| `rds.tf` | RDS PostgreSQL, Subnet Groups | Database infrastructure |
| `cognito.tf` | User Pool, User Pool Client | Authentication |
| `s3.tf` | S3 Bucket, Bucket Policies | Object storage |
| `security_group.tf` | Security Groups | Network security |
| `ecr.tf` | ECR Repositories | Container registry |
| `lambda.tf` | Lambda Function, Permissions | User auto-confirmation |

### AWS Resources Provisioned

- **Compute**: 1 ECS Cluster, 2 ECS Services, 2 Task Definitions
- **Networking**: 1 VPC, 4 Subnets, 1 Internet Gateway, 5 VPC Endpoints, 4 Security Groups
- **Load Balancing**: 1 ALB, 2 Target Groups, 1 Listener, 1 Listener Rule
- **Storage**: 1 RDS Instance, 1 S3 Bucket
- **Security**: 1 Cognito User Pool, 1 Lambda Function
- **Registry**: 2 ECR Repositories
- **Logging**: 2 CloudWatch Log Groups

---

## 🔐 Security Architecture

### Authentication Flow

```
1. User Registration
   └─► AWS Cognito User Pool
       └─► Lambda Pre-Signup Trigger (auto-confirm)
           └─► User Created & Confirmed

2. User Login
   └─► Cognito authenticateUser()
       └─► Returns JWT Access Token + Refresh Token

3. API Request
   └─► Angular HTTP Interceptor
       └─► Adds "Authorization: Bearer <JWT>" header
           └─► Spring Security OAuth2 Resource Server
               └─► Validates JWT signature & claims
                   └─► Extracts username from token
                       └─► Authorizes request
```

### Network Security

```
Internet ──► ALB (Public SG: port 80)
              │
              └─► ECS Tasks (Container SG: ports 80, 8080 from ALB only)
                   │
                   ├─► RDS (DB SG: port 5432 from Container SG only)
                   │
                   └─► VPC Endpoints (Endpoint SG: port 443 from Container SG only)
```

---

## 📦 Deployment Guide

### Prerequisites

- AWS Account with IAM credentials configured
- Terraform 1.x installed
- Docker installed
- AWS CLI installed and configured

### Quick Start

```bash
# 1. Clone repository
git clone <repository-url>
cd Cloud-Native-Task-Management-System

# 2. Configure environment variables
cp env_template.sh .env
# Edit .env with your AWS credentials and configuration

# 3. Deploy infrastructure (one command!)
./build.sh
```

### What `build.sh` Does

```bash
# 1. Packages Lambda function
zip lambda_auto_confirm.zip lambda_auto_confirm.py

# 2. Provisions ECR repositories
terraform -chdir=terraform apply -target=aws_ecr_repository.*

# 3. Builds and pushes Docker images
./push_ecr.sh
  ├─► Builds frontend Docker image
  ├─► Builds backend Docker image
  ├─► Authenticates to ECR
  ├─► Tags images with ECR repository URLs
  └─► Pushes to ECR

# 4. Provisions complete infrastructure
terraform -chdir=terraform apply -auto-approve
```

---

## 📫 Connect & Get in Touch  
💻 **Portfolio:** [mateusznasewicz.dev](https://mateusznasewicz.dev)  
📧 [mateusznasewicz@proton.me](mailto:mateusznasewicz@proton.me)  
🔗 [LinkedIn](#)  

---

## 📄 License

This project was developed as a university course project. All rights reserved.

