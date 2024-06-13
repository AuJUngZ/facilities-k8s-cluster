#!/bin/bash

# Check and create namespaces if they don't exist
if ! kubectl get namespace elk >/dev/null 2>&1; then
    echo "Creating 'elk' namespace..."
    kubectl create namespace elk || { echo "Failed to create 'elk' namespace"; exit 1; }
else
    echo "Namespace 'elk' already exists"
fi

if ! kubectl get namespace monitoring >/dev/null 2>&1; then
    echo "Creating 'monitoring' namespace..."
    kubectl create namespace monitoring || { echo "Failed to create 'monitoring' namespace"; exit 1; }
else
    echo "Namespace 'monitoring' already exists"
fi

# Install Elasticsearch, Logstash, Filebeat, and Jenkins
echo "Installing Elasticsearch, Logstash, Filebeat, and Jenkins..."
helm install elasticsearch ./elasticsearch -n elk || { echo "Failed to install Elasticsearch"; exit 1; }
helm install logstash ./logstash -n elk || { echo "Failed to install Logstash"; exit 1; }
helm install filebeat ./filebeat -n elk || { echo "Failed to install Filebeat"; exit 1; }
helm install jenkins ./jenkins -n elk || { echo "Failed to install Jenkins"; exit 1; }

# Install Prometheus and related components
echo "Installing Prometheus stack..."
helm upgrade --install prometheus ./kube-prometheus-stack \
    --namespace monitoring --create-namespace \
    --set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false \
    --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
    --set prometheus-node-exporter.hostRootFsMount.enabled=false \
    --set prometheus-node-exporter.hostRootFsMount.mountPropagation='HostToContainer' || { echo "Failed to install Prometheus"; exit 1; }

# Wait for Elasticsearch to be ready, then install Kibana
echo "Waiting for Elasticsearch to be ready..."
if ! kubectl wait --for=condition=ready pod -l app=elasticsearch-master -n elk --timeout=300s; then
    echo "Elasticsearch did not become ready within the timeout period"
    exit 1
fi
echo "Installing Kibana..."
helm install kibana ./kibana -n elk || { echo "Failed to install Kibana"; exit 1; }

# Install Ingress Nginx if not installed
if ! kubectl get namespace ingress-nginx >/dev/null 2>&1; then
    echo "Installing Ingress Nginx..."
    helm upgrade --install ingress-nginx ingress-nginx \
        --repo https://kubernetes.github.io/ingress-nginx \
        --namespace ingress-nginx --create-namespace || { echo "Failed to install Ingress Nginx"; exit 1; }
else
    echo "Ingress Nginx is already installed"
fi

echo "Installation completed successfully"