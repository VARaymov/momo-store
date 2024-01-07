#!/bin/bash

HELM_CHART_VERSION:"0.1.$CI_PIPELINE_ID"

echo "Current version: $HELM_CHART_VERSION"
sed -i "s/^version:.*/version: $HELM_CHART_VERSION/" Chart.yaml
helm package . -d ./helm-releases
