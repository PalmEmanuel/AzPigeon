using System.Management.Automation;
using Azure.Identity;
using Azure.Storage.Queues;
namespace AzPigeon;

public abstract class AzQueueMessageCommand : PSCmdlet
{
    private protected CancellationTokenSource stopProcessing = new();
    private protected QueueClient? queueClient;


    [Parameter(Mandatory = true, ParameterSetName = "QueueUri")]
    public Uri? QueueUri { get; set; }

    [Parameter(Mandatory = true, ParameterSetName = "ConnectionString")]
    [ValidateNotNullOrEmpty]
    public string? ConnectionString { get; set; }

    [Parameter(Mandatory = true, ParameterSetName = "ConnectionString")]
    [ValidateNotNullOrEmpty]
    public string? QueueName { get; set; }

    protected override void BeginProcessing()
    {
        QueueClientOptions options = new()
        {
            MessageEncoding = QueueMessageEncoding.None
        };

        queueClient = ParameterSetName switch
        {
            "QueueUri" => new QueueClient(QueueUri, new DefaultAzureCredential(), options),
            "ConnectionString" => new QueueClient(ConnectionString, QueueName, options),
            _ => throw new PSInvalidOperationException($"Unknown parameter set '{ParameterSetName}'.")
        };
    }

    // Cancel any operations if user presses CTRL + C
    protected override void StopProcessing() => stopProcessing.Cancel();
}