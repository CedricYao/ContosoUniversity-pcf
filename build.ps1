$script:project_config = "Release"

properties {

  Framework '4.5.1'

  $project_name = "ContosoUniversity"

  if(-not $version)
  {
      $version = "0.0.0.1"
  }

  $date = Get-Date  
  


  $ReleaseNumber =  $version
  
  Write-Host "**********************************************************************"
  Write-Host "Release Number: $ReleaseNumber"
  Write-Host "**********************************************************************"
  

  $base_dir = resolve-path .
  $build_dir = "$base_dir\build"     
  $solution_file = "$base_dir\$project_name.sln"
  $project_file = "$base_dir\$project_name\$project_name.csproj"
  $publish_dir = "$base_dir\..\publish"
  $output_dir = "$build_dir\_PublishedWebsites\$project_name"

  $nuget_exe = "$base_dir\tools\nuget\nuget.exe"

  $packageId = if ($env:package_id) { $env:package_id } else { "$project_name" }
}
   
#These are aliases for other build tasks. They typically are named after the camelcase letters (rd = Rebuild Databases)
task default -depends InitialPrivateBuild
task dev -depends DeveloperBuild
task ci -depends IntegrationBuild
task ? -depends help

task help {
   Write-Help-Header
   Write-Help-Section-Header "Comprehensive Building"
   Write-Help-For-Alias "(default)" "Intended for first build or when you want a fresh, clean local copy"
   Write-Help-For-Alias "dev" "Optimized for local dev"
   Write-Help-For-Alias "ci" "Continuous Integration build (long and thorough) with packaging"
   Write-Help-Footer
   exit 0
}

#These are the actual build tasks. They should be Pascal case by convention
task InitialPrivateBuild -depends Clean, Compile

task DeveloperBuild -depends Clean, SetDebugBuild, Compile

task IntegrationBuild -depends Clean, SetReleaseBuild, Compile, Publish

task SetDebugBuild {
    $script:project_config = "Debug"
}

task SetReleaseBuild {
    $script:project_config = "Release"
}

task Compile -depends Clean { 
    exec { & $nuget_exe restore $solution_file }
    exec { msbuild.exe /t:build /v:q /p:Configuration=$project_config /p:Platform="Any CPU" /p:OutputPath="$build_dir" /nologo $project_file }
}

task Clean {
	delete_directory $build_dir
	delete_directory $publish_dir
    exec { msbuild /t:clean /v:q /p:Configuration=$project_config /p:Platform="Any CPU" $solution_file }
}

task Publish {
	Write-Host "publish-dir: $publish_dir"
	Copy-Item $output_dir -Destination $publish_dir -Recurse -Force
}

# -------------------------------------------------------------------------------------------------------------
# generalized functions for Help Section
# --------------------------------------------------------------------------------------------------------------

function Write-Help-Header($description) {
   Write-Host ""
   Write-Host "********************************" -foregroundcolor DarkGreen -nonewline;
   Write-Host " HELP " -foregroundcolor Green  -nonewline; 
   Write-Host "********************************"  -foregroundcolor DarkGreen
   Write-Host ""
   Write-Host "This build script has the following common build " -nonewline;
   Write-Host "task " -foregroundcolor Green -nonewline;
   Write-Host "aliases set up:"
}

function Write-Help-Footer($description) {
   Write-Host ""
   Write-Host " For a complete list of build tasks, view default.ps1."
   Write-Host ""
   Write-Host "**********************************************************************" -foregroundcolor DarkGreen
}

function Write-Help-Section-Header($description) {
   Write-Host ""
   Write-Host " $description" -foregroundcolor DarkGreen
}

function Write-Help-For-Alias($alias,$description) {
   Write-Host "  > " -nonewline;
   Write-Host "$alias" -foregroundcolor Green -nonewline; 
   Write-Host " = " -nonewline; 
   Write-Host "$description"
}

# -------------------------------------------------------------------------------------------------------------
# generalized functions 
# --------------------------------------------------------------------------------------------------------------
function global:delete_file($file) {
    if($file) { remove-item $file -force -ErrorAction SilentlyContinue | out-null } 
}

function global:delete_directory($directory_name)
{
  rd $directory_name -recurse -force  -ErrorAction SilentlyContinue | out-null
}
