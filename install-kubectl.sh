#!/bin/bash

# Script to install kubectl binary with curl on Linux
# List of kubectl releases: https://kubernetes.io/releases/
# For kubectl latest stable version: $(curl -L -s https://dl.k8s.io/release/stable.txt)
KUBE_VERSION="1.35.0"
KUBE_HOME="${HOME}/.local/bin"

# Functions
get_kubehome() {
  if [ ! -d "${KUBE_HOME}" ]; then
    echo "Creating directory: ${KUBE_HOME}"
    mkdir -p "${KUBE_HOME}"
  fi
}

get_arch() {
  ARCH=$(uname -m)

  case "${ARCH}" in
    x86_64)
      ARCH="amd64"
      ;;
    aarch64 | armv8*)
      ARCH="arm64"
      ;;
    armv7l | armv6l)
      ARCH="arm"
      ;;
    *)
      echo "Unsupported architecture: ${ARCH}"
      exit 1
      ;;
  esac
}


# Main Script
echo "Checking if ${KUBE_HOME} exists..."
get_kubehome

get_arch
echo "Architecture: ${ARCH}"

echo "Installing kubectl..."
KUBE_URL="https://dl.k8s.io/release/v${KUBE_VERSION}/bin/linux/${ARCH}/kubectl"
curl -sfL "${KUBE_URL}" -o "${KUBE_HOME}/kubectl"

if [ $? -eq 0 ]; then
  chmod 750 "${KUBE_HOME}/kubectl"
  echo "Kubectl installed successfully."

  export PATH="$PATH:$HOME/.local/bin" > /dev/null 2>&1
  kubectl version --client

else
  echo "Failed to install kubectl. Check the Kubernetes URL Link."
  exit 1
fi
