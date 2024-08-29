# Local Kubernetes Cluster Setup

This guide provides instructions to set up a local Kubernetes cluster with monitoring, logging, and other essential facilities using the specified versions of Kubernetes and Helm.

## Services

- **Prometheus**: For monitoring Kubernetes clusters and services.
- **Grafana**: For visualizing metrics collected by Prometheus.
- **Node Exporter**: For monitoring node-level metrics, used in conjunction with Prometheus.
- **Elasticsearch**: For storing and searching logs.
- **Logstash**: For processing and transforming logs before sending them to Elasticsearch.
- **Kibana**: For visualizing logs stored in Elasticsearch.
- **Filebeat**: For shipping logs to Logstash or Elasticsearch.
- **Jenkins (Master and Agent)**: For automating CI/CD pipelines.
- **Nginx Ingress Controller**: For managing external access to services within the cluster.

## Prerequisites

- Kubernetes v1.29.2 or lower
- Helm v3.15.1
- Docker (for running a local Kubernetes cluster)
- kubectl

## Setup Using Setup Script

To simplify the installation process, a `setup.sh` script has been provided. This script will install and configure all the necessary components automatically.

### Steps to Run the Script

1. **Clone the Repository** (if applicable):

    ```bash
    git clone <repository-url>
    cd <repository-folder>
    ```

2. **Make the Script Executable**:

    ```bash
    chmod +x setup.sh
    ```

3. **Run the Setup Script**:

    ```bash
    ./setup.sh
    ```
