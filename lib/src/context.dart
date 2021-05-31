part of onyx;

class CommandContext {
  final IMessageAuthor author;

  final TextChannel channel;

  final NyxxRest client;

  final String commandTrigger;

  final Guild? guild;

  final Message message;

  CommandContext(this.client, this.author, this.channel, this.commandTrigger, this.guild, this.message);
}
