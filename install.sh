#!/bin/bash

ZSHRC_FILE="${HOME}/.zshrc"
ZSH_PLUGINS_DIR="${HOME}/.oh-my-zsh/plugins"
ZSH_PLUGINS=(
  kubectl
  kube-aliases
  kubectl-autocomplete
)

TEMP_FILE=$(mktemp)

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

# Atualizar plugins no .zshrc
echo "Atualizando plugins no .zshrc..."

tmpfile=$(mktemp)
inside_plugins_block=false
updated=false
existing_plugins=()

while IFS= read -r line; do
  if [[ "$line" =~ ^plugins=\( ]]; then
    inside_plugins_block=true
    echo "$line" >> "$tmpfile"
    continue
  fi

  if $inside_plugins_block; then
    if [[ "$line" =~ \) ]]; then
      inside_plugins_block=false
      for plugin in "${ZSH_PLUGINS[@]}"; do
        if [[ ! " ${existing_plugins[*]} " =~ " $plugin " ]]; then
          echo "  $plugin" >> "$tmpfile"
          updated=true
        fi
      done
      echo "$line" >> "$tmpfile"
    else
      plugin_name=$(echo "$line" | xargs)
      existing_plugins+=("$plugin_name")
      echo "$line" >> "$tmpfile"
    fi
    continue
  fi

  echo "$line" >> "$tmpfile"
done < "$ZSHRC_FILE"

# Se não encontrou bloco plugins=(...), adiciona ao final
if ! grep -q "^plugins=(" "$ZSHRC_FILE"; then
  echo -e "\nplugins=(" >> "$tmpfile"
  for plugin in "${ZSH_PLUGINS[@]}"; do
    echo "  $plugin" >> "$tmpfile"
  done
  echo ")" >> "$tmpfile"
  updated=true
fi

if $updated; then
  mv "$tmpfile" "$ZSHRC_FILE"
  echo "Plugins atualizados em $ZSHRC_FILE"
else
  rm "$tmpfile"
  echo "Nenhuma atualização necessária em plugins"
fi

echo "Kubernetes AddOns applied successfully."
echo "Please restart your terminal or run 'source ~/.zshrc' to apply changes."
