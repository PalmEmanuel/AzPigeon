Describe 'Azurite Integration Tests' -Tag 'Integration' {
    BeforeAll {
        $AzuriteLocation = Join-Path -Path $TestDrive -ChildPath 'azurite'
        
        if (-not (Get-Command -Name azurite -ErrorAction SilentlyContinue)) {
            throw 'Azurite is required for integration tests. Install azurite first.'
        }

        $ConnectionString = 'UseDevelopmentStorage=true'

        if (Test-Path $AzuriteLocation) {
            Remove-Item $AzuriteLocation -Recurse -Force -ErrorAction SilentlyContinue
        }

        New-Item -Path $AzuriteLocation -ItemType Directory -Force | Out-Null
        $AzuriteLocation = $AzuriteLocation

        $null = Start-ThreadJob -Name 'Azurite' -ScriptBlock {
            & azurite --silent --location $using:AzuriteLocation --skipApiVersionCheck
        }

        Start-Sleep -Milliseconds 1000
    }

    Context 'Queue message <Name>' {
        BeforeEach {
            $QueueName = "azpigeonit$([Guid]::NewGuid().ToString('N').Substring(0, 18))"

            $QueueUri = New-AzQueue -ConnectionString $ConnectionString -QueueName $QueueName
            $QueueUri | Should -Not -BeNullOrEmpty
        }

        It 'can send and peek the same message text' {
            $Message = [Guid]::NewGuid().ToString('N')
            $Receipt = Send-AzQueueMessage -ConnectionString $ConnectionString -QueueName $QueueName -Message $Message
            $Receipt.MessageId | Should -Not -BeNullOrEmpty

            $Peeked = Get-AzQueueMessage -ConnectionString $ConnectionString -QueueName $QueueName
            $Peeked.MessageText | Should -BeExactly $Message
        }
    }

    AfterAll {
        if ('Azurite') {
            Stop-Job -Name 'Azurite' -ErrorAction SilentlyContinue
            Remove-Job -Name 'Azurite' -ErrorAction SilentlyContinue
        }

        $AzuriteLocation = "$TestDrive/azurite"
        if ($AzuriteLocation -and (Test-Path $AzuriteLocation)) {
            Remove-Item $AzuriteLocation -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}