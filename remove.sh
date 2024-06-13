#!/bin/bash

# Uninstall old versions
helm uninstall kibana -n elk || { echo "Failed to uninstall Kibana"; exit 1; }
helm uninstall elasticsearch -n elk || { echo "Failed to uninstall Elasticsearch"; exit 1; }
helm uninstall logstash -n elk || { echo "Failed to uninstall Logstash"; exit 1; }
helm uninstall filebeat -n elk || { echo "Failed to uninstall Filebeat"; exit 1; }
helm uninstall jenkins || { echo "Failed to uninstall Jenkins"; exit 1; }
helm uninstall prometheus -n monitoring || { echo "Failed to uninstall Prometheus"; exit 1; }

echo "Uninstallation completed successfully"