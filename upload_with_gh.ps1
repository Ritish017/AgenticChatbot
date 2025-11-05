# PowerShell script to upload files to GitHub repo using GitHub CLI (gh)
# Usage: Run this script from the project root after creating the repo with gh

$ghPath = 'C:\Github CLI 2.65\gh_2.65.0_windows_amd64\bin\gh.exe'
$repo = 'Ritish017/AgenticChatbot'
$branch = 'main'

# Get all files recursively, excluding .git and __pycache__
$files = Get-ChildItem -Recurse -File | Where-Object { $_.FullName -notmatch '\\.git|__pycache__' }

foreach ($file in $files) {
    $relativePath = $file.FullName.Substring($PWD.Path.Length + 1)
    Write-Host "Uploading $relativePath..."
    # Read file content and encode to base64
    $content = [Convert]::ToBase64String([IO.File]::ReadAllBytes($file.FullName))
    # Prepare JSON payload
    $json = @{
        message = "Add $relativePath"
        content = $content
        branch = $branch
    } | ConvertTo-Json
    # Use gh api to upload file
    & $ghPath api repos/$repo/contents/$relativePath -X PUT -F message="Add $relativePath" -F content=$content -F branch=$branch
}

Write-Host "Upload complete."
