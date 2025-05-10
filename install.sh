#!/bin/bash

ZSHRC_FILE="${HOME}/.zshrc"
ZSH_PLUGINS_DIR="${HOME}/.oh-my-zsh/plugins"
ZSH_PLUGINS=(
    kubectl
    kube-aliases
    kubectl-autocomplete
)

check_status() {
  if [ $? -eq 0 ]; then
    echo "Kubernetes Improvements applied in your environment."
  else
    echo "Error occurred. Kubernetes Improvements not applied."
    exit 1
  fi
}

check_packages() {
  if ! command -v git >/dev/null 2>&1; then
    echo "git is not installed. Aborting."
    return 1
  fi

  if ! command -v zsh >/dev/null 2>&1; then
    echo "ZSH is not installed. Aborting."
    return 1
  fi

  echo "Both Git and Zsh are installed."
}

#-- Main Script
clear && echo ">> Lets Kube! <<"

echo "Checking for required packages..."
check_packages

echo "Backing up ZSH User file configuration..."
cp -p "${ZSHRC_FILE}" "${ZSHRC_FILE}.save"

# kube-aliases
echo "Applying kube-aliases..."

if [ ! -d "${ZSH_PLUGINS_DIR}/kube-aliases" ]; then
  echo "Creating kube-aliases directory..."
  mkdir -p "${ZSH_PLUGINS_DIR}/kube-aliases"
fi

git clone https://github.com/Dbz/kube-aliases.git "${ZSH_PLUGINS_DIR}/kube-aliases"
source "${ZSH_PLUGINS_DIR}/kube-aliases/kube-aliases.plugin.zsh" >/dev/null 2>&1

check_status

# kubectl-autocomplete
echo "Applying kubectl-autocomplete..."

if [ ! -d "${ZSH_PLUGINS_DIR}/kubectl-autocomplete" ]; then
  echo "Creating kubectl-autocomplete directory..."
  mkdir -p "${ZSH_PLUGINS_DIR}/kubectl-autocomplete"
fi

kubectl completion zsh > "${ZSH_PLUGINS_DIR}/kubectl-autocomplete/kubectl-autocomplete.plugin.zsh" >/dev/null 2>&1

check_status

echo "Appending new ZSH plugins..."

# Atualiza a linha de plugins corretamente
if grep -q "^plugins=(" "$ZSHRC_FILE"; then
    echo "Atualizando plugins no .zshrc..."

    current_line=$(grep "^plugins=" "$ZSHRC_FILE")
    current_plugins=($(echo "$current_line" | sed -E 's/plugins=\((.*)\)/\1/'))

    for new_plugin in "${ZSH_PLUGINS[@]}"; do
        if [[ ! " ${current_plugins[@]} " =~ " ${new_plugin} " ]]; then
            current_plugins+=("${new_plugin}")
        fi
    done

    new_line="plugins=(${current_plugins[*]})"
    sed -i "s/^plugins=(.*)/${new_line}/" "$ZSHRC_FILE"
else
    echo "Nenhuma linha de plugins encontrada. Adicionando ao final..."
    echo "" >> "$ZSHRC_FILE"
    echo "plugins=(${ZSH_PLUGINS[*]})" >> "$ZSHRC_FILE"
fi

echo "Kubernetes AddOns applied successfully."
echo "Please restart your terminal or run 'source ~/.zshrc' to apply changes."
echo "Enjoy your Kubernetes experience!"
