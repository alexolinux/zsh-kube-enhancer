#!/bin/bash

# Script to install kubectl binary with curl on Linux
# List of kubectl releases: https://kubernetes.io/releases/
# For kubectl latest stable version: $(curl -L -s https://dl.k8s.io/release/stable.txt)
KUBE_VERSION="1.32.0"

# Define installation directory
# Note: If you do not have root access on the target system, you can still install kubectl to the '~/.local/bin' directory.
KUBE_HOME="/usr/local/bin"

get_kubectl() {
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

    curl -LO "https://dl.k8s.io/release/v${KUBE_VERSION}/bin/linux/${ARCH}/kubectl"
}

echo "Detected architecture: ${ARCH}"

echo "Installing kubectl..."
if [ "${KUBE_HOME}" = "/usr/local/bin" ]; then
  get_kubectl

  if [ "$?" -eq 0 ]; then
    sudo install -o root -g root -m 0755 kubectl "${KUBE_HOME}/kubectl" || exit 1
    echo "kubectl has been installed successfully in ${KUBE_HOME} !"
    rm ./kubectl && kubectl version --client
  fi
elif [ "${KUBE_HOME}" = "${HOME}/.local/bin" ]; then
  if [ ! -d "${KUBE_HOME}" ]; then
    mkdir -p "${KUBE_HOME}" || exit 1
    echo "${KUBE_HOME} created."
  fi

  # Check if kubectl already exists in the directory
  if [ -x "${KUBE_HOME}/kubectl" ]; then
    echo "kubectl already exists in ${KUBE_HOME}. Skipping installation."
    exit 0
  fi

  # Add directory to PATH if not already included
  if [[ ":${PATH}:" != *":${KUBE_HOME}:"* ]]; then
    export PATH="${KUBE_HOME}:${PATH}"
    echo "Added ${KUBE_HOME} to PATH."
  fi

  echo "Installing kubectl in ${USER} local bin..."
  get_kubectl

  if [ "$?" -eq 0 ]; then
    chmod +x kubectl || exit 1
    mv kubectl "${KUBE_HOME}/kubectl" || exit 1
    echo "kubectl has been installed successfully in ${KUBE_HOME} !"
    kubectl version --client
  fi
fi

echo "kubectl installation completed."
