@echo Executing build with build.ps1 configuration
@echo off
powershell.exe -NoProfile -ExecutionPolicy bypass -Command "& {.\configure-build.ps1 }"
powershell.exe -NoProfile -ExecutionPolicy bypass -Command "& {invoke-psake .\build.ps1 %1 -parameters @{"version"="'%2'"};  exit !($psake.build_success) }"