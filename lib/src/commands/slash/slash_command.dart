import 'package:nyxx/nyxx.dart' show Snowflake;

import 'slash_option.dart';
import 'slash_permissions.dart';

/// Base slash command, used to create commands that will then be registered on discord.
///
/// This is intended to be used where the user will extend this class, override
/// the variables, and implement commandFunction().
class SlashCommand with ApplicationCommand {
  /// Command name. Must be lowercase, 1-32 characters, and match `^[\w-]{1,32}$`
  late String name;

  /// Description for the command. 1-100 characters.
  late String description;

  /// Parameters for the command. 25 allowed at most.
  List<SlashOption>? options;

  /// Sets if the command will be available when the bot is added to a guild.
  late bool defaultEnabled;

  /// Type of slash command
  late SlashCommandType type;

  /// Create a slash command object using the defined class variables.
  SlashCommand();

  /// This method will be the entry point of the program when a slash command is triggered.
  Future<void> commandFunction() async {}

  /// Generates json to be sent to Discord when registering a command.
  ///
  /// Even though discord does allow optionals for [defaultEnabled] and [type], Onyx
  /// requires these to be set when sending to Discord.
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "name": name,
      "description": description,
      "default_permission": defaultEnabled,
      "type": type.value
    };

    if(options != null)
      data["options"] = options;

    return data;
  }

  /// Print out a representation of the object in a string.
  /// Includes [ApplicationCommand] mixin values.
  @override
   String toString() {
     Map<String, dynamic> mixinVals = {
       "id": id,
       "application_id": application_id,
       "guild_id": guild_id,
       ...toJson()
     };

     return mixinVals.toString();
   }
}

mixin ApplicationCommand {
  /// Discord defined ID for the registered command.
  Snowflake? id;

  /// Discord defined ID for the application.
  Snowflake? application_id;

  /// ID of the guild that this command is registered in.
  Snowflake? guild_id;

  /// Attatches the information given by Discord to the ApplicatonCommand variables.
  /// This MUST be used prior to trying to access or utilize [id], [application_id], or
  /// the [guild_id] UNLESS defined by the user. This will overwrite any set values.
  void registerCommandData(Snowflake id, Snowflake application_id, {Snowflake? guild_id}) {
    this.id = id;
    this.application_id = application_id;
    if(guild_id != null)
      this.guild_id = guild_id;
  }
}

/// Types of a slash command that can exist.
enum SlashCommandType {
  /// Command triggered via chat with a "/".
  chat,
  /// Command found in the right click menu of a user.
  user,
  /// Command found in the right click menu of a command.
  message
}

extension SlashTypeValue on SlashCommandType {
  int get value {
    switch (this) {
      case SlashCommandType.chat:
        return 1;
      case SlashCommandType.user:
        return 2;
      case SlashCommandType.message:
        return 3;
    }
  }
}
