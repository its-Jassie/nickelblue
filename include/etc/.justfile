default:
    @just --unstable --list

bios:
    systemctl reboot --firmware-setup

clean:
    podman system prune -a
    flatpak uninstall --unused
    rpm-ostree cleanup -bm

enable-pstate:
    rpm-ostree kargs --append-if-missing=amd_pstate=guided

adwaita-firefox:
    #!/usr/bin/env bash
    cd ~
    git clone https://github.com/rafaelmardojai/firefox-gnome-theme.git
    cd firefox-gnome-theme
    ./scripts/auto-install.sh
    cd ~
    rm -rf firefox-gnome-theme    

adwaita-gtk3:
    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    flatpak install --user org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark --assumeyes
    flatpak override --user --filesystem=xdg-config/gtk-3.0:ro --filesystem=xdg-config/gtkrc-2.0:ro --filesystem=xdg-config/gtk-4.0:ro --filesystem=xdg-config/gtkrc:ro


gnome-settings:
    dconf load / < /etc/nickelblue.dconf
    gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
    gnome-extensions-cli install app-hider@lynith.dev
    gnome-extensions-cli install appindicatorsupport@rgcjonas.gmail.com
    gnome-extensions-cli install blur-my-shell@aunetx
    gnome-extensions-cli install forge@jmmaranan.com

install-steam:
    #!/usr/bin/env bash
    distrobox-create --name bazzite-arch --image ghcr.io/ublue-os/bazzite-arch-gnome --unshare-netns --nvidia --yes
    distrobox-enter -n bazzite-arch -- 'bash -c "sudo locale-gen && distrobox-export --app steam"'