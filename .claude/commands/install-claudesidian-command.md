---
allowed-tools: [Read, Write, Bash]
description: Install claudesidian shell command to launch Claude Code from anywhere
argument-hint: (optional shell: bash/zsh/fish)
---

# Install Claudesidian Command

Creates a shell alias/function that allows you to run `claudesidian` from anywhere
to open your vault in Claude Code.

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
- All in one command: `(cd /path/to/vault && (claude --resume 2>/dev/null || claude))`

This automatically enters resume mode if there's an existing session, or starts a new one if not.

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

```bash
# Detect current shell
if [ -n "$ZSH_VERSION" ]; then
  SHELL_TYPE="zsh"
  CONFIG_FILE="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
  SHELL_TYPE="bash"
  # Prefer .bashrc on Linux, .bash_profile on macOS
  if [ -f "$HOME/.bashrc" ]; then
    CONFIG_FILE="$HOME/.bashrc"
  else
    CONFIG_FILE="$HOME/.bash_profile"
  fi
elif [ -n "$FISH_VERSION" ]; then
  SHELL_TYPE="fish"
  CONFIG_FILE="$HOME/.config/fish/config.fish"
fi
```

## Installation Steps

1. **Get vault path**: Use `pwd` to get current directory
2. **Check if already installed**: Search config file for existing `claudesidian` alias
3. **Add alias**: Append to config file if not present
4. **Show success message**: With instructions to reload shell

## Example Output

```
🔧 Installing claudesidian command...

📁 Vault path: /home/user/my-vault
🐚 Shell detected: zsh
📝 Config file: /home/user/.zshrc

✅ Installed! Added to /home/user/.zshrc:
   alias claudesidian='(cd /home/user/my-vault && (claude --resume 2>/dev/null || claude))'

🔄 To activate, run:
   source ~/.zshrc

   Or start a new terminal session.

✨ Test it: Type 'claudesidian' from any directory!
```

## Important Notes

- The command uses a subshell `()` so it returns to your original directory after
- Automatically tries to resume existing sessions, falls back to new session
- If alias already exists, ask user if they want to replace it
- Always show what will be added before modifying config files
- Create backup of config file before modifying

## Usage Examples

Install for current shell:
```
/install-claudesidian-command
```

Install for specific shell:
```
/install-claudesidian-command zsh
/install-claudesidian-command bash
```

## How It Works

The alias uses a clever pattern:
```bash
alias claudesidian='(cd /path/to/vault && (claude --resume 2>/dev/null || claude))'
```

1. `(cd /path/to/vault && ...)` - Subshell that changes directory temporarily
2. `claude --resume 2>/dev/null` - Tries to resume existing session, suppresses error
3. `|| claude` - If resume fails (no session), starts new session
4. After Claude exits, returns to original directory automatically
