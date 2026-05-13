param(
    [string]
    # Naming this $ProjectPath would cause it to overwrite the variable passed to Pester
    $Path = 'source',

    [ValidateSet('Debug', 'Release')]
    [string]
    $Configuration = (property CompileConfiguration 'Release')
)

task compile {
    # BuildRoot is injected
    $ProjectName = Get-SamplerProjectName -BuildRoot $BuildRoot
    $BinPath = "$Path/bin"

    if (-not (Test-Path -Path $Path)) {
        throw "Path '$Path' does not exist!"
    }

    # Remove bin folder if exists
    if (Test-Path -Path $BinPath) {
        Remove-Item -Path $BinPath -Recurse -Force
    }

    # For netstandard2.0, we use dotnet build (not publish) to avoid
    # including platform-specific runtime dependencies
    dotnet build $Path -c $Configuration

    # Resolve the expected output path directly to avoid picking the wrong framework folder.
    $BuildOutputDir = Join-Path -Path $BinPath -ChildPath "$Configuration/netstandard2.0"

    if (-not (Test-Path -Path $BuildOutputDir)) {
        throw "Build output directory (netstandard2.0) not found at '$BuildOutputDir'."
    }

    # Copy files to a directory that ModuleBuilder will pick up in build.yaml
    $StagingDir = "$BinPath/$ProjectName"
    New-Item -ItemType Directory $StagingDir -ErrorAction SilentlyContinue

    Get-ChildItem -Path $BuildOutputDir -File |
        Copy-Item -Destination $StagingDir -Force
}
