---
allowed-tools: [Read, Write, Bash]
description: Install claudesidian shell command to launch Claude Code from anywhere
argument-hint: (optional shell: bash/zsh/fish)
---

# Install Claudesidian Command

Creates a shell alias/function that allows you to run `claudesidian` from
anywhere to open your vault in Claude Code.

## Task

Install a shell command that:

1. Changes to your claudesidian vault directory
2. Launches Claude Code
3. Works from any directory in your terminal

Similar to having a quick launcher for your vault.

## Process

### 1. **Detect Current Setup**

- Check which shell the user is using (bash/zsh/fish)
- Find the current working directory (vault path)
- Determine the appropriate config file

### 2. **Create the Command**

The command will be an alias that:

- Changes to the vault directory: `cd /path/to/your/vault`
- Tries to resume existing session: `claude --resume 2>/dev/null`
- Falls back to new session if no existing one: `|| claude`
- All in one command with properly escaped path:
  `(cd "/path/to/vault" && (claude --resume 2>/dev/null || claude))`

**Important:** The path must be properly escaped to handle spaces and special
characters.

This automatically enters resume mode if there's an existing session, or starts
a new one if not.

### 3. **Install to Shell Config**

Add the alias to the appropriate config file:

- **Bash**: `~/.bashrc` or `~/.bash_profile`
- **Zsh**: `~/.zshrc`
- **Fish**: `~/.config/fish/config.fish`

### 4. **Verify Installation**

- Show the added line
- Remind user to reload their shell or source the config
- Provide test command

## Shell Detection

Detects the user's default shell, with support for command-line override:

```bash
# Check if shell specified as argument (/install-claudesidian-command zsh)
if [ -n "$1" ]; then
  # User provided shell type as argument
  SHELL_TYPE="$1"
else
  # Auto-detect from $SHELL (user's default shell, not current shell)
  SHELL_TYPE=$(basename "$SHELL")
fi

# Validate shell type and set appropriate config file
case "$SHELL_TYPE" in
  zsh)
    CONFIG_FILE="$HOME/.zshrc"
    ;;
  bash)
    # Prefer .bashrc on Linux, .bash_profile on macOS
    if [ -f "$HOME/.bashrc" ]; then
      CONFIG_FILE="$HOME/.bashrc"
    else
      CONFIG_FILE="$HOME/.bash_profile"
    fi
    ;;
  fish)
    CONFIG_FILE="$HOME/.config/fish/config.fish"
    ;;
  *)
    echo "❌ Unsupported shell: $SHELL_TYPE"
    echo "   Supported shells: bash, zsh, fish"
    echo "   Usage: /install-claudesidian-command [bash|zsh|fish]"
    exit 1
    ;;
esac

echo "🐚 Installing for: $SHELL_TYPE"
echo "📝 Config file: $CONFIG_FILE"
```

**Key improvements:**
- Uses `$SHELL` to detect default shell (not `$ZSH_VERSION`/`$BASH_VERSION` which detect current session)
- Supports command-line argument to override auto-detection
- Shows detected shell and config file for transparency
- Validates shell type and provides clear error message for unsupported shells

## Installation Steps

1. **Detect shell**: Use argument if provided, otherwise auto-detect from `$SHELL`
2. **Get vault path**: Use `pwd` to get current directory
3. **Escape the path**: Properly escape quotes and special characters for shell
   safety
   ```bash
   # Escape any double quotes in the path
   ESCAPED_PATH="${VAULT_PATH//\"/\\\"}"
   # Also escape backslashes
   ESCAPED_PATH="${ESCAPED_PATH//\\/\\\\}"
   ```
4. **Check if already installed**: Search config file for existing
   `claudesidian` alias
5. **Create backup**: Before modifying, create timestamped backup of config file
   ```bash
   # Create backup with timestamp
   BACKUP_FILE="$CONFIG_FILE.backup-$(date +%Y%m%d-%H%M%S)"
   cp "$CONFIG_FILE" "$BACKUP_FILE"
   echo "💾 Backup created: $BACKUP_FILE"
   ```
6. **Add alias**: Append to config file if not present, using double-quoted path
7. **Show success message**: With instructions to reload shell

## Example Output

```
🔧 Installing claudesidian command...

📁 Vault path: /home/user/my-vault
🐚 Shell detected: zsh
📝 Config file: /home/user/.zshrc

💾 Backup created: /home/user/.zshrc.backup-20250107-143025

✅ Installed! Added to /home/user/.zshrc:
   alias claudesidian='(cd "/home/user/my-vault" && (claude --resume 2>/dev/null || claude))'

🔄 To activate, run:
   source ~/.zshrc

   Or start a new terminal session.

✨ Test it: Type 'claudesidian' from any directory!
```

## Handling Special Characters

The implementation properly handles paths with:
- Spaces: `/Users/noah/My Vault`
- Quotes: `/Users/noah/vault's backup`
- Special characters that need escaping

Paths are double-quoted and any embedded quotes/backslashes are escaped.

## Important Notes

- The command uses a subshell `()` so it returns to your original directory
  after
- Automatically tries to resume existing sessions, falls back to new session
- If alias already exists, ask user if they want to replace it
- Always show what will be added before modifying config files
- **Always create timestamped backup** of config file before modifying (format:
  `YYYYMMDD-HHMMSS`)
- Backups are kept indefinitely - users can manually clean up old backups if
  needed
- Show backup location so users know where to restore from if needed

## Usage Examples

Install for your default shell (auto-detected):

```
/install-claudesidian-command
```

Install for specific shell (override auto-detection):

```
/install-claudesidian-command zsh
/install-claudesidian-command bash
/install-claudesidian-command fish
```

**When to specify shell:**
- You use multiple shells and want to install for a specific one
- Auto-detection picked the wrong shell
- You're setting up for someone else

## How It Works

The alias uses a clever pattern:

```bash
alias claudesidian='(cd "/path/to/vault" && (claude --resume 2>/dev/null || claude))'
```

1. `(cd "/path/to/vault" && ...)` - Subshell that changes directory temporarily
   (path is double-quoted for safety)
2. `claude --resume 2>/dev/null` - Tries to resume existing session, suppresses
   error
3. `|| claude` - If resume fails (no session), starts new session
4. After Claude exits, returns to original directory automatically
