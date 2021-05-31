part of onyx;

typedef PrefixHandlerFunction = FutureOr<String?> Function(String);

final _onyxLogger = Logger("Onyx");

class Onyx {
  final _argsRegex = RegExp("'.*?'|\".*?\"|\S+");

  late NyxxRest _nyxxClient;
  String? prefix;
  late PrefixHandlerFunction _prefixHandler;

  HashSet<Command> commands = HashSet();

  /// Creates Onyx with the NyxxRest class for handling the sending of events.
  ///
  /// User needs to dispatch messages manually to [dispatchMessage] as the ID of
  /// the message received. A `prefix` or a `prefixHandler` function are required
  /// for using Onyx. `prefixHandler` takes precedence over `prefix` if both are
  /// passed.
  Onyx(NyxxRest nyxxClient, {this.prefix, PrefixHandlerFunction? prefixHandler}) {
    this._nyxxClient = nyxxClient;

    if(prefix == null && prefixHandler == null) {
      _onyxLogger.shout("A prefix or prefixHandler must be defined for Onyx to work!");
      return;
    }

    if(prefix != null) {
      _prefixHandler = defaultPrefixHandler;
    }

    if(prefixHandler != null) {
      _prefixHandler = prefixHandler;
    }

    _onyxLogger.info("Onyx is ready.");
  }

  void addCommand(Command cmd) {
    commands.add(cmd);
  }

  void addCommandList(List<Command> cmdList) {
    commands.addAll(cmdList);
  }


  FutureOr<String?> defaultPrefixHandler(String message) async {
    if(message.startsWith(prefix!)) {
      return prefix!;
    } else {
      return null;
    }
  }

  Future<void> dispatchMessage(int channelID, int messageID, {String? messagePrefix}) async {
    Message message =
      await _nyxxClient.httpEndpoints.fetchMessage(channelID.toSnowflake(), messageID.toSnowflake());

    // Get message and parse for prefix. Stop execution if there's no prefix.
    String messageContent = message.content;
    messagePrefix ??= await _prefixHandler(messageContent);
    if(messagePrefix == null) return;

    // Remove prefix and split message into list. Parse command name string. Stop
    // if message content is empty after removing prefix.
    messageContent = messageContent.replaceFirst(messagePrefix, "").trim();
    if(messageContent.isEmpty) return;
    List<String> msgList = messageContent.split(" ");

    // Get a matching command.
    String cmdName = msgList.removeAt(0);
    Command? matchingCommand = _parseCommand(cmdName);
    if(matchingCommand == null) return;

    // Get a matching subcommand
    Subcommand? matchingSubcommand;
    if(msgList.isNotEmpty && matchingCommand.subcommands != null &&
      matchingCommand.subcommands!.isNotEmpty) {
        String subCmdName = msgList.removeAt(0);
        matchingSubcommand = _parseSubcommand(subCmdName, matchingCommand);
    }

    Guild? msgGuild;
    if(message is GuildMessage) {
      msgGuild = await message.guild.getOrDownload();
    }

    CommandContext context = CommandContext(message.author, await message.channel.getOrDownload(),
      "$messagePrefix$cmdName ${matchingSubcommand?.name ?? ""}".trim(), msgGuild, message);

    //Needed to parse out args list since msgList only splits on spaces.
    String finalMessage = message.content.replaceFirst(
        "$messagePrefix$cmdName ${matchingSubcommand?.name ?? ""}", "").trim();

    List<String> argsList = [];
    if(finalMessage.isNotEmpty) {
      List<RegExpMatch> regexMatchList = _argsRegex.allMatches(finalMessage).toList();
      regexMatchList.forEach((element) => argsList.add(element.group(0)!));
    }

    _onyxLogger.info("Message dispatched to ${matchingCommand.name} ${matchingSubcommand?.name ?? ""}");
    if(matchingSubcommand != null) {
      matchingSubcommand.commandEntry(context, messageContent, argsList);
    }
    else {
      matchingCommand.commandEntry(context, messageContent, argsList);
    }
  }

  Command? _parseCommand(String commandName) {
    if(commands.isEmpty) return null;

    try {
      return commands.firstWhere((element) {
        return element.commandNames.contains(commandName);
      });
    }
    on StateError {
      return null;
    }
  }

  Subcommand? _parseSubcommand(String subCommandName, Command parentCommand) {
    if(parentCommand.subcommands == null) return null;
    if(parentCommand.subcommands!.isEmpty) return null;

    try {
      // Return subcommand where name is the first value in the splitmessage list
      return parentCommand.subcommands!.firstWhere(
        (element) => element.name == subCommandName);
    }
    on StateError {
      return null;
    }

  }
}
