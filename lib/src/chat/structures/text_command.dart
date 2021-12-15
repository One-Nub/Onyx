import 'dart:collection';

import 'text_context.dart';
import 'text_subcommand.dart';

abstract class TextCommand {
  late String name;
  late String? description;
  HashSet<String>? aliases;
  HashSet<TextSubcommand>? subcommands;

  /// Method that is executed when the command is triggered.
  ///
  /// [messageContent] is the entire message excluding the prefix.
  /// [args] is the entire message without the prefix and trigger string (found
  /// in [ctx]) split around spaces, leaving quoted strings intact (with quotes).
  Future<void> commandEntry(TextCommandContext ctx, String messageContent,
    List<String> args);

  HashSet<String> get commandNames {
    HashSet<String> names = HashSet();
    names.add(name);

    if (aliases != null) {
      names.addAll(aliases!);
    }

    return names;
  }

  @override
  bool operator ==(Object other) {
    return other is TextCommand && other.name == name;
  }
}

