# AGENTS.md

This document provides essential information for AI coding agents working with this Nix-based dotfiles repository. It includes build/lint/test commands, code style guidelines, and important conventions.

## Repository Overview

This is a Nix-based dotfiles repository managing configurations for:
- Home Manager (user-level configurations)
- Nix-Darwin (macOS system configurations)
- NixOS (Linux system configurations)

## Build/Lint/Test Commands

### Build Commands

1. **Home Manager Configuration Update**
   ```bash
   home-manager switch --flake .#$USER@$(hostname | sed 's/\.local$//')
   ```

2. **Nix-Darwin Configuration Update** (macOS)
   ```bash
   sudo darwin-rebuild switch --flake .#$USER@$(hostname | sed 's/\.local$//')
   ```

3. **NixOS Configuration Update** (Linux)
   ```bash
   sudo nixos-rebuild switch --impure --flake .#$USER@$(hostname | sed 's/\.local$//')
   ```

### Linting Commands

1. **Nix Formatting** (using alejandra)
   ```bash
   nix fmt
   ```
   or directly:
   ```bash
   alejandra .
   ```

2. **Python Linting** (using ruff)
   ```bash
   ruff check .
   ```

3. **Shell Script Checking**
   ```bash
   shellcheck <script.sh>
   ```

### Testing Commands

This repository contains configuration files rather than software with traditional unit tests. However, you can:

1. **Validate Nix expressions**
   ```bash
   nix flake check
   ```

2. **Test individual module evaluation**
   ```bash
   nix instantiate .#homeConfigurations."$USER@$(hostname | sed 's/\.local$//')"
   ```

### Running Single Tests

For repositories with actual tests, you would typically:

1. **Run all tests**
   ```bash
   nix flake check
   ```

2. **Run specific test suites** (if applicable)
   ```bash
   nix build .#checks."<system>"."<test-name>"
   ```

3. **Check flake outputs**
   ```bash
   nix flake show
   ```

## Code Style Guidelines

### Nix Code Style

1. **Formatting**
   - Use `alejandra` for consistent formatting
   - Line width: 80-100 characters preferred
   - Indentation: 2 spaces (standard Nix convention)

2. **Imports and Structure**
   - Organize imports alphabetically when reasonable
   - Group related settings in separate modules
   - Use relative paths for local imports
   - Prefer `import` for local files over direct paths

3. **Naming Conventions**
   - Use camelCase for variable names
   - Use descriptive names for modules and configurations
   - Follow existing patterns in the codebase
   - Module files should be named descriptively (e.g., `git.nix`, `vscode.nix`)

4. **Types and Expressions**
   - Use explicit type declarations where beneficial
   - Prefer `let ... in` expressions for intermediate values
   - Use `with` statements sparingly and only in scopes (like package lists)
   - Leverage lazy evaluation appropriately

5. **Function Definitions**
   - Use pattern matching `{config, pkgs, ...}:` for module functions
   - Include ellipsis (`...`) to allow for future parameter additions
   - Document complex functions with comments

### Error Handling

1. **Nix Expressions**
   - Use assertions for validating assumptions:
     ```nix
     assert config.programs.git.enable;
     ```
   - Handle optional features with conditional expressions
   - Use `lib.mkIf` for conditional configuration sections

2. **Validation**
   - Test configuration changes with `nix flake check`
   - Validate individual modules with `nix eval`
   - Check for unused or undefined variables

### Version Control

1. **Commit Messages**
   - Use present tense ("Add feature" not "Added feature")
   - Keep subject line under 50 characters
   - Use imperative mood in subject line
   - Wrap body at 72 characters

2. **Branch Naming**
   - Use descriptive names like `feature/add-new-package` or `fix/missing-dependency`
   - Prefix with category: `feature/`, `fix/`, `docs/`, `refactor/`, etc.

### Specific Tools Configuration

1. **Ruff (Python)**
   - Configuration in `home-manager/programs/ruff.nix`
   - Line length: 88 characters
   - Target version: Python 3.9+
   - All warnings fixable by default

2. **Git**
   - Default branch: main
   - Rebase strategy: merge (rebase disabled)
   - Email: 71170923+Kentaro1043@users.noreply.github.com
   - Name: Kentaro1043

3. **VSCode/Codium**
   - Theme: Dracula
   - Formatter: Alejandra for Nix
   - Language server: nixd
   - Extensions: Continue, Roo, Qwen, etc.

## Development Environment

### Recommended Tools

1. **Editor Setup**
   - VSCode/Codium with Nix IDE extensions
   - Language server: nixd
   - Formatter: alejandra

2. **Terminal**
   - Default shell: zsh
   - Preferred font: JetBrainsMono Nerd Font

3. **Development Workflow**
   - Validate changes with `nix flake check` before committing
   - Test configurations locally with appropriate `*-rebuild` commands
   - Review diff output to ensure expected changes

### Debugging Tips

1. **Inspect Flake Outputs**
   ```bash
   nix flake show
   ```

2. **Evaluate Specific Attributes**
   ```bash
   nix eval .#homeConfigurations."$USER@$(hostname)"
   ```

3. **Build Specific Packages**
   ```bash
   nix build .#packages."<system>"."<package-name>"
   ```

## Security Considerations

1. **Unfree Software Policy**
   - Free software is preferred
   - Explicit allowlist in `home-manager/home.nix` for exceptions
   - Regular review of unfree packages

2. **Secrets Management**
   - Uses sops-nix for secret encryption
   - Secrets stored separately from configuration
   - Never commit plaintext secrets

## Contributing Guidelines

1. **Code Changes**
   - Follow existing code style
   - Test configurations before submitting changes
   - Document significant changes in commit messages

2. **Adding New Features**
   - Create modular, reusable components
   - Provide sensible defaults
   - Include appropriate comments for complex configurations

3. **Updating Dependencies**
   - Update flake inputs periodically
   - Test changes thoroughly
   - Maintain compatibility across platforms

---

This guide should help AI agents effectively navigate and contribute to this Nix-based dotfiles repository while maintaining consistency with established practices and conventions.