using System.Management.Automation;

namespace AzPigeon;

[Cmdlet(VerbsCommunications.Read, "AzQueueMessage")]
public class ReadQueueMessageCommand : AzQueueBaseCommand
{
    protected override void EndProcessing()
    {
        WriteObject(queueClient?.PeekMessage(stopProcessing.Token)?.Value);
    }
}
