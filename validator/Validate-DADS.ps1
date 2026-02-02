<#
DADS Phase 5  Deterministic Structural Validator (Skeleton)

- Structural checks only
- PASS / FAIL output only
- No enforcement
- No recommendations
- No interpretation
#>

param(
  [string]$RepoRoot = "."
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Deterministic([string]$msg) {
  [Console]::WriteLine($msg)
}

function Fail([string]$code, [string]$detail) {
  Write-Deterministic("FAIL | $code | $detail")
  exit 1
}

function Pass([string]$detail) {
  Write-Deterministic("PASS | $detail")
  exit 0
}

function Assert-Exists([string]$path, [string]$code) {
  if (-not (Test-Path -LiteralPath $path)) {
    Fail $code ("missing_path=" + $path)
  }
}

function Read-JsonFile([string]$path) {
  try {
    $raw = Get-Content -LiteralPath $path -Raw -Encoding UTF8
    return ($raw | ConvertFrom-Json -ErrorAction Stop)
  } catch {
    Fail "E_JSON_PARSE" ("file=" + $path)
  }
}

function Has-Prop($obj, [string]$name) {
  return $null -ne ($obj.PSObject.Properties[$name])
}

function Require-Props($obj, [string]$file, [string[]]$props) {
  foreach ($p in $props) {
    if (-not (Has-Prop $obj $p)) {
      Fail "E_MISSING_FIELD" ("file=" + $file + " field=" + $p)
    }
  }
}

# --- Repo structure checks ---
Assert-Exists (Join-Path $RepoRoot "records") "E_NO_RECORDS_DIR"
Assert-Exists (Join-Path $RepoRoot "validator") "E_NO_VALIDATOR_DIR"
Assert-Exists (Join-Path $RepoRoot "docs") "E_NO_DOCS_DIR"

# --- Collect record files ---
$recordFiles = Get-ChildItem -LiteralPath (Join-Path $RepoRoot "records") -Recurse -File -Filter *.json -ErrorAction Stop

# Normalize to array (PowerShell single-item edge case)
$recordFiles = @($recordFiles)

if ($recordFiles.Count -eq 0) {
  Pass "no_records_present"
}

# --- Basic per-record structural validation ---
$requiredCommon = @("record_id","record_type","created_utc","actors")

$index = @{}

foreach ($f in $recordFiles) {
  $obj = Read-JsonFile $f.FullName
  Require-Props $obj $f.FullName $requiredCommon

  $rid = [string]$obj.record_id
  if ([string]::IsNullOrWhiteSpace($rid)) {
    Fail "E_BAD_RECORD_ID" ("file=" + $f.FullName)
  }

  if ($index.ContainsKey($rid)) {
    Fail "E_DUP_RECORD_ID" ("record_id=" + $rid)
  }
  $index[$rid] = $f.FullName
}

# --- Minimal linkage checks (skeleton only) ---
foreach ($f in $recordFiles) {
  $obj = Read-JsonFile $f.FullName
  $rtype = [string]$obj.record_type

  if ($rtype -eq "SR") {
    Require-Props $obj $f.FullName @("superseded_record_ids","superseding_record_id","supersession_reason")

    foreach ($sid in $obj.superseded_record_ids) {
      if (-not $index.ContainsKey([string]$sid)) {
        Fail "E_LINK_MISSING" ("file=" + $f.FullName + " missing_ref=" + [string]$sid)
      }
    }

    $spr = [string]$obj.superseding_record_id
    if (-not $index.ContainsKey($spr)) {
      Fail "E_LINK_MISSING" ("file=" + $f.FullName + " missing_ref=" + $spr)
    }
  }
}

Pass ("records_validated=" + $recordFiles.Count)
