import 'package:nyxx/nyxx.dart' show Snowflake;

import 'slash_option.dart';

/// Base slash command, used to create commands that will then be registered on discord.
/// 
/// This is intended to be used where the user will extend this class, override
/// the variables, and implement commandFunction().
abstract class SlashCommand {
  /// Command name. Must be lowercase, 1-32 characters, and match `^[\w-]{1,32}$`
  late String name;

  /// Description for the command. 1-100 characters.
  late String description;
  
  /// Parameters for the command. 25 allowed at most.
  List<SlashOption>? options;

  /// Sets if the command will be available when the bot is added to a guild.
  late bool defaultEnabled;

  /// Create a slash command object using the defined class variables.
  SlashCommand();

  /// This method will be the entry point of the program when a slash command is triggered.
  Future<void> commandFunction();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "name": name,
      "description": description,
      "default_permission": defaultEnabled
    };
    
    if(options != null) 
      data["options"] = options;
    
    return data;
  }
}

/// The command object that discord returns once a command is registered.
class ApplicationCommand {
  Snowflake id;
  Snowflake application_id;
  Snowflake? guild_id;
  late String name;
  late String description;

  SlashCommand baseSlashCommand;

  ApplicationCommand(this.id, this.application_id, this.guild_id, this.baseSlashCommand) {
    this.name = baseSlashCommand.name;
    this.description = baseSlashCommand.description;
  }
}

enum SlashCommandType {
  chat,
  user,
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
