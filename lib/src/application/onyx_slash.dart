import 'dart:collection';

import 'package:nyxx/nyxx.dart';

import '../http/slash_endpoints.dart';
import 'structures/slash_command.dart';

class OnyxSlash {
  late INyxxRest _nyxxClient;
  late SlashEndpoints rawHttpClient;
  List<SlashCommand> commandList = [];
  HashMap<int, List<SlashCommand>> guildCommandMap = HashMap();

  OnyxSlash(this._nyxxClient, List<SlashCommand> commandsList) {
    rawHttpClient = SlashEndpoints(_nyxxClient);
  }

  Future<void> bulkOverwrite(List<SlashCommand> commands, {int? guildID}) async {
    List<JsonData> returnedCommands = [];

    if (guildID == null) {
      commandList.clear();
      commandList.addAll(commands);

      returnedCommands = await rawHttpClient.bulkOverwriteGlobalCommands(commands);
    } else {
      // Remove map entry if clearing commands, create association otherwise.
      if (commands.isEmpty) {
        guildCommandMap.remove(guildID);
      } else {
        // Update the value if it exists, if absent, create with the same value.
        guildCommandMap.update(guildID, (value) => commands, ifAbsent: () => commands);
      }

      returnedCommands = await rawHttpClient.bulkOverwriteGuildCommands(commands, guildID);
    }

    if (returnedCommands.isEmpty) return;

    if (guildID == null) {
      for (JsonData command in returnedCommands) {
        // Get matching command object
        SlashCommand thisCommand = commandList.firstWhere(
          (element) => element.name == command["name"]);

        // Register data for the command from discord.
        thisCommand.registerCommandData(Snowflake(int.parse(command["id"])),
          _nyxxClient.appId);
      }
    } else {
      // By this point a guild entry is guaranteed to exist and not be empty.
      List<SlashCommand> guildCommandList = guildCommandMap[guildID]!;
      for (JsonData command in returnedCommands) {
        SlashCommand thisCommand = guildCommandList.firstWhere(
          (element) => element.name == command["name"]);

        // Register Discord given data for this command.
        thisCommand.registerCommandData(Snowflake(int.parse(command["id"])),
          _nyxxClient.appId);
      }
    }
  }

  /// Logically connect the command objects made with already created commands on Discord.
  ///
  /// This does not update or override any commands on the platform, so with the introduction
  /// of a new command, it will need to be added. This simply assigns the proper command
  /// data with commands in the respective command or guild command list.
  /// **This should be utilized after commands have been added to the command list
  /// and/or updated in the event of name changes.**
  Future<void> syncCommands({int? guildID}) async {
    if (guildID == null) {
      List<JsonData> rawGlobalCmds = await rawHttpClient.getAllGlobalCommands();

      for (JsonData rawCommand in rawGlobalCmds) {
        try {
          // Get the matching SlashCommand object.
          SlashCommand cmd = commandList.firstWhere((element) => element.name == rawCommand["name"]);

          // Register command data.
          cmd.registerCommandData(Snowflake(int.parse(rawCommand["id"])), _nyxxClient.appId);

        } on StateError catch (exception) {
          //TODO: Adjust to proper logging method when implemented.
          print("There was an issue getting the matching local command for the global command "
          "${rawCommand["name"]}; exception: $exception");

          continue;
        }
      }
    } else {
      List<JsonData> rawGuildCmds = await rawHttpClient.getAllGuildCommands(guildID);
      List<SlashCommand> guildCommands = guildCommandMap[guildID]!;

      for (JsonData rawGuildCommand in rawGuildCmds) {
        try {
          SlashCommand cmd = guildCommands.firstWhere((element) => element.name == rawGuildCommand["name"]);
          cmd.registerCommandData(Snowflake(int.parse(rawGuildCommand["id"])), _nyxxClient.appId,
            guild_id: Snowflake(guildID));
        } on StateError catch (exception) {
          //TODO: Adjust to proper logging method when implemented.
          print("There was an issue getting the matching local command for the guild command "
          "${rawGuildCommand["name"]} in guild $guildID; exception: $exception");

          continue;
        }
      }
    }
  }

}
