<#
DADS Program Overlay (Phase 6)
- Deterministic, structural-only
- No enforcement, no recommendations, no interpretation
Commands:
  validate
  bundle
  verify
#>

param(
  [Parameter(Mandatory=$true)]
  [ValidateSet("validate","bundle","verify")]
  [string]$Command,

  [string]$RepoRoot = ".",
  [string]$BundlePath = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Out-Line([string]$s) { [Console]::WriteLine($s) }

function Fail([string]$code, [string]$detail) {
  Out-Line("FAIL | OVERLAY | $code | $detail")
  exit 1
}

function Ok([string]$detail) {
  Out-Line("PASS | OVERLAY | $detail")
}

function Assert-Path([string]$p, [string]$code) {
  if (-not (Test-Path -LiteralPath $p)) { Fail $code ("missing_path=" + $p) }
}

function FullPath([string]$p) {
  (Resolve-Path -LiteralPath $p).Path
}

function Get-Sha256([string]$file) {
  (Get-FileHash -Algorithm SHA256 -LiteralPath $file).Hash.ToLowerInvariant()
}

function Write-Manifest([string]$root, [string]$outFile) {
  # Always use absolute paths for deterministic relative path calculation
  $rootAbs = FullPath $root
  $files = Get-ChildItem -LiteralPath $rootAbs -Recurse -File | Sort-Object FullName

  $lines = New-Object System.Collections.Generic.List[string]
  foreach ($f in $files) {
    # Compute relative path strictly from absolute root
    $rel = $f.FullName.Substring($rootAbs.Length).TrimStart('\','/')
    $hash = Get-Sha256 $f.FullName
    $lines.Add("$hash  $rel")
  }

  $lines | Set-Content -Encoding UTF8 $outFile
}

function Verify-Manifest([string]$root, [string]$manifestFile) {
  $rootAbs = FullPath $root
  $lines = Get-Content -LiteralPath $manifestFile -Encoding UTF8

  foreach ($line in $lines) {
    if ([string]::IsNullOrWhiteSpace($line)) { continue }

    $parts = $line.Split("  ",2,[System.StringSplitOptions]::None)
    if ($parts.Count -ne 2) { Fail "E_BAD_MANIFEST" ("line=" + $line) }

    $expected = $parts[0].Trim().ToLowerInvariant()
    $rel = $parts[1].Trim()

    $path = Join-Path $rootAbs $rel
    if (-not (Test-Path -LiteralPath $path)) { Fail "E_MISSING_BUNDLE_FILE" ("file=" + $rel) }

    $actual = Get-Sha256 $path
    if ($actual -ne $expected) { Fail "E_HASH_MISMATCH" ("file=" + $rel) }
  }
}

function Run-Validator([string]$root) {
  $rootAbs = FullPath $root
  $validator = Join-Path $rootAbs "validator\Validate-DADS.ps1"
  Assert-Path $validator "E_NO_VALIDATOR"

  $cmd = @("powershell","-ExecutionPolicy","Bypass","-File",$validator,"-RepoRoot",$rootAbs)
  $p = Start-Process -FilePath $cmd[0] -ArgumentList $cmd[1..($cmd.Count-1)] -NoNewWindow -Wait -PassThru
  if ($p.ExitCode -ne 0) { Fail "E_VALIDATOR_FAIL" ("exit_code=" + $p.ExitCode) }
}

if ($Command -eq "validate") {
  Assert-Path (Join-Path $RepoRoot "records") "E_NO_RECORDS_DIR"
  Run-Validator $RepoRoot
  Ok "validate_complete"
  exit 0
}

if ($Command -eq "bundle") {
  Assert-Path (Join-Path $RepoRoot "records") "E_NO_RECORDS_DIR"
  Assert-Path (Join-Path $RepoRoot "validator") "E_NO_VALIDATOR_DIR"
  Assert-Path (Join-Path $RepoRoot "docs") "E_NO_DOCS_DIR"
  Assert-Path (Join-Path $RepoRoot "overlay") "E_NO_OVERLAY_DIR"

  $ts = (Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
  $outRootRel = Join-Path $RepoRoot ("bundle\DADS_ScrutinyBundle_" + $ts)
  New-Item -ItemType Directory -Force $outRootRel | Out-Null

  Copy-Item -Recurse -Force (Join-Path $RepoRoot "records")   (Join-Path $outRootRel "records")
  Copy-Item -Recurse -Force (Join-Path $RepoRoot "validator") (Join-Path $outRootRel "validator")
  Copy-Item -Recurse -Force (Join-Path $RepoRoot "docs")      (Join-Path $outRootRel "docs")
  Copy-Item -Recurse -Force (Join-Path $RepoRoot "overlay")   (Join-Path $outRootRel "overlay")

  $metaFile = Join-Path $outRootRel "BUNDLE_METADATA.txt"
  $commit = ""
  $tag = ""
  try { $commit = (git rev-parse HEAD 2>$null).Trim() } catch { }
  try { $tag = (git describe --tags --exact-match 2>$null).Trim() } catch { }

  @(
    "bundle_created_utc=" + (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    "git_commit=" + $commit
    "git_exact_tag=" + $tag
  ) | Set-Content -Encoding UTF8 $metaFile

  Run-Validator $outRootRel

  $manifest = Join-Path $outRootRel "SHA256SUMS.txt"
  Write-Manifest $outRootRel $manifest

  Ok ("bundle_created=" + $outRootRel)
  exit 0
}

if ($Command -eq "verify") {
  if ([string]::IsNullOrWhiteSpace($BundlePath)) {
    Fail "E_NO_BUNDLEPATH" "BundlePath is required for verify"
  }

  Assert-Path $BundlePath "E_BUNDLE_NOT_FOUND"
  $manifest = Join-Path $BundlePath "SHA256SUMS.txt"
  Assert-Path $manifest "E_NO_MANIFEST"

  Verify-Manifest $BundlePath $manifest
  Run-Validator $BundlePath

  Ok "verify_complete"
  exit 0
}

Fail "E_UNKNOWN" ("command=" + $Command)
