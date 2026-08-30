# deploy.ps1 - Sync images, build, commit, push, and deploy to GitHub Pages
# Usage: .\deploy.ps1 ["optional commit message"]

$ErrorActionPreference = "Stop"

$root = $PSScriptRoot
Set-Location $root

# 1. Sync images/ -> docs/img/ (mirror, copy only changed files)
Write-Host "==> Syncing images/ -> docs/img/" -ForegroundColor Cyan
robocopy "$root\images" "$root\docs\img" /MIR /NJH /NJS /NDL /NC /NS /NP | Out-Null
if ($LASTEXITCODE -ge 8) {
    Write-Error "robocopy failed with exit code $LASTEXITCODE"
}

# 2. Build the site (gh-deploy also builds, but verify locally first)
Write-Host "==> Building site with mkdocs" -ForegroundColor Cyan
python -m mkdocs build --strict

# 3. Commit all source changes
$msg = $args[0]
if (-not $msg) { $msg = "docs: sync images and update content ($(Get-Date -Format 'yyyy-MM-dd HH:mm'))" }

Write-Host "==> Committing changes" -ForegroundColor Cyan
git add -A
$status = git status --porcelain
if (-not $status) {
    Write-Host "No changes to commit." -ForegroundColor Yellow
} else {
    git commit -m $msg
    git push origin master
}

# 4. Deploy to GitHub Pages (gh-pages branch)
Write-Host "==> Deploying to GitHub Pages (gh-pages)" -ForegroundColor Cyan
python -m mkdocs gh-deploy --force

Write-Host "==> Done. Site: https://T4gamer.github.io/arduino_lvl_2/" -ForegroundColor Green
