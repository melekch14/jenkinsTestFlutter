[CmdletBinding()]
param(
    [string]$PubspecPath
)

if (-not $PubspecPath) {
    $PubspecPath = Join-Path (Split-Path -Parent $PSScriptRoot) "pubspec.yaml"
}

$resolvedPubspec = Resolve-Path -LiteralPath $PubspecPath -ErrorAction SilentlyContinue
if (-not $resolvedPubspec) {
    throw "pubspec.yaml was not found at '$PubspecPath'."
}

$versionLine = Get-Content -LiteralPath $resolvedPubspec |
    Where-Object { $_ -match '^\s*version\s*:' } |
    Select-Object -First 1

if (-not $versionLine) {
    throw "No version entry was found in '$resolvedPubspec'. Add one like: version: 1.0.0+1"
}

$rawVersion = ($versionLine -replace '^\s*version\s*:\s*', '').Trim()
$rawVersion = ($rawVersion -split '\s+#', 2)[0].Trim().Trim("'`"")

if ($rawVersion -notmatch '^([0-9]+\.[0-9]+\.[0-9]+)\+([0-9]+)$') {
    throw "Invalid Flutter version '$rawVersion'. Expected format: x.y.z+buildNumber, for example: 1.2.0+15"
}

$appVersion = $Matches[1]
$appBuildNumber = $Matches[2]

Write-Output "APP_VERSION_FULL=$rawVersion"
Write-Output "APP_VERSION=$appVersion"
Write-Output "APP_BUILD_NUMBER=$appBuildNumber"
