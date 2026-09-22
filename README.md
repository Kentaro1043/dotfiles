# dotfiles

based on [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)

## OpenCode・Grafana MCPの認証

`sops secrets/secrets.enc.yaml` で次のキーを設定してからHome Managerを反映する。
秘密値は実行時にsopsの復号先から読み込み、Nix storeには保存しない。

| キー | 内容 |
| --- | --- |
| `litellm-api-key` | homelabのLiteLLMで発行したVirtual Key（またはMaster Key） |
| `grafana-mcp-trap-authorization` | traPの2環境共通のBasic認証ヘッダー全体（`Basic <base64(username:password)>`） |
| `codex-grafana-work-url` | 既存のWork用Grafana URLを継続使用 |
| `codex-grafana-work-service-account-token` | 既存のWork用トークンを継続使用 |

traP用に追加した `grafana-trap-{sakura,conoha}-url` と
`grafana-trap-{sakura,conoha}-service-account-token` は不要。
`codex-grafana-trap-authorization` の値を `grafana-mcp-trap-authorization` に移行する。
LiteLLM側の各モデル提供元のAPIキーをdotfilesに追加する必要はない。

共有MCPはGrafana Cloud・Work・traP Sakura・traP ConoHa・Science Tokyoシラバスの5件。
OpenCodeとVSCodeはMCP Integrationから参照する。
Grafanaの定義は `home-manager/programs/grafana-mcp.nix` にまとめ、Workは
sopsのURL・トークンでローカルの `uvx mcp-grafana` を起動する。
traPは既存の `https://s-grafana-mcp.trap.jp/mcp`（Sakura）と
`https://grafana-mcp.trap.jp/mcp`（ConoHa）にBasic認証で接続する。
OpenCodeはsopsファイルからAuthorizationヘッダーを読み、Codexは起動時に同じ値を
`GRAFANA_MCP_TRAP_AUTHORIZATION` へ読み込む。
Codexは別のTOMLを引き続き書き込み可能な通常ファイルとして配置する。

Grafana CloudはOAuthを継続使用する。OpenCode側のログインは
`opencode mcp auth grafana-cloud` で行う（[OpenCode公式ドキュメント](https://opencode.ai/docs/mcp-servers/#authenticating)）。

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
