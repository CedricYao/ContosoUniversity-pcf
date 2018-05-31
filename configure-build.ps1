# pull dependencies
$has_vsSetup = Get-Module -ListAvailable | Select-String -Pattern "VSSetup" -Quiet
if(-Not($has_vsSetup)) {
	#install VSSetup
	Write-Host "Installing VSSetup" -ForegroundColor Yellow
	Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
	Install-Module VSSetup -Scope CurrentUser
}

$has_psake = Get-Module -ListAvailable | Select-String -Pattern "Psake" -Quiet
if(-Not($has_psake)) {
	#install psake
	Write-Host "Installing Psake" -ForegroundColor Yellow
	Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
	Install-Module Psake -Scope CurrentUser
}