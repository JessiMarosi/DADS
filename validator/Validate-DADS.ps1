Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function OutLine([string]$s) { Write-Host $s }
function Pass([string]$s) { OutLine ("PASS | " + $s) }
function Fail([string]$code, [string]$detail) { OutLine ("FAIL | " + $code + " | " + $detail); exit 1 }

$repoRoot = (Resolve-Path ".").Path
$recordsRoot = Join-Path $repoRoot "records"
$schemasRoot = Join-Path $repoRoot "schemas"

if (-not (Test-Path -LiteralPath $recordsRoot)) {
  Pass "no_records_present"
  exit 0
}

$recordFiles = Get-ChildItem -LiteralPath $recordsRoot -Recurse -Filter *.json -File -ErrorAction SilentlyContinue
if ($null -eq $recordFiles) { $recordFiles = @() }

if ($recordFiles.Count -eq 0) {
  Pass "no_records_present"
  exit 0
}

# Minimal structural check: ensure each JSON file parses
foreach ($f in $recordFiles) {
  try {
    Get-Content -LiteralPath $f.FullName -Raw | ConvertFrom-Json | Out-Null
  } catch {
    Fail "E_JSON_PARSE" ("file=" + $f.FullName)
  }
}

# Optional schema presence check (structural only)
if (Test-Path -LiteralPath $schemasRoot) {
  $typesPresent = @{}
  foreach ($f in $recordFiles) {
    try {
      $obj = Get-Content -LiteralPath $f.FullName -Raw | ConvertFrom-Json
      if ($null -ne $obj.record_type) {
        $t = [string]$obj.record_type
        if (-not $typesPresent.ContainsKey($t)) { $typesPresent[$t] = 0 }
        $typesPresent[$t] = $typesPresent[$t] + 1
      }
    } catch { }
  }

  foreach ($t in @("DR","RR","SR")) {
    if ($typesPresent.ContainsKey($t)) {
      $schemaPath = Join-Path $schemasRoot ($t + ".schema.json")
      if (-not (Test-Path -LiteralPath $schemaPath)) {
        Fail "E_SCHEMA_MISSING" ("record_type=" + $t)
      }
    }
  }
}

Pass ("records_validated=" + $recordFiles.Count)
exit 0
