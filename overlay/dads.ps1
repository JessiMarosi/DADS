param(
  [Parameter(Mandatory=$true)]
  [ValidateSet("validate","bundle","verify","fingerprint")]
  [string]$Command,

  [string]$BundlePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function OutLine([string]$s) { Write-Host $s }
function Pass([string]$s) { OutLine ("PASS | OVERLAY | " + $s) }
function Fail([string]$code, [string]$detail) { OutLine ("FAIL | OVERLAY | " + $code + " | " + $detail); exit 1 }

function RequireFile([string]$p, [string]$code) {
  if (-not (Test-Path -LiteralPath $p)) { Fail $code ("missing_path=" + $p) }
}

function Sha256File([string]$path) {
  (Get-FileHash -Algorithm SHA256 -LiteralPath $path).Hash.ToLowerInvariant()
}

function GitHead() {
  try { (git rev-parse HEAD).Trim() } catch { "unknown" }
}

function GitExactTag() {
  try { (git describe --tags --exact-match 2>$null).Trim() } catch { "" }
}

function RecordCounts([string]$recordsRoot) {
  $types = @("ANR","CR","DAR","DR","FIR","RAR","RR","SR")
  $counts = @{}
  foreach ($t in $types) {
    $dir = Join-Path $recordsRoot $t
    if (Test-Path -LiteralPath $dir) {
      $n = (Get-ChildItem -LiteralPath $dir -Filter *.json -File -ErrorAction SilentlyContinue | Measure-Object).Count
      $counts[$t] = $n
    } else {
      $counts[$t] = 0
    }
  }
  return $counts
}

function NewestBundleName([string]$bundleRoot) {
  if (-not (Test-Path -LiteralPath $bundleRoot)) { return "" }
  $d = Get-ChildItem -LiteralPath $bundleRoot -Directory -ErrorAction SilentlyContinue |
       Sort-Object LastWriteTime -Descending |
       Select-Object -First 1
  if ($null -eq $d) { return "" }
  return $d.Name
}

$repoRoot = (Resolve-Path ".").Path
$validator = Join-Path $repoRoot "validator\Validate-DADS.ps1"
$overlay   = Join-Path $repoRoot "overlay\dads.ps1"
$records   = Join-Path $repoRoot "records"
$bundleDir = Join-Path $repoRoot "bundle"

if ($Command -eq "validate") {
  RequireFile $validator "E_VALIDATOR_MISSING"
  & powershell -ExecutionPolicy Bypass -File $validator
  Pass "validate_complete"
  exit 0
}

if ($Command -eq "bundle") {
  RequireFile $validator "E_VALIDATOR_MISSING"
  & powershell -ExecutionPolicy Bypass -File $validator | Out-Null

  $ts = (Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
  $outDir = Join-Path $bundleDir ("DADS_ScrutinyBundle_" + $ts)

  New-Item -ItemType Directory -Force -Path $outDir | Out-Null

  foreach ($name in @("docs","overlay","validator","records")) {
    $src = Join-Path $repoRoot $name
    if (Test-Path -LiteralPath $src) {
      Copy-Item -Recurse -Force -LiteralPath $src -Destination (Join-Path $outDir $name)
    }
  }

  $meta = Join-Path $outDir "BUNDLE_METADATA.txt"
  $tag = GitExactTag
  if ([string]::IsNullOrWhiteSpace($tag)) { $tag = "no_exact_tag" }

  @(
    "bundle_type=DADS_ScrutinyBundle"
    ("created_utc=" + $ts)
    ("source_commit=" + (GitHead))
    ("source_exact_tag=" + $tag)
  ) | Set-Content -Encoding UTF8 -LiteralPath $meta

  $sumFile = Join-Path $outDir "SHA256SUMS.txt"
  $files = Get-ChildItem -LiteralPath $outDir -Recurse -File |
           Where-Object { $_.Name -ne "SHA256SUMS.txt" } |
           Sort-Object FullName

  $lines = @()
  foreach ($f in $files) {
    $h = (Get-FileHash -Algorithm SHA256 -LiteralPath $f.FullName).Hash.ToLowerInvariant()
    $rel = $f.FullName.Substring($outDir.Length + 1).Replace("\","/")
    $lines += ($h + "  " + $rel)
  }
  $lines | Set-Content -Encoding UTF8 -LiteralPath $sumFile

  Pass ("bundle_created=.\bundle\" + (Split-Path -Leaf $outDir))
  exit 0
}

if ($Command -eq "verify") {
  if ([string]::IsNullOrWhiteSpace($BundlePath)) { Fail "E_MISSING_BUNDLEPATH" "bundlepath_required" }

  $p = (Resolve-Path -LiteralPath $BundlePath -ErrorAction SilentlyContinue)
  if ($null -eq $p) { Fail "E_BUNDLE_NOT_FOUND" ("missing_path=" + $BundlePath) }
  $bundleRoot = $p.Path

  $meta = Join-Path $bundleRoot "BUNDLE_METADATA.txt"
  $sums = Join-Path $bundleRoot "SHA256SUMS.txt"
  RequireFile $meta "E_MISSING_BUNDLE_FILE"
  RequireFile $sums "E_MISSING_BUNDLE_FILE"

  $expected = Get-Content -LiteralPath $sums
  foreach ($line in $expected) {
    if ([string]::IsNullOrWhiteSpace($line)) { continue }
    $parts = $line.Split("  ")
    if ($parts.Count -lt 2) { Fail "E_BAD_SUMS_FORMAT" ("line=" + $line) }
    $hash = $parts[0].Trim()
    $rel  = $parts[1].Trim()
    $file = Join-Path $bundleRoot ($rel.Replace("/","\"))
    RequireFile $file "E_MISSING_BUNDLE_FILE"
    $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath $file).Hash.ToLowerInvariant()
    if ($actual -ne $hash) { Fail "E_HASH_MISMATCH" ("file=" + $rel) }
  }

  $bundledValidator = Join-Path $bundleRoot "validator\Validate-DADS.ps1"
  RequireFile $bundledValidator "E_MISSING_BUNDLE_FILE"
  Push-Location $bundleRoot
  try {
    & powershell -ExecutionPolicy Bypass -File $bundledValidator | Out-Null
  } finally {
    Pop-Location
  }

  Pass "verify_complete"
  exit 0
}

if ($Command -eq "fingerprint") {
  RequireFile $overlay   "E_OVERLAY_MISSING"
  RequireFile $validator "E_VALIDATOR_MISSING"

  $commit = GitHead
  $tag = GitExactTag
  if ([string]::IsNullOrWhiteSpace($tag)) { $tag = "no_exact_tag" }

  $overlayHash = Sha256File $overlay
  $validatorHash = Sha256File $validator

  $counts = RecordCounts $records
  $countsLine = ($counts.Keys | Sort-Object | ForEach-Object { $_ + "=" + $counts[$_] }) -join ","

  $newestBundle = NewestBundleName $bundleDir
  if ([string]::IsNullOrWhiteSpace($newestBundle)) { $newestBundle = "none" }

  OutLine ("PASS | OVERLAY | fingerprint | commit=" + $commit)
  OutLine ("PASS | OVERLAY | fingerprint | exact_tag=" + $tag)
  OutLine ("PASS | OVERLAY | fingerprint | overlay_sha256=" + $overlayHash)
  OutLine ("PASS | OVERLAY | fingerprint | validator_sha256=" + $validatorHash)
  OutLine ("PASS | OVERLAY | fingerprint | record_counts=" + $countsLine)
  OutLine ("PASS | OVERLAY | fingerprint | newest_bundle=" + $newestBundle)
  exit 0
}

Fail "E_UNKNOWN_COMMAND" ("command=" + $Command)
