# 🧩 zsh-kube-enhancer

----------------------

Enhance your ZSH environment for working with Kubernetes.

## ✨ Features

- Installs and configures:
  - `kube-aliases` for faster kubectl commands
  - `kubectl-autocomplete` for shell completion
  - Adds relevant plugins to your `.zshrc`

## 📡 Requirements

- [ZSH Shell](https://www.zsh.org/)
- [OhMyZsh!](https://ohmyz.sh/)

✴️ *If you need a ZSH Environment, check this repository >> **[zsh-empowered-productivity](https://github.com/alexolinux/zsh-empowered-productivity)***

## 📦 Installation

```shell
git clone https://github.com/alexolinux/zsh-kube-enhancer.git
cd zsh-kube-enhancer
./install.sh
```

## 📥 Additional: `kubectl` installation

If you don't have `kubectl` installed yet, this repository includes a script to install `kubectl`:

```shell
./install-kubectl.sh
```

## 🚀 Recommended Tools

For the best Kubernetes terminal experience, I strongly recommend installing the following tools:

### 🔍 [fzf](https://github.com/junegunn/fzf)

A powerful fuzzy finder used in combination with `kubectx` and `kubens`:

```shell
# Rocky/Alma/CentOS Linux (RHEL Based)
sudo dnf install fzf

# Debian/Ubuntu
sudo apt install fzf

# Arch
sudo pacman -S fzf

# MacOS
brew install fzf
```

### [kubectx](https://github.com/ahmetb/kubectx) && [kubens](https://github.com/ahmetb/kubectx)

#### Clone the repo

```shell
# ~/.kubectx or $HOME/.local/bin/.kubectx
git clone https://github.com/ahmetb/kubectx ~/.kubectx
```

#### Add to your shell PATH (For kubectx & kubens)

```shell
echo 'export PATH=$PATH:$HOME/.kubectx' >> ~/.zshrc
source ~/.zshrc
```

## References

* [kubectl](https://kubernetes.io/docs/reference/kubectl/)
* [OhMyZsh! Plugins](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins)
* [kubectl-aliases](https://github.com/ahmetb/kubectl-aliases)
* [kubectx](https://github.com/ahmetb/kubectx)
* [fzf](https://github.com/junegunn/fzf)

## Author: Alex Mendes

<https://www.linkedin.com/in/mendesalex>
