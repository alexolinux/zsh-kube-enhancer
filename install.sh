#!/bin/bash

ZSHRC_FILE="${HOME}/.zshrc"
ZSH_PLUGINS=(
    kubectl
    kube-aliases
    kubectl-autocomplete
)

TEMP_FILE=$(mktemp)

# Function to check and print success or error
check_status() {
  if [ $? -eq 0 ]; then
    echo "Kubernetes Improvements applied in your environment."
  else
    echo "Error occurred. Kubernetes Improvements not applied."
    exit 1
  fi
}

check_reqs() {
  is_installed() {
    if command -v "$1" &> /dev/null; then
      echo "$1 is installed."
    else
      echo "$1 is not installed."
    fi
  }
  is_installed git
  is_installed zsh
}

check_status

#-- Main Script
clear && echo ">> --- Lets Kube! ---<<"

echo "Checking requirements..."
check_reqs

echo "Backing up ZSH User file configuration..."
cp -p "${ZSHRC_FILE}" "${ZSHRC_FILE}.save" 

# kube-aliases
echo "Applying kube-aliases..."
git clone https://github.com/Dbz/kube-aliases.git ~/.oh-my-zsh/plugins/kube-aliases
source ~/.oh-my-zsh/plugins/kube-aliases/kube-aliases.plugin.zsh >/dev/null 2>&1

check_status

# kubectl-autocomplete
echo "Applying kubectl-autocomplete..."
mkdir -p ~/.oh-my-zsh/plugins/kubectl-autocomplete/
kubectl completion zsh > ~/.oh-my-zsh/plugins/kubectl-autocomplete/kubectl-autocomplete.plugin.zsh >/dev/null 2>&1

check_status

echo "Appending new ZSH plugins..."

# Flag to indicate if we are within the plugins array
inside_plugins_array=false

# Read the zshfile line by line
while IFS= read -r line; do
    # Check for the line that contains 'plugins=('
    if [[ "$line" =~ ^plugins=\( ]]; then
        inside_plugins_array=true
        echo "$line" >> "$TEMP_FILE"  # Write the original line to the temp file
    elif [[ "$line" =~ ^\) && $inside_plugins_array == true ]]; then
        # Close the plugins array, but first add the new plugins
        for plugin in "${ZSH_PLUGINS[@]}"; do
            echo "    $plugin" >> "$TEMP_FILE"
        done
        echo "$line" >> "$TEMP_FILE"  # Write the closing parenthesis
        inside_plugins_array=false
    else
        echo "$line" >> "$TEMP_FILE"  # Write all other lines as they are
    fi
done < "$ZSHRC_FILE"

# Move the temporary file back to the original zshfile
mv "$TEMP_FILE" "$ZSHRC_FILE"

echo "Kubernetes AddOns applied successfully."
