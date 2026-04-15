# =============================================================================
# Hardware Configuration / ハードウェア設定 (プレースホルダー)
# =============================================================================
#
# ⚠️ このファイルはプレースホルダーです。実際に使用する前に必ず上書きしてください。
#
# 【上書き手順】
#   インストール対象マシン上で以下を実行してください:
#
#     nixos-generate-config --show-hardware-config > hosts/desktop/hardware-configuration.nix
#
#   または、インストールメディアからインストールした直後であれば:
#
#     cp /etc/nixos/hardware-configuration.nix hosts/desktop/hardware-configuration.nix
#
# 【このファイルをそのまま使用した場合】
#   ブート設定・カーネルモジュール・ファイルシステムが空の状態でビルドされるため、
#   実機では正常に起動しない可能性があります。
#
# =============================================================================

{ modulesPath, ... }:

{
  imports = [
    # 自動生成の基本モジュール
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # ★ 以下を nixos-generate-config の出力で上書きしてください ★
  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules          = [ ];
  boot.kernelModules                 = [ ];
  boot.extraModulePackages           = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos"; # 実際のパーティションに合わせて変更
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot"; # 実際のパーティションに合わせて変更
    fsType = "vfat";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
