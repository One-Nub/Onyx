import 'package:nyxx/nyxx.dart';

class TextCommandContext {
  final IMessageAuthor author;

  final ITextChannel channel;

  final INyxxRest client;

  final String commandTrigger;

  final IGuild? guild;

  final IMessage message;

  TextCommandContext(this.client, this.author, this.channel, this.commandTrigger, this.guild, this.message);
}
