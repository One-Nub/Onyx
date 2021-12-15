import 'package:nyxx/nyxx.dart';

class TextCommandContext {
  final IMessageAuthor author;

  final TextChannel channel;

  final NyxxRest client;

  final String commandTrigger;

  final Guild? guild;

  final Message message;

  TextCommandContext(this.client, this.author, this.channel, this.commandTrigger, this.guild, this.message);
}
