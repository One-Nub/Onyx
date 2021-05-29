part of onyx;

class CommandContext {
  final IMessageAuthor author;

  final TextChannel channel;

  final String commandTrigger;

  final Guild? guildID;

  final Message message;

  CommandContext(this.author, this.channel, this.commandTrigger, this.guildID, this.message);
}