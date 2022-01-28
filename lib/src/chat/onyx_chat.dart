import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx/src/core/message/message.dart';
import 'package:logging/logging.dart';

import 'structures/text_command.dart';
import 'structures/text_context.dart';
import 'structures/text_subcommand.dart';

typedef PrefixHandlerFunction = FutureOr<String?> Function(String);

final _onyxLogger = Logger("Onyx");

class OnyxChat {
  /// Regex used to split string along spaces, single quotes, and double quotes.
  ///
  /// Matches the text inbetween these zones rather than splitting around these zones.
  final _argsRegex = RegExp("'(.*?)'|\"(.*?)\"|\\S+");

  /// Nyxx client used for getting a message when dispatching a message.
  late INyxxRest _nyxxClient;

  /// Default prefix, utilized if prefixHandler is not passed.
  String? prefix;

  /// Function used to determine a prefix for a message.
  late PrefixHandlerFunction _prefixHandler;

  /// HashSet of all commands Onyx holds. Duplicates are dropped, leaving the original command.
  HashSet<TextCommand> commands = HashSet();

  /// Creates OnyxChat with the NyxxRest class for handling the sending of events.
  ///
  /// User needs to dispatch messages manually to [dispatchMessage] as the ID of
  /// the message received. A `prefix` or a `prefixHandler` function are required
  /// for using Onyx. `prefixHandler` takes precedence over `prefix` if both are
  /// passed.
  OnyxChat (INyxxRest nyxxClient, {this.prefix, PrefixHandlerFunction? prefixHandler}) {
    this._nyxxClient = nyxxClient;

    if(prefix == null && prefixHandler == null) {
      _onyxLogger.shout("A prefix or prefixHandler must be defined for Onyx to work!");
      exit(1);
    }

    if(prefix != null) {
      _prefixHandler = defaultPrefixHandler;
    }

    if(prefixHandler != null) {
      _prefixHandler = prefixHandler;
    }

    _onyxLogger.info("Onyx is ready.");
  }

  /// Adds a singular command to Onyx.
  void addCommand(TextCommand cmd) {
    commands.add(cmd);
  }

  /// Adds a list of commands to Onyx.
  void addCommandList(List<TextCommand> cmdList) {
    commands.addAll(cmdList);
  }

  /// Default handler used if a custom one is not passed upon creation.
  ///
  /// Utilizes [prefix] to determine the prefix for a command.
  FutureOr<String?> defaultPrefixHandler(String message) async {
    if(message.startsWith(prefix!)) {
      return prefix!;
    } else {
      return null;
    }
  }

  /// Dispatches a raw Message object to trigger a Command and/or it's Subcommand.
  ///
  /// Utilizes Nyxx's built in Message object to build from raw.
  /// This then forwards to [dispatchIMessage] once the message has been built.
  ///
  /// [messagePrefix] can be passed if the prefix has already been determined for
  /// this specific message.
  Future<void> dispatchRawMessage(Map<String, dynamic> rawJson, {String? messagePrefix}) async {
    Message convertedMessage = Message(_nyxxClient, rawJson);

    this.dispatchIMessage(convertedMessage, messagePrefix: messagePrefix);
  }

  /// Dispatches an IMessage to trigger a Command and/or it's Subcommand.
  ///
  /// [messagePrefix] can be passed if the prefix has already been determined for
  /// this specific message.
  Future<void> dispatchIMessage(IMessage message, {String? messagePrefix}) async {
    ITextChannel textChannel = await message.channel.getOrDownload();

     // Get message and parse for prefix. Stop execution if there's no prefix.
    String messageContent = message.content;
    // Determine prefix if not null
    messagePrefix ??= await _prefixHandler(messageContent);
    if(messagePrefix == null) return;

    // Remove prefix and split message into list. Parse command name string. Stop
    // if message content is empty after removing prefix.
    messageContent = messageContent.replaceFirst(messagePrefix, "").trim();
    if(messageContent.isEmpty) return;
    List<String> msgList = messageContent.split(" ");

    // Get a matching command.
    String cmdName = msgList.removeAt(0);
    TextCommand? matchingCommand = _parseCommand(cmdName);
    if(matchingCommand == null) return;

    // Get a matching subcommand
    TextSubcommand? matchingSubcommand;
    if(msgList.isNotEmpty && matchingCommand.subcommands != null &&
      matchingCommand.subcommands!.isNotEmpty) {
        String subCmdName = msgList.removeAt(0);
        matchingSubcommand = _parseSubcommand(subCmdName, matchingCommand);
    }

    IGuild? messageGuild;
    if(textChannel is ITextGuildChannel) {
      messageGuild = await textChannel.guild.getOrDownload();
    }

    TextCommandContext context = TextCommandContext(_nyxxClient, message.author, await message.channel.getOrDownload(),
      "$messagePrefix$cmdName ${matchingSubcommand?.name ?? ""}".trim(), messageGuild, message);

    //Needed to parse out args list since msgList only splits on spaces.
    String finalMessage = message.content.replaceFirst(
        ("$messagePrefix$cmdName ${matchingSubcommand?.name ?? ""}").trim(), "");

    List<String> argsList = [];
    if(finalMessage.isNotEmpty) {
      List<RegExpMatch> regexMatchList = _argsRegex.allMatches(finalMessage).toList();
      regexMatchList.forEach((element) {
        String finalMatch = element.group(0)!;
        if(finalMatch.startsWith("'")) finalMatch = element.group(1)!;
        if(finalMatch.startsWith("\"")) finalMatch = element.group(2)!;

        argsList.add(finalMatch);
      });
    }

    String commandLogString = "Message dispatching to Command: ${matchingCommand.name}";
    if(matchingSubcommand != null) {
      commandLogString += ", Subcommand: ${matchingSubcommand.name}";
    }
    _onyxLogger.info(commandLogString);
    if(matchingSubcommand != null) {
      matchingSubcommand.commandEntry(context, messageContent, argsList);
    }
    else {
      matchingCommand.commandEntry(context, messageContent, argsList);
    }
  }

  /// Parses a command from a given Command name.
  TextCommand? _parseCommand(String commandName) {
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

  /// Parses a Subcommand from a given Subcommand name and the parent Command.
  TextSubcommand? _parseSubcommand(String subCommandName, TextCommand parentCommand) {
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
