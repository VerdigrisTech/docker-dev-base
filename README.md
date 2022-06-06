# docker-dev-base

Base image for setting up VS Code development environments.

## Overview

This image is based on [bitnami/minideb][minideb] image with [Zsh][zsh] as the
default shell. It also includes [Oh My Zsh][oh-my-zsh] framework with some
plugins pre-installed.

### Pre-installed userland tools

- `curl`
- `git`
- `lsd`
- `sudo`

### Pre-installed Zsh plugins

- [F-Sy-H][f-sy-h] (syntax highlighting)
- [zsh-autocomplete][zsh-autocomplete] (auto completion)
- [zsh-autosuggestions][zsh-autosuggestions] (auto suggestions)

---

Copyright © 2022 Verdigris Technologies, Inc. All rights reserved.

[minideb]: https://github.com/bitnami/minideb
[zsh]: https://www.zsh.org/
[oh-my-zsh]: https://ohmyz.sh/
[f-sy-h]: https://github.com/z-shell/F-Sy-H
[zsh-autocomplete]: https://github.com/marlonrichert/zsh-autocomplete
[zsh-autosuggestions]: https://github.com/zsh-users/zsh-autosuggestions
