# dotfiles

based on [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)

## OpenCode・Grafana MCPの認証

`sops secrets/secrets.enc.yaml` で次のキーを設定してからHome Managerを反映する。
秘密値は実行時にsopsの復号先から読み込み、Nix storeには保存しない。

| キー | 内容 |
| --- | --- |
| `litellm-api-key` | homelabのLiteLLMで発行したVirtual Key（またはMaster Key） |
| `joplin-api-token` | Joplinの `api.token`。共通のローカルMCP接続に使用 |

LiteLLM側の各モデル提供元のAPIキーをdotfilesに追加する必要はない。

共有MCPはGrafana Cloud・Work・traP Sakura・Joplin・Science Tokyoシラバスの5件。
OpenCodeとVSCodeはMCP Integrationから参照する。
CodexのMCP設定も `programs.mcp.servers` から生成し、通常ファイルとして配置する。

Grafanaの定義・認証・起動コマンドは `home-manager/programs/mcp.nix` に集約する。
Home Manager反映後、stdio MCPを起動できるハーネスでは次のコマンドを登録できる。
GUIからPATHを参照できない場合は `~/.nix-profile/bin/` 以下の絶対パスを指定する。

| コマンド | 接続先 |
| --- | --- |
| `mcp-grafana-work` | LiteLLM経由でWorkのGrafana MCPへ接続 |
| `mcp-grafana-trap-sakura` | LiteLLM経由でtraPのGrafana MCPへ接続 |
| `mcp-grafana-cloud` | LiteLLM経由でGrafana Cloud MCPへ接続 |
| `mcp-joplin` | ローカルJoplinのMCPへ接続 |

GrafanaとJoplinには [mcp-remote](https://github.com/punkpeye/mcp-remote) のstdioブリッジを使う。
初回起動時にnpmパッケージを取得する。Grafanaの認証にはLiteLLMのAPIキーを使う。
Joplinの定義は `home-manager/programs/mcp-joplin.nix` に置く。
トークンは起動時にsopsの復号先から読み、ハーネスの設定ファイルには埋め込まない。
Joplin本体で `http://127.0.0.1:41184/mcp` が利用可能になっている必要がある。

## 仕事用アプリの起動

Home Manager反映後、zshで `codex-work-app` を実行する。
macOSでは `/Applications/ChatGPT.app`、Linuxでは `chatgpt` コマンドを起動する。
仕事用の設定・認証には `~/.codex-work`、アプリのプロファイルには
`~/.codex-work/desktop-profile` を使う。

## Codex Remote（NixOS）

LinuxではHome Managerが `codex-app-server.service` をユーザーサービスとして管理する。
ログイン時に起動し、Home ManagerのCodexパッケージ・`~/.codex` の設定と認証を共有して、
homelabと同じ `app-server --remote-control --listen unix://` で起動する。
Home Managerを反映し、`codex login` でChatGPTアカウントにログインしてから再起動する。

```shell
home-manager switch --flake .#kentaro@kentaro-desktop
codex login
systemctl --user restart codex-app-server
systemctl --user status codex-app-server
```

Remoteとのペアリングコードは `codex remote-control pair` で取得する。
このマシン上のCLIから常駐サーバーを使う場合は `codex --remote unix://` を実行する。
ログは `journalctl --user -u codex-app-server -f` で確認できる。
認証を変更した場合は `systemctl --user restart codex-app-server` で再起動する。

以前のNixOSシステムサービスを反映済みの場合は、先に
`sudo systemctl stop codex-app-server` を実行し、NixOSを再反映して削除してから
Home Managerを反映する。

## Tasks

[![xc compatible](https://xcfile.dev/badge.svg)](https://xcfile.dev)

### Update

home-managerの設定更新

```shell
home-manager switch --flake .#$USER@$(hostname | sed 's/\.local$//')
```

#### Plasmaのアプリケーションメニューを更新

LinuxではHome Managerのactivation時に、Plasmaへ現在の検索パスを反映し、
Plasma 6のアプリケーションメニューのキャッシュを自動で再構築する。

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
