FROM bitnami/minideb:bullseye AS builder
ARG ref=master
WORKDIR /tmp/zsh-build
RUN install_packages curl \
                     ca-certificates \
                     autoconf \
                     make \
                     libtool \
                     libcap-dev \
                     libtinfo5 \
                     libncursesw5-dev \
                     libpcre3-dev \
                     libgdbm-dev \
                     yodl \
                     groff \
                     man-db \
                     texinfo \
                     patch
RUN curl -L https://api.github.com/repos/zsh-users/zsh/tarball/$ref | tar xz --strip=1

COPY *.patch ./
RUN for p in *.patch; do patch -s -p1 -r /dev/null -i $p || true; done

RUN ./Util/preconfig
RUN build_platform=x86_64; \
    case "$(dpkg --print-architecture)" in \
      arm64) \
        build_platform="aarch64" \
        ;; \
    esac; \
    ./configure --build=${build_platform}-unknown-linux-gnu \
                --prefix /usr \
                --enable-pcre \
                --enable-cap \
                --enable-multibyte \
                --with-term-lib='ncursesw tinfo' \
                --with-tcsetpgrp
RUN make
RUN make -C Etc all FAQ FAQ.html
RUN if test $ref = "master" ; then install_packages cm-super-minimal texlive-fonts-recommended texlive-latex-base texlive-latex-recommended ghostscript bsdmainutils ; fi
RUN if test $ref = "master" ; then make -C Doc everything ; fi
RUN make install DESTDIR=/tmp/zsh-install
RUN make install.info DESTDIR=/tmp/zsh-install || true
RUN yes '' | adduser --shell /bin/sh --home /tmp/zsh-build --disabled-login --disabled-password zshtest
RUN chown -R zshtest /tmp/zsh-build
RUN su - zshtest -c 'timeout 120 make test' || true

FROM bitnami/minideb:bullseye

# Image metadata
LABEL maintainer="Andrew Jo <andrew@verdigris.co>"

# Copy the compiled zsh binaries
COPY --from=builder /tmp/zsh-install /

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

# Use UTF-8 locale as default
ENV LANG=C.UTF-8

# Create a non-root user
ARG USERNAME=verdigrisian
RUN adduser ${USERNAME} && echo "${USERNAME}  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/${USERNAME}
USER ${USERNAME}

# Install oh-my-zsh for the default user
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Homebrew to keep the container environment similar to macOS local dev environment
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Configure shell
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# RUN sed -i 's/^ZSH_THEME=.*/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/g' /home/${USERNAME}/.zshrc
COPY dotfiles/.zshrc /home/${USERNAME}
# RUN echo "\n# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.\n[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> $HOME/.zshrc

WORKDIR /home/${USERNAME}

CMD ["/usr/bin/zsh","-l"]