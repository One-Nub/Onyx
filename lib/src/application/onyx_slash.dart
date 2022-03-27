import 'dart:collection';

import 'package:nyxx/nyxx.dart';
import 'package:logging/logging.dart';

import '../http/slash_endpoints.dart';
import '../interactions/interaction.dart';

import 'structures/slash_command.dart';

/// Main point of utilizing Application Commands with Onyx.
class OnyxSlash {
  final Logger _onyxLog = Logger("Onyx");

  late INyxxRest _nyxxClient;
  late SlashEndpoints rawHttpClient;

  /// List of registered global command handlers.
  ///
  /// It is not recommended to add commands to this list manually without using the [registerCommand]
  /// method provided, but it is possible.
  List<SlashCommand> commandList = [];

  /// HashMap consisting of Guild IDs and Guild command lists for guild specific slash command handlers.
  ///
  /// It is not advised to add commands to this without using the [registerCommand] method
  /// due to the potential confusion factor.
  HashMap<int, List<SlashCommand>> guildCommandMap = HashMap();

  OnyxSlash(this._nyxxClient) {
    rawHttpClient = SlashEndpoints(_nyxxClient);
    _onyxLog.info("OnyxSlash has been started.");
  }

  /// Dispatch an [Interaction] from raw data returned from the api.
  ///
  /// Any desired [metadata] will be passed along the [Interaction] object.
  void dispatchRawInteraction(JsonData rawData, {dynamic metadata}) {
    Interaction interaction = Interaction.fromRawJson(rawData, this._nyxxClient);
    if(metadata != null) {
      interaction.setMetadata(metadata);
    }

    this.dispatchInteraction(interaction);
  }

  /// Dispatch an [Interaction] to registered command handlers within Onyx.
  void dispatchInteraction(Interaction interaction) {

    // Check for a guild command first.
    if (interaction.guild_id != null && guildCommandMap.containsKey(interaction.guild_id!.id)) {
      // If the guild has a command with a matching id, trigger.
      List<SlashCommand> dispGuildCmdList = guildCommandMap[interaction.guild_id!.id]!;
      SlashCommand? matchingGuildCommand = dispGuildCmdList.firstWhereSafe((element) => element.id == interaction.data!.id);

      if (matchingGuildCommand != null) {
        _onyxLog.info("Dispatching guild interaction \"${interaction.data!.name}\" for guild ${interaction.guild_id}");
        matchingGuildCommand.commandFunction(interaction);
        return;
      }
    }

    // Check global command list for matching id.
    SlashCommand? matchingGlobalCmd = commandList.firstWhereSafe((element) => element.id == interaction.data!.id);
    if (matchingGlobalCmd != null) {
        _onyxLog.info("Dispatching global interaction \"${interaction.data!.name}\"");
        matchingGlobalCmd.commandFunction(interaction);
        return;
    }

    // Check guild map for matching name of command.
    if (interaction.guild_id != null && interaction.data != null) {
      List<SlashCommand> dispGuildCmdList = guildCommandMap[interaction.guild_id!.id]!;
      SlashCommand? nameMatch = dispGuildCmdList.firstWhereSafe((element) => element.name == interaction.data!.name);
      if (nameMatch != null) {
        _onyxLog.info("Dispatching and registering data for guild interaction \"${interaction.data!.name}\" "
          "for guild ${interaction.guild_id}");
        nameMatch.commandFunction(interaction);
        nameMatch.registerCommandData(interaction.data!.id, interaction.application_id, guild_id: interaction.guild_id);
        return;
      }
    }

    // Check global list for matching name of command.
    if (interaction.data != null) {
      SlashCommand? matchingNameCmd = commandList.firstWhereSafe((element) => element.name == interaction.data!.name);

      if (matchingNameCmd != null) {
        _onyxLog.info("Dispatching and registering data for global interaction \"${interaction.data!.name}\"");
        matchingNameCmd.commandFunction(interaction);
        matchingNameCmd.registerCommandData(interaction.data!.id, interaction.application_id);
        return;
      }
    }

    _onyxLog.shout("No matching command was found for the interaction $interaction.");
  }

  /// Overwrite all commands on a global or guild scale.
  ///
  /// Any commands not included in the passed [commands] list will be removed.
  /// Automatically syncs data for the updated command, so there is no need to
  /// run [syncCommands] after a bulk overwrite.
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

    // Register command data.
    if (guildID == null) {
      for (JsonData command in returnedCommands) {
        // Get matching command object
        SlashCommand thisCommand = commandList.firstWhere(
          (element) =>
            element.name == command["name"] &&
            element.type.value == command["type"]
          );

        // Register data for the command from discord.
        thisCommand.registerCommandData(Snowflake(int.parse(command["id"])),
          _nyxxClient.appId);
      }
    } else {
      // By this point a guild entry is guaranteed to exist and not be empty.
      List<SlashCommand> guildCommandList = guildCommandMap[guildID]!;
      for (JsonData command in returnedCommands) {
        SlashCommand thisCommand = guildCommandList.firstWhere(
          (element) =>
            element.name == command["name"] &&
            element.type.value == command["type"]
          );

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
          SlashCommand cmd = commandList.firstWhere((element) =>
            element.name == rawCommand["name"] &&
            element.type.value == rawCommand["type"]
          );

          // Register command data.
          cmd.registerCommandData(Snowflake(int.parse(rawCommand["id"])), _nyxxClient.appId);

        } on StateError catch (exception) {
          _onyxLog.severe("There was an issue getting the matching local command for the global command "
          "${rawCommand["name"]}; exception: $exception");

          continue;
        }
      }
    } else {
      List<JsonData> rawGuildCmds = await rawHttpClient.getAllGuildCommands(guildID);
      List<SlashCommand> guildCommands = guildCommandMap[guildID]!;

      for (JsonData rawGuildCommand in rawGuildCmds) {
        try {
          SlashCommand cmd = guildCommands.firstWhere((element) =>
            element.name == rawGuildCommand["name"] &&
            element.type.value == rawGuildCommand["type"]
          );

          cmd.registerCommandData(Snowflake(int.parse(rawGuildCommand["id"])), _nyxxClient.appId,
            guild_id: Snowflake(guildID));
        } on StateError catch (exception) {
          _onyxLog.severe("There was an issue getting the matching local command for the guild command "
          "${rawGuildCommand["name"]} in guild $guildID; exception: $exception");

          continue;
        }
      }
    }
  }

  /// Register a local command with Onyx with the option to publish to Discord.
  ///
  /// If [publish] is true, the command will be uploaded to discord. It is recommended to only enable it when confident, or else
  /// the command will be uploaded every time the bot is ran - potentially causing rate limits or other issues. If [guildID] is present,
  /// the command will be associated directly with a guild, and uploaded as a guild specific command if [publish] is true.
  Future<void> registerCommand(SlashCommand command, {int? guildID, bool publish = false}) async {
    if (guildID == null) {
      commandList.add(command);
    } else {
      guildCommandMap.update(guildID, (value) => [...value, command], ifAbsent: () => [command]);
    }

    if (publish) {
      if (guildID == null) {
        await rawHttpClient.createGlobalCommand(command);
      } else {
        await rawHttpClient.createGuildCommand(command, guildID);
      }
    }
  }

  /// Update a command on the platform.
  ///
  /// Requires that a valid [commandID] exists, which will either be retrieved from [command]
  /// or chosen via the passed [commandID]. If [command] is synced and has registered data, it will
  /// override the ID passed by [commandID]. As such, this should preferably be run after
  /// command have been synced via [syncCommands].
  Future<void> editCommand(SlashCommand command, {int? guildID, int? commandID}) async {
    // Editing commands does not change the command ID, so no need to resync.
    if (guildID == null) {
      await rawHttpClient.editGlobalCommand(command, commandID: commandID);
    } else {
      await rawHttpClient.editGuildCommand(command, guildID, commandID: commandID);
    }
  }

  /// Remove a command listing from the platform either globally or in a [guildID].
  ///
  /// It is necessary to either have commands synced, or at least registered with OnyxSlash
  /// to have this function properly. In the event a [command] is synced, the ID of the
  /// command will overwrite a passed [commandID].
  Future<bool> deleteCommand(SlashCommand command, {int? guildID, int? commandID}) async {
    // Return if no way to know what command to delete...
    if (command.id == null && commandID == null) {
      _onyxLog.warning("A command ID is required when attempting to delete commands.");
      return false;
    }

    // Use passed SlashCommands ID if not null.
    if (command.id != null) commandID = command.id!.id;

    if (guildID == null) {
      commandList.remove(command);
      return await rawHttpClient.deleteGlobalCommand(commandID!);
    } else {
      guildCommandMap[guildID]!.remove(command);

      if (guildCommandMap[guildID]!.isEmpty) {
        guildCommandMap.remove(guildID);
      }

      return await rawHttpClient.deleteGuildCommand(commandID!, guildID);
    }
  }
}
