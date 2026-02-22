# Skill discovery hook - suggests relevant skills when user mentions "skill"
# Exit 0 stdout → added as context for Claude
# No dependencies - pure PowerShell

$ErrorActionPreference = "SilentlyContinue"

# Read all stdin
$StdinData = [Console]::In.ReadToEnd()

# Extract the prompt field from JSON
$PROMPT = ""
try {
    $obj = $StdinData | ConvertFrom-Json
    $PROMPT = $obj.prompt
}
catch {}

if (-not $PROMPT) {
    exit 0
}

# Match: skill, skills (case-insensitive, word boundary) in prompt only
if ($PROMPT -match '\bskills?\b') {
    $SKILLS_DIR = if ($env:CLAUDE_PROJECT_DIR) { "$env:CLAUDE_PROJECT_DIR\.claude\skills" } else { ".\.claude\skills" }

    if (Test-Path $SKILLS_DIR) {
        $output = @()
        foreach ($d in Get-ChildItem $SKILLS_DIR -Directory) {
            $skillFile = Join-Path $d.FullName "SKILL.md"
            if (Test-Path $skillFile) {
                # Extract description from YAML frontmatter
                $desc = Get-Content $skillFile | Where-Object { $_ -match '^description:' } | Select-Object -First 1
                if ($desc) {
                    $desc = ($desc -replace '^description:\s*', '').Trim()
                    $output += "$($d.Name): $desc"
                }
                else {
                    $output += $d.Name
                }
            }
            else {
                $output += $d.Name
            }
        }

        if ($output.Count -gt 0) {
            Write-Output "<skill-discovery>"
            Write-Output "The user mentioned 'skill'. Available skills in this project:"
            Write-Output ""
            $output | Sort-Object | ForEach-Object { Write-Output $_ }
            Write-Output "If relevant to the user's request, read the SKILL.md file to load the skill instructions."
            Write-Output "</skill-discovery>"
        }
    }
}

exit 0
