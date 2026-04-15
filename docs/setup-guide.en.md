# NixOS Setup Guide (English)

This guide provides detailed instructions on how to set up NixOS using this starter configuration.

## 1. Preparation

Clone this repository to your local machine.

```bash
git clone https://github.com/xqtdk/nixos-seed.git nixos-config
cd nixos-config
```

## 2. Understanding the Directory Structure

The configuration is structured to support multiple hosts (machines).

- `hosts/`: Host-specific configurations (personal, etc.)
- `flake.nix`: The main entry point where hosts are defined.

## 3. Creating and Configuring a Host

It is recommended to copy `hosts/desktop` to create a new host configuration.

### Step A: Generate Hardware Configuration

`hosts/desktop/hardware-configuration.nix` is included as a placeholder.
Run the following on the target machine to overwrite it:

```bash
nixos-generate-config --show-hardware-config > hosts/<your-host-name>/hardware-configuration.nix
```

> [!WARNING]
> If you skip this step and run `nixos-rebuild switch`, the placeholder settings will be used and the system may not boot correctly on real hardware.

### Step B: Adjust Variables and Settings

**All primary customization is done in `variables.nix`.**
Review and edit the following settings:

- `username`, `userDisplayName`: Linux account name and display name
- `hostname`: Host name (must match the host definition name in `flake.nix`)
- `timeZone`: Time zone (e.g., `"Asia/Tokyo"`, `"UTC"`)
- `stateVersion`: NixOS release version (set at install time and do not change afterward)
- `enableGnome`, `enableKde`, `enableNiri`: Toggle switches for desktop environments
- `displayManager`: Login manager (`"tuigreet"` / `"gdm"` / `"sddm"` / `"regreet"` / `"lemurs"`)
  - Setting an invalid value will cause a build-time error
- `enableMozc`, `fcitx5Layout`: Input method settings

Build-specific local variables (e.g., `isVM` in `configuration.nix`) and user-specific settings (e.g., `gitEmail` in `home.nix`) should still be edited in their respective files.

### Step C: Host-Specific Settings

- `hosts/<your-host-name>/configuration.nix`: System-wide settings
- `hosts/<your-host-name>/home.nix`: User-specific settings (Home Manager)
- `hosts/<your-host-name>/variables.nix`: Shared flags used by both files above
- `hosts/<your-host-name>/modules/DE/`: Desktop environment-specific settings (e.g., `niri/default.nix`, `niri/config.kdl`)

## 4. Registering in `flake.nix`

Add your new host to the `outputs` section in `flake.nix`.

```nix
nixosConfigurations = {
  "your-host-name" = nixpkgs.lib.nixosSystem {
    # ...
  };
};
```

## 5. Applying the Configuration

```bash
sudo nixos-rebuild switch --flake .#your-host-name
```

## Troubleshooting

- **hardware-configuration.nix missing**: Ensure it is placed inside the correct host directory under `hosts/`.
- **Hostname mismatch**: The hostname in your configuration, the definition in `flake.nix`, and the name used in `nixos-rebuild switch --flake .#name` must all match.
