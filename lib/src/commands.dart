part of onyx;

abstract class Command {
  late String name;
  late String? description;
  HashSet<String>? aliases;
  HashSet<Subcommand>? subcommands;

  /// Method that is executed when the command is triggered.
  /// 
  /// [messageContent] is the entire message excluding the prefix.
  /// [args] is the entire message without the prefix and trigger string (found 
  /// in [ctx]) split around spaces, leaving quoted strings intact (with quotes).
  Future<void> commandEntry(CommandContext ctx, String messageContent, 
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
    return other is Command && other.name == name;
  }
}

abstract class Subcommand {
  late Command parentCommand;
  late String name;
  late String? description;

  Future<void> commandEntry(CommandContext ctx, String messageContent);

  @override
  bool operator ==(Object other) {
    return other is Subcommand && 
      other.name == name && 
      other.parentCommand == parentCommand;
  }
}
