# dotfiles

based on [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)

## Tasks

[![xc compatible](https://xcfile.dev/badge.svg)](https://xcfile.dev)

### Update

home-managerの設定更新

```shell
home-manager switch --flake .#$USER@$(hostname | sed 's/\.local$//')
```

#### Plasmaのアプリケーションメニューを更新

Home ManagerでGUIアプリを追加したあと、Plasma 6のアプリケーションメニューに
表示されない場合は、Plasmaへ現在の検索パスを反映してキャッシュを再構築する。

```shell
dbus-update-activation-environment --systemd XDG_DATA_DIRS PATH && kbuildsycoca6 --noincremental && systemctl --user restart plasma-plasmashell.service
```

### Darwin

nix-darwinの設定更新

```shell
sudo darwin-rebuild switch --flake .#$USER@$(hostname | sed 's/\.local$//')
```

### Switch

NixOSの設定更新

```shell
sudo nixos-rebuild switch --impure --flake .#$USER@$(hostname | sed 's/\.local$//')
```
