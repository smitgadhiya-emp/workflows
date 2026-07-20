# WF-152 — create the release tags the Codex connector can't.
# Creates v1.3.0 / v1.4.0 (stable) and v1.5.0-rc.1 (pre-release) at the exact commits
# Codex mapped, using the GitHub Releases API (this also creates the tag at that commit).
#
# 1. Make a GitHub Personal Access Token with write access to the repo:
#      classic token -> scope "repo",  OR  fine-grained -> Contents: Read and write.
# 2. Paste it below, then run this file in PowerShell.

$token = "PASTE_YOUR_PAT_HERE"
$repo  = "smitempiricinfotech-wq/Multi-Audience-Generator"

$headers = @{
  Authorization          = "Bearer $token"
  Accept                 = "application/vnd.github+json"
  "X-GitHub-Api-Version" = "2022-11-28"
}

# tag -> exact commit SHA (from Codex's mapping) + stable/pre-release flag
$releases = @(
  @{ tag_name = "v1.3.0";      target_commitish = "a12155c82c7a30a51e790b521951bf6c26784af2"; name = "v1.3.0";      prerelease = $false },
  @{ tag_name = "v1.4.0";      target_commitish = "35e8d26eeaa7651286b2f2240486406525e21127"; name = "v1.4.0";      prerelease = $false },
  @{ tag_name = "v1.5.0-rc.1"; target_commitish = "25a2150c1b607746edfe3cccb69cb26a70e5e388"; name = "v1.5.0-rc.1"; prerelease = $true }
)

foreach ($r in $releases) {
  $body = $r | ConvertTo-Json
  try {
    $resp = Invoke-RestMethod -Method Post -Uri "https://api.github.com/repos/$repo/releases" -Headers $headers -Body $body -ContentType "application/json"
    Write-Host "Created $($r.tag_name) at $($r.target_commitish.Substring(0,10)) (prerelease=$($r.prerelease))" -ForegroundColor Green
  } catch {
    Write-Host "FAILED $($r.tag_name): $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) { Write-Host $_.ErrorDetails.Message -ForegroundColor Red }
  }
}

Write-Host "`nTags now on the repo:" -ForegroundColor Cyan
Invoke-RestMethod -Method Get -Uri "https://api.github.com/repos/$repo/tags" -Headers $headers |
  Select-Object name, @{n='sha';e={$_.commit.sha.Substring(0,10)}} | Format-Table -AutoSize
