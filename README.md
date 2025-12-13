# NixOS Dotfiles

My NixOS system and home-manager configurations.

## Structure

```
.
├── flake.nix        # Flake
├── variables.nix    # Personal infos
├── system/          # System configs
│   ├── common.nix      # Shared system stuff      
│   └── ...
└── home/            # Home manager configs
    ├── common.nix      # Shared home stuffs
    └── ...
```

## Usage

### Rebuild system
```bash
sudo nixos-rebuild switch --flake .#thinkpad
sudo nixos-rebuild switch --flake .#server
```

Or use the convenience script:
```bash
sudo nixos-rebuild-flake switch
```

### Update flake inputs
```bash
nix flake update
```

### Format code
```bash
nix fmt
```

### Dry run
```bash
sudo nixos-rebuild dry-run --flake .#thinkpad
```

### Rollback
```bash
sudo nixos-rebuild switch --rollback
```

## Machines

- `thinkpad` - ARM ThinkPad T14s Gen6 (aarch64-linux)
- `server` - x86_64 server 
