using System.Management.Automation;

namespace AzPigeon;

[Cmdlet(VerbsCommon.Get, "AzQueueMessage")]
public class GetQueueMessageCommand : AzQueueBaseCommand
{
    protected override void EndProcessing()
    {
        WriteObject(queueClient?.PeekMessage(stopProcessing.Token)?.Value);
    }
}
