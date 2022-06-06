FROM bitnami/minideb:bullseye

# Build arguments
ARG ZSH_VERSION=5.9

# Image metadata
LABEL maintainer="Andrew Jo <andrew@verdigris.co>"

# Copy the compiled zsh binaries
COPY --from=verdigristech/zsh:$ZSH_VERSION /tmp/zsh-install /

# Install packages required to run zsh and dev tools.
RUN install_packages libcap2 \
                     libtinfo5 \
                     libncursesw5 \
                     libpcre3 \
                     libgdbm6 \
                     ca-certificates \
                     curl \
                     git \
                     sudo

# Set pipefail so the entire piped commands fail
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Use UTF-8 locale as default
ENV LANG=C.UTF-8

# Create a non-root user
ARG USERNAME=verdigrisian
RUN adduser ${USERNAME} && echo "${USERNAME}  ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/${USERNAME}
USER ${USERNAME}

# Install oh-my-zsh for the default user
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Homebrew to keep the container environment similar to macOS local dev environment
# RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Configure shell
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
COPY dotfiles/* /home/${USERNAME}

WORKDIR /home/${USERNAME}

CMD ["/usr/bin/zsh", "-l"]
