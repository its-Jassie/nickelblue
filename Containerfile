FROM quay.io/fedora/fedora-silverblue:39 as nickelblue

ADD include /

# add rpm-fusion and copr repos
RUN rpm-ostree install \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
        
# remove unwanted packages and non-free codecs
RUN rpm-ostree override remove \
	yelp \
	gnome-tour \
	gnome-terminal \
	gnome-terminal-nautilus \
	gnome-software-rpm-ostree \
        gnome-software \
	gnome-system-monitor \
	gnome-classic-session \
	toolbox \
	gnome-shell-extension-background-logo \
        mesa-va-drivers \
    	libavcodec-free \
        libavfilter-free \
        libavformat-free \
        libavutil-free \
        libpostproc-free \
        libswresample-free \
        libswscale-free

# add wanted packages
RUN rpm-ostree install \
        adw-gtk3-theme \
        distrobox \
        fish \
        fzf \
        gnome-boxes \
        gnome-console \
        gnome-tweaks \
        just \
        libratbag-ratbagd \
        neovim \
        openssl \
        python3-pip \
        sshfs \
        sushi \
        xwaylandvideobridge \
        zsh

# add non-free codecs
RUN rpm-ostree install \
        alsa-firmware \
	ffmpeg \
	ffmpeg-libs \
        ffmpegthumbnailer \
        heif-pixbuf-loader \
        libva-utils \
        mesa-va-drivers-freeworld \
        pipewire-codec-aptx

# add pip packages
RUN pip install --prefix=/usr \
        yafti \
        gnome-extensions-cli

# configure and commit
RUN rm -rf /tmp/* /var/*  /usr/share/applications/fish.desktop /usr/share/applications/nvim.desktop \
    systemctl enable com.system76.Scheduler.service && \
    systemctl --global enable copy-justfile.service && \ 
    ostree container commit && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /var/tmp