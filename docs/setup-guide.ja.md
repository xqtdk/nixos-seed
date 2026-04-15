# NixOS セットアップガイド (日本語)

このガイドでは、このリポジトリのスターター構成を使用して NixOS をセットアップする手順を詳細に説明します。

## 1. 準備

このリポジトリをローカルに配置します。

```bash
git clone https://github.com/xqtdk/nixos-seed.git nixos-config
cd nixos-config
```

## 2. ディレクトリ構造の理解

現在の構造は「マルチホスト」対応になっています。

- `hosts/`: ホストごとの個別の設定（個人用環境など）
- `flake.nix`: 全体のエントリーポイント。ここでホスト名を定義します。

## 3. ホストの作成と設定

基本的には `hosts/desktop` をコピーして新しいホストを作成することを推奨します。

### ステップ A: ハードウェア情報の生成

`hosts/desktop/hardware-configuration.nix` はプレースホルダーの状態で提供されています。
インストール先のマシンで以下を実行して上書きしてください。

```bash
nixos-generate-config --show-hardware-config > hosts/<your-host-name>/hardware-configuration.nix
```

> [!WARNING]
> 上書きしないまま `nixos-rebuild switch` を実行するとプレースホルダーの設定のままビルドされ、実機では正常起動しない場合があります。

### ステップ B: 変数と設定の調整

**全てのカスタマイズ項目は基本的に `variables.nix` で完結します。**以下の項目を確認・編集してください:

- `username`, `userDisplayName`: Linuxアカウント名と表示名
- `hostname`: ホスト名（`flake.nix` のホスト定義名と一致させる）
- `timeZone`: タイムゾーン（例: `"Asia/Tokyo"`, `"UTC"`)
- `stateVersion`: NixOSリリースバージョン（インストール時点の値を固定し、以後変更しない）
- `enableGnome`, `enableKde`, `enableNiri`: デスクトップ環境の有効化スイッチ
- `displayManager`: ログインマネージャー (`"tuigreet"` / `"gdm"` / `"sddm"` / `"regreet"` / `"lemurs"`)
  - 上記以外の値を設定するとビルド時にエラーで検出されます
- `enableMozc`, `fcitx5Layout`: 入力メソッドの設定

`configuration.nix` 内の `let` 句に定義したいビルド固有の変数（`isVM` 等）と、`home.nix` 内の `gitEmail` 等はそのまま各ファイルで編集してください。

### ステップ C: ホスト固有の設定

- `hosts/<your-host-name>/configuration.nix`: システム全体の設定
- `hosts/<your-host-name>/home.nix`: ユーザー個別の設定
- `hosts/<your-host-name>/variables.nix`: 両ファイルで共有するフラグ
- `hosts/<your-host-name>/modules/DE/`: デスクトップ環境別の設定（`niri/default.nix`, `niri/config.kdl` など）

## 4. `flake.nix` への登録

`flake.nix` の `outputs` セクションに新しいホストを追加します。

```nix
nixosConfigurations = {
  "your-host-name" = nixpkgs.lib.nixosSystem {
    # ...
  };
};
```

## 5. 設定の適用

```bash
sudo nixos-rebuild switch --flake .#your-host-name
```

## トラブルシューティング

- **hardware-configuration.nix がない**: `hosts` ディレクトリ配下の各ホスト用フォルダに配置されていることを確認してください。
- **ホスト名が一致しない**: 管理上のホスト名と `flake.nix` の定義名、および `nixos-rebuild` の `#` 以降の名前を一致させる必要があります。
