# Task Manager — Rails CRUD Application

## Overview

This project is a Ruby on Rails rewrite of the original Task Manager application. It supports creating, viewing, searching, editing, and deleting tasks using a MySQL database.

The project explores containerisation with Docker, service orchestration with Docker Compose, deployment on Kubernetes using Minikube, application health monitoring, horizontal pod autoscaling, and performance testing with k6.

## Technologies

- Ruby on Rails
- Ruby
- MySQL
- Puma
- Docker
- Docker Compose
- Kubernetes
- Minikube
- kubectl
- k6

## Features

- Create, view, search, edit, and delete tasks
- MySQL database integration
- Application health-check endpoint at `/up`
- Docker image and multi-container configuration
- Kubernetes Deployment and Service
- Readiness, liveness, and startup probes
- Horizontal Pod Autoscaler configuration
- k6-based load testing

## Project Structure

- `app/` — Rails application code
- `bin/` — Application scripts
- `config/` — Application and database configuration
- `db/` — Database schema, migrations, and seeds
- `k8/` — Kubernetes configuration files
- `test/` — Application tests
- `Dockerfile` — Application image definition
- `compose.yaml` — Docker Compose configuration
- `loadtest.js` — k6 performance test script
- `README.md` — Project documentation

## Deployment and Validation

The project contains a Dockerfile and a Compose configuration for the Rails application and MySQL database.

The Kubernetes configuration includes an application Deployment, a Service, MySQL resources, and an HPA configuration. The application health endpoint `/up` is used by the configured health probes.

Successful operation should be demonstrated using actual Docker and Minikube verification results in the assignment report.

## Performance Testing

The k6 test script specifies 500 virtual users for 60 seconds. The test targets the application through the local port-forwarded address.

### Observed results

| Metric | Result |
|---|---:|
| Virtual users configured | 500 |
| Test duration | 60 seconds |
| Total requests | Approximately 19,700 |
| Throughput | Approximately 321 requests/second |
| Average response time | 1.53 seconds |
| 95th percentile response time | 2.46 seconds |
| Failed request rate | 1.83% |

### Analysis

The test generated approximately 19,700 requests, with an average response time of 1.53 seconds and a failed request rate of 1.83%.

The 95th percentile response time was 2.46 seconds, exceeding the configured target of less than 2 seconds. Therefore, the latency threshold was not met, although the configured error-rate threshold of less than 5% was met.

These results provide a baseline for investigating response-time performance under concurrent load.

### Resource Usage and Autoscaling

CPU and memory usage should be recorded for each application pod and the MySQL pod while the load test is running. The results should be used to discuss whether the system appears CPU-bound or memory-bound and how the Puma thread configuration relates to performance.

The HPA configuration targets average CPU utilisation of 70%, with a minimum of 1 and maximum of 3 replicas. Actual scaling behaviour should be described using the observed replica counts and HPA metrics.

### Fault Tolerance

Document the simulated pod failure, the Kubernetes recovery behaviour, and the pod restart counts before and after the test. Include the actual verification output in the assignment report.

## Limitations and Future Improvements

- Investigate why the 95th percentile response time exceeded the target.
- Collect CPU and memory metrics during the load test.
- Evaluate the HPA behaviour under sustained load.
- Document the observed recovery behaviour after a simulated pod failure.
- Record assumptions and configuration decisions in the assignment report.

## Author

Rachana Ravikumar