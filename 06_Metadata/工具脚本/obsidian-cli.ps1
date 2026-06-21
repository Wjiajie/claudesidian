#Requires -Version 5.1
<#
.SYNOPSIS
  Obsidian 官方 CLI 的 PowerShell 包装器

.DESCRIPTION
  把 `obsidian.exe` 1.12+ 的 IPC 命令包成 agent 友好的形式：
    1. 静默过滤启动 banner（"Loading updated app package..." + "Your Obsidian installer..." 两行）
    2. 强制 UTF-8 编码捕获 stdout/stderr（避免 PowerShell 5.1 ANSI 编码吞中文）
    3. 提供 -DryRun 安全网（agent 操作知识库前先 dry-run 一次再确认）
    4. 自动写入调用日志到 .\logs\obsidian-cli-yyyy-MM-dd.log
    5. -Json 自动美化 JSON 输出
    6. -NoLog 跳过日志；-NoBanner 保留原始 banner

.PARAMETER Command
  Obsidian CLI 的子命令，例如 read / create / append / search / property:set

.PARAMETER Args
  透传给 obsidian 的 key=value 参数数组。例如：
    'file=06_Metadata/README.md'
    'query=AI' 'format=json'

.PARAMETER Vault
  可选。-Vault 显式指定 vault 名（默认用 active vault，单库环境可省）

.PARAMETER DryRun
  只打印将要执行的命令，不实际执行

.PARAMETER NoLog
  跳过日志写入

.PARAMETER NoBanner
  不过滤 banner（调试用）

.PARAMETER Json
  尝试把输出解析为 JSON 并美化（如果解析失败则原样输出）

.EXAMPLE
  .\obsidian-cli.ps1 read 'file=06_Metadata/README.md'

.EXAMPLE
  .\obsidian-cli.ps1 search 'query=obsidian' 'format=json' -Json

.EXAMPLE
  .\obsidian-cli.ps1 create 'name=新笔记.md' 'content=初始内容' 'template=Daily Note Template' -DryRun

.EXAMPLE
  .\obsidian-cli.ps1 property:set 'name=parent' 'value=[[索引入口]]' 'path=00_Inbox/2026-06-06.md'

.NOTES
  路径：06_Metadata/工具脚本/obsidian-cli.ps1
  配套速查：06_Metadata/A-202606061851-obsidian-cli.md
  配套模板：06_Metadata/模板文件/agent-operation-log.md
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Command,

    [Parameter(ValueFromRemainingArguments = $true, Position = 1)]
    [string[]]$Args,

    [string]$Vault,

    [switch]$DryRun,
    [switch]$NoLog,
    [switch]$NoBanner,
    [switch]$Json
)

$ErrorActionPreference = 'Stop'

# ---------- 解析自身位置 ----------
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$LogDir    = Join-Path $ScriptDir 'logs'
$ObsExe    = (Get-Command obsidian -ErrorAction SilentlyContinue).Source
if (-not $ObsExe) {
    $ObsExe = Join-Path $env:LOCALAPPDATA 'Programs\Obsidian\Obsidian.exe'
}
if (-not (Test-Path $ObsExe)) {
    Write-Error "找不到 obsidian.exe。请确认 Obsidian 1.12+ 已安装，或将 obsidian 加入 PATH。"
    exit 127
}

# ---------- 拼命令 ----------
$argList = @($Command)
if ($Vault) { $argList += "vault=$Vault" }
if ($Args)  { $argList += $Args }

$cmdLine = "obsidian " + ($argList -join ' ')

# ---------- 日志 ----------
if (-not $NoLog) {
    if (-not (Test-Path $LogDir)) {
        New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
    }
}

function Write-Log {
    param([string]$Status, [string]$Detail)
    if ($NoLog) { return }
    $logFile = Join-Path $LogDir ("obsidian-cli-" + (Get-Date -Format 'yyyy-MM-dd') + '.log')
    $ts = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $entry = "[$ts] [$Status] $cmdLine :: $Detail"
    Add-Content -Path $logFile -Value $entry -Encoding UTF8
}

# ---------- DryRun ----------
if ($DryRun) {
    Write-Host "[DRY-RUN] $cmdLine" -ForegroundColor Yellow
    Write-Log "DRYRUN" "would-execute"
    exit 0
}

# ---------- 执行 ----------
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName               = $ObsExe
$psi.Arguments              = ($argList -join ' ')
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError  = $true
$psi.UseShellExecute        = $false
$psi.CreateNoWindow         = $true
$psi.StandardOutputEncoding = [System.Text.Encoding]::UTF8
$psi.StandardErrorEncoding  = [System.Text.Encoding]::UTF8

try {
    $p = [System.Diagnostics.Process]::Start($psi)
    $stdout = $p.StandardOutput.ReadToEnd()
    $stderr = $p.StandardError.ReadToEnd()
    $p.WaitForExit()
    $exitCode = $p.ExitCode
}
catch {
    Write-Error "启动 obsidian 失败：$_"
    Write-Log "ERROR" "spawn-failed: $_"
    exit 1
}

# ---------- 过滤 banner ----------
if (-not $NoBanner) {
    $lines = $stdout -split "`r?`n"
    # 跳过开头连续的 banner 行（"Loading updated app package..." 和 "Your Obsidian installer..."）
    $filtered = New-Object System.Collections.Generic.List[string]
    $bannerSkipped = 0
    foreach ($line in $lines) {
        if ($bannerSkipped -lt 2 -and (
            $line -match '^Loading updated app package\b' -or
            $line -match '^Your Obsidian installer is out of date\b'
        )) {
            $bannerSkipped++
            continue
        }
        $filtered.Add($line)
    }
    $stdout = ($filtered -join "`n").TrimEnd("`n")
}

# ---------- stderr 透传（异常时重要） ----------
if ($stderr.Trim()) {
    $host.UI.WriteErrorLine($stderr.TrimEnd())
}

# ---------- stdout 处理 ----------
if ($Json -and $stdout.Trim()) {
    $parsed = $stdout | ConvertFrom-Json -ErrorAction SilentlyContinue
    if ($null -ne $parsed) {
        $stdout = $parsed | ConvertTo-Json -Depth 10
    }
}

if ($stdout) {
    Write-Output $stdout
}

# ---------- 退出码 + 日志 ----------
if ($exitCode -ne 0) {
    Write-Log "FAIL" "exit=$exitCode stderr=$(($stderr -replace "`r?`n",' | ').Trim())"
    exit $exitCode
} else {
    Write-Log "OK" "stdout-bytes=$($stdout.Length)"
    exit 0
}
