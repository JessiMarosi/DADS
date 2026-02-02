param(
  [string]$Root = ".",
  [string]$Scope = "examples",
  [switch]$Quiet
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Fail([string]$msg) { throw $msg }

function IsIso8601WithTz([string]$s) {
  if ([string]::IsNullOrWhiteSpace($s)) { return $false }
  if ($s -notmatch '(Z|[+\-]\d{2}:\d{2})$') { return $false }
  try {
    [void][DateTimeOffset]::Parse($s, [System.Globalization.CultureInfo]::InvariantCulture)
    return $true
  } catch {
    return $false
  }
}

function ParseRecordMap([string]$path) {
  $lines = Get-Content -LiteralPath $path -Encoding UTF8
  $map = @{}

  foreach ($line in $lines) {
    if ($line -match '^\s*$') { continue }
    if ($line -match '^\s*#') { continue }

    $m = [regex]::Match($line, '^\s*([A-Za-z0-9\-_]+)\s*:\s*(.*)\s*$')
    if (-not $m.Success) { continue }

    $k = $m.Groups[1].Value.Trim()
    $v = $m.Groups[2].Value.Trim()

    if (-not $map.ContainsKey($k)) {
      $map[$k] = $v
    }
  }

  return $map
}

$knownTypes = @(
  "decision",
  "supersession",
  "obligation_declaration",
  "derived_notice",
  "risk_acceptance"
)

$idPattern = '^[a-z0-9_]+$'

$scopePath = Join-Path -Path $Root -ChildPath $Scope
if (-not (Test-Path -LiteralPath $scopePath)) {
  Fail "Scope path not found: $scopePath"
}

$files = Get-ChildItem -LiteralPath $scopePath -Recurse -File -Filter "*.md" |
  Sort-Object FullName

# Index Record-ID -> file for referential checks and uniqueness
$idIndex = @{}
$duplicates = New-Object System.Collections.Generic.List[string]

foreach ($f in $files) {
  $rec = ParseRecordMap $f.FullName
  if ($rec.ContainsKey("Record-ID") -and -not [string]::IsNullOrWhiteSpace($rec["Record-ID"])) {
    $rid = $rec["Record-ID"].Trim()
    if ($idIndex.ContainsKey($rid)) {
      $duplicates.Add("Duplicate Record-ID '$rid' in: '$($idIndex[$rid])' and '$($f.FullName)'")
    } else {
      $idIndex[$rid] = $f.FullName
    }
  }
}

# Use a PowerShell array for violations to avoid StrictMode surprises
$violations = @()
$violations += $duplicates

foreach ($f in $files) {
  $rec = ParseRecordMap $f.FullName

  foreach ($k in @("Record-Type","Record-ID","Created-At","Created-By","System-Scope")) {
    if (-not $rec.ContainsKey($k) -or [string]::IsNullOrWhiteSpace($rec[$k])) {
      $violations += "$($f.FullName): missing or empty $k"
    }
  }

  if ($rec.ContainsKey("Record-Type") -and -not [string]::IsNullOrWhiteSpace($rec["Record-Type"])) {
    $t = $rec["Record-Type"].Trim()
    if ($knownTypes -notcontains $t) {
      $violations += "$($f.FullName): unknown Record-Type '$t'"
    }
  }

  if ($rec.ContainsKey("Record-ID") -and -not [string]::IsNullOrWhiteSpace($rec["Record-ID"])) {
    $rid = $rec["Record-ID"].Trim()
    if ($rid -notmatch $idPattern) {
      $violations += "$($f.FullName): Record-ID '$rid' violates pattern $idPattern"
    }
  }

  if ($rec.ContainsKey("Created-At") -and -not [string]::IsNullOrWhiteSpace($rec["Created-At"])) {
    $ts = $rec["Created-At"].Trim()
    if (-not (IsIso8601WithTz $ts)) {
      $violations += "$($f.FullName): Created-At '$ts' is not timezone-explicit ISO 8601"
    }
  }

  foreach ($refKey in @("Derived-From-Decision-ID","Supersedes-Record-ID","Superseding-Record-ID")) {
    if ($rec.ContainsKey($refKey) -and -not [string]::IsNullOrWhiteSpace($rec[$refKey])) {
      $ref = $rec[$refKey].Trim()
      if (-not $idIndex.ContainsKey($ref)) {
        $violations += "$($f.FullName): reference $refKey '$ref' not found in scope"
      }
    }
  }
}

$sorted = $violations | Sort-Object
$cnt = @($sorted).Count

if ($cnt -eq 0) {
  if (-not $Quiet) { Write-Output "PASS: no violations in scope '$Scope' under '$scopePath'" }
  exit 0
} else {
  Write-Output "FAIL: $cnt violation(s) in scope '$Scope' under '$scopePath'"
  foreach ($v in $sorted) { Write-Output $v }
  exit 1
}
