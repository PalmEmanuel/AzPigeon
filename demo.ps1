# Generate C# project
dotnet new classlib -n AzPigeon -o ./source/ -f netstandard2.0

# Migrate SLN file to SLNX
dotnet sln AzPigeon.sln migrate

# Add PowerShell SDK
dotnet add ./source/AzPigeon.csproj package PowerShellStandard.Library --version 5.1.*