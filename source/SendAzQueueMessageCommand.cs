using System.Management.Automation;
namespace AzPigeon;

[Cmdlet(VerbsCommunications.Send, "AzQueueMessage")]
public class SendAzQueueBaseCommand : AzQueueBaseCommand
{
    [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, ValueFromPipeline = true)]
    [ValidateNotNullOrEmpty()]
    public string[]? Message { get; set; }

    protected override void ProcessRecord()
    {
        foreach(var msg in Message!)
        {
            WriteObject(queueClient?.SendMessage(msg, stopProcessing.Token)?.Value);
        }
    }
}
