# dotfiles

based on [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)

## OpenCode・Grafana MCPの認証

`sops secrets/secrets.enc.yaml` で次のキーを設定してからHome Managerを反映する。
秘密値は実行時にsopsの復号先から読み込み、Nix storeには保存しない。

| キー | 内容 |
| --- | --- |
| `litellm-api-key` | homelabのLiteLLMで発行したVirtual Key（またはMaster Key） |
| `grafana-mcp-trap-authorization` | traPの2環境共通のBasic認証ヘッダー全体（`Basic <base64(username:password)>`） |
| `grafana-mcp-work-url` | Work用Grafana本体のURL |
| `grafana-mcp-work-service-account-token` | Work用Grafanaサービスアカウントトークン（`Bearer `なし） |
| `joplin-api-token` | Joplinの `api.token`。共通のローカルMCP接続に使用 |

traP用に追加した `grafana-trap-{sakura,conoha}-url` と
`grafana-trap-{sakura,conoha}-service-account-token` は不要。
`codex-grafana-trap-authorization` の値を `grafana-mcp-trap-authorization` に移行する。
Work用も `codex-grafana-work-url` と `codex-grafana-work-service-account-token` の値を、
それぞれ上記の `grafana-mcp-work-*` キーに移行する。
LiteLLM側の各モデル提供元のAPIキーをdotfilesに追加する必要はない。

共有MCPはGrafana Cloud・Work・traP Sakura・traP ConoHa・Joplin・Science Tokyoシラバスの6件。
OpenCodeとVSCodeはMCP Integrationから参照する。
CodexのMCP設定も `programs.mcp.servers` から生成し、通常ファイルとして配置する。

Grafanaの定義・認証・起動コマンドは `home-manager/programs/mcp-grafana.nix` に集約する。
Home Manager反映後、stdio MCPを起動できるハーネスでは次のコマンドを登録できる。
GUIからPATHを参照できない場合は `~/.nix-profile/bin/` 以下の絶対パスを指定する。

| コマンド | 接続先 |
| --- | --- |
| `mcp-grafana-work` | sopsのURL・サービスアカウントトークンで `uvx mcp-grafana` を起動 |
| `mcp-grafana-trap-sakura` | Sakuraの既存MCPへBasic認証で接続 |
| `mcp-grafana-trap-conoha` | ConoHaの既存MCPへBasic認証で接続 |
| `mcp-grafana-cloud` | Grafana CloudへOAuthで接続 |
| `mcp-joplin` | ローカルJoplinのMCPへ接続 |

リモートGrafanaとJoplinには [mcp-remote](https://github.com/punkpeye/mcp-remote) のstdioブリッジを使う。
初回起動時にnpmパッケージを取得し、CloudはブラウザでOAuth認証する。
認証キャッシュは `~/.mcp-auth` に保存され、Codexの既存OAuth認証とは別にログインが必要。
Joplinも初回起動時にnpmパッケージを取得する。Workはuvでパッケージを取得する。
Joplinの定義は `home-manager/programs/mcp-joplin.nix` に置く。
トークンは起動時にsopsの復号先から読み、ハーネスの設定ファイルには埋め込まない。
Joplin本体で `http://127.0.0.1:41184/mcp` が利用可能になっている必要がある。

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
