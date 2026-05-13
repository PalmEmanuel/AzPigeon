using System.Management.Automation;

namespace AzPigeon;

[Cmdlet(VerbsCommon.Get, "QueueMessage")]
public class GetQueueMessageCommand : PSCmdlet
{
    [Parameter(Mandatory = true)]
    public string QueueName { get; set; }
}
