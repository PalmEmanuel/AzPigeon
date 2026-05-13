# Generate C# project
dotnet new classlib -n AzPigeon -o ./source/ -f netstandard2.0

# Migrate SLN file to SLNX
dotnet sln AzPigeon.sln migrate

# Add PowerShell SDK
dotnet add ./source/AzPigeon.csproj package PowerShellStandard.Library --version 5.1.1
dotnet add ./source/AzPigeon.csproj package Azure.Storage.Queues --version 12.25.0
dotnet add ./source/AzPigeon.csproj package Azure.Identity --version 1.17.2

# Import Module and Test
$QueueUri = 'https://azpigeondemostg.queue.core.windows.net/demo'

Send-AzQueueMessage -QueueUri $QueueUri
Read-AzQueueMessage -QueueUri $QueueUri
Receive-AzQueueMessage -QueueUri $QueueUri