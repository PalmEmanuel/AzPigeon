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

    dotnet publish $Path -c $Configuration

    # Get directories of compiled files
    $PublishDir = Get-ChildItem -Path $BinPath -Directory -Recurse -Filter publish

    if (-not (Test-Path -Path $PublishDir)) {
        throw "bin/<config>/netx.x directory not found under '$BinPath'."
    }

    # Copy files to a directory that ModuleBuilder will pick up in build.yaml
    $StagingDir = "$BinPath/$ProjectName"
    New-Item -ItemType Directory $StagingDir -ErrorAction SilentlyContinue

    Get-ChildItem $PublishDir -File |
        Where-Object { $_.Extension -in '.dll','.pdb' } |
        Select-Object -Unique -Property Name -ExpandProperty FullName |
        Copy-Item -Destination $StagingDir -Force
}
