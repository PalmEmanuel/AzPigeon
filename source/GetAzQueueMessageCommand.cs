using System.Management.Automation;

namespace AzPigeon;

[Cmdlet(VerbsCommon.Get, "AzQueueMessage")]
public class GetQueueMessageCommand : AzQueueMessageCommand
{
    protected override void EndProcessing()
    {
        WriteObject(queueClient?.PeekMessage()?.Value);
    }
}
