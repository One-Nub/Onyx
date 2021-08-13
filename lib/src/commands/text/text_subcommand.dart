import 'text_command.dart';
import 'text_context.dart';

abstract class TextSubcommand {
  late TextCommand parentCommand;
  late String name;
  late String? description;

  Future<void> commandEntry(TextCommandContext ctx, String messageContent,
    List<String> args);

  @override
  bool operator ==(Object other) {
    return other is TextSubcommand &&
      other.name == name &&
      other.parentCommand == parentCommand;
  }
}