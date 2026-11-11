# Task Manager — DevOps and Kubernetes

## Overview

This project demonstrates the containerisation, deployment, monitoring, scaling, and performance testing of a Ruby on Rails Task Manager application.

The application uses MySQL for persistent data storage. Docker and Docker Compose are used for containerisation, while Kubernetes with Minikube manages the application and database workloads. The project also includes health checks, Horizontal Pod Autoscaling (HPA), resource monitoring, and load testing with k6.

## Technology Stack

- **Application:** Ruby on Rails, Ruby, Puma
- **Database:** MySQL
- **Containerisation:** Docker, Docker Compose
- **Orchestration:** Kubernetes, Minikube, kubectl
- **Performance testing:** k6
- **Configuration:** YAML, environment variables, Kubernetes Secrets

## Project Structure

```text
task_manager/
├── .github/
│   └── workflows/
│       └── ci.yml
├── app/                    # Rails application
├── bin/                    # Application scripts
├── config/                 # Rails configuration
├── db/                     # Database schema and migrations
├── k8/                     # Kubernetes manifests
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── mysql.yaml
│   └── service.yaml
├── lib/                    # Supporting application code
├── test/                   # Application tests
├── Dockerfile              # Application container image
├── compose.yaml            # Local multi-container setup
├── loadtest.js             # k6 load-test script
├── Gemfile
├── Gemfile.lock
└── README.md
```

## Architecture

The application runs in a Rails container and communicates with a MySQL database. Docker Compose defines the local container environment, while Kubernetes Deployments and Services manage the application and database in Minikube.

The Kubernetes application Deployment includes startup, readiness, and liveness probes targeting the `/up` endpoint. A Horizontal Pod Autoscaler monitors CPU utilisation and can adjust the number of application replicas.

## Running with Docker Compose

Build and start the application and database:

```bash
docker compose up --build -d
```

Check the running containers:

```bash
docker compose ps
```

View application logs:

```bash
docker compose logs -f app
```

Stop the services:

```bash
docker compose down
```

Database persistence depends on the volume configuration in `compose.yaml`.

## Kubernetes Deployment

The Kubernetes manifests are located in `k8/`.

The application and database workloads are deployed separately. The application is exposed through `task-manager-service`, and MySQL is available through the `mysql` Service.

Useful verification commands:

```bash
kubectl get deployments
kubectl get pods
kubectl get services
kubectl get hpa
```

To inspect autoscaling configuration and status:

```bash
kubectl describe hpa task-manager-hpa
```

To inspect resource usage:

```bash
kubectl top pods
```

The application health endpoint was tested through a local port-forward:

```bash
kubectl port-forward service/task-manager-service 3001:3000
```

In another terminal:

```powershell
Invoke-WebRequest http://localhost:3001/up -UseBasicParsing
```

**Observed result:** The health endpoint returned HTTP `200 OK`.

## Horizontal Pod Autoscaling

The HPA manifest configures CPU-based scaling with a target utilisation of 70% and a maximum of three application replicas.

During load testing, the application Deployment scaled from one replica to three replicas. Subsequent observations showed the replica count returning to a lower level as the workload subsided.

The HPA status reported CPU utilisation of `0% / 70%` in a later idle-state observation. Scaling decisions depend on measured CPU utilisation relative to the resource requests configured for the application containers.

## Performance Testing with k6

The `loadtest.js` script configures 500 virtual users for 60 seconds. It sends HTTP GET requests to the application and checks whether responses return HTTP 200.

The configured thresholds are:

- 95th-percentile response time below 2,000 ms
- Failed HTTP request rate below 5%

Run the test while the application is reachable at `http://localhost:3001/`:

```bash
k6 run loadtest.js
```

### Observed Load-Test Results

| Metric | Observed result |
|---|---:|
| Configured maximum virtual users | 500 |
| Test duration | Approximately 60 seconds |
| Total checks | 20,800 |
| Successful checks | 20,544 (98.76%) |
| Failed checks | 256 (1.23%) |
| Throughput | Approximately 338.74 requests/second |
| Average response time | 1.45 seconds |
| 95th-percentile response time | 1.58 seconds |
| Maximum response time | 4.38 seconds |

Both configured k6 thresholds passed in this recorded run:

- **Response time:** p95 of 1.58 seconds was below the 2-second target.
- **Failed request rate:** 1.23% was below the 5% target.

These results describe the recorded test run and should not be interpreted as a guarantee of performance under every workload. The test also reported a maximum response time of 4.38 seconds, showing that some individual requests took longer than the average.

## Resource Monitoring

Pod resource usage was captured using `kubectl top pods` during the load test.

| Workload | Observed CPU | Observed memory |
|---|---:|---:|
| Rails application pod | 558m | 141 Mi |
| MySQL pod | 7m | 464 Mi |

The Rails application pod showed substantially higher CPU usage than the MySQL pod in this snapshot. The MySQL pod showed higher memory usage.

These are point-in-time measurements, not averages across the entire test. A complete assessment of CPU or memory bottlenecks would require measurements collected throughout the load test. Puma thread configuration and application/database behaviour should also be considered when interpreting performance.

## Fault-Tolerance Test

A simulated application-container failure was triggered by sending `SIGTERM` to the main process of a running Rails pod.

The observed sequence was:

1. The selected pod temporarily became unready.
2. Its restart count increased from 0 to 1.
3. The same pod returned to `1/1 Running` and became ready again.

This demonstrates Kubernetes restarting the terminated container and restoring application-pod readiness. It does not, by itself, establish database-failure recovery or application availability during every type of failure.

## Validation Summary

The recorded checks demonstrate the following:

- The Kubernetes application and database workloads were running.
- The Rails health endpoint returned HTTP 200.
- The HPA responded to workload changes and reached three application replicas during load testing.
- The k6 run passed both configured performance thresholds.
- Resource usage was captured during testing.
- A simulated container termination resulted in a restart and recovery to a ready state.

## Limitations and Future Improvements

- Collect CPU and memory measurements throughout the full load test.
- Investigate the failed requests and occasional high response times.
- Validate scaling behaviour over repeated runs.
- Test recovery from additional failure scenarios, including database unavailability.
- Ensure that credentials are managed securely and that example configuration does not expose production secrets.
- Document the test environment, assumptions, and evidence alongside the final assignment report.

## Author

Rachana Ravikumar
