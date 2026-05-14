using System.Management.Automation;

namespace AzPigeon;

[Cmdlet(VerbsCommon.New, "AzQueue")]
public class NewAzQueueCommand : AzQueueBaseCommand
{
    protected override void BeginProcessing()
    {
        if (string.IsNullOrWhiteSpace(QueueName))
        {
            throw new Exception("Creating a queue can only be done with QueueName!");
        }
        base.BeginProcessing();
    }

	protected override void EndProcessing()
	{
		queueClient?.CreateIfNotExists(cancellationToken: stopProcessing.Token);
		WriteObject(queueClient?.Uri);
	}
}
