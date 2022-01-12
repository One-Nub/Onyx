import 'package:nyxx/nyxx.dart';

import '../http/slash_endpoints.dart';
import 'structures/slash_command.dart';

class OnyxSlash {
  late INyxxRest _nyxxClient;
  late SlashEndpoints rawHttpClient;
  List<SlashCommand> globalCommandsList = [];

  OnyxSlash(this._nyxxClient, List<SlashCommand> commandsList) {
    rawHttpClient = SlashEndpoints(_nyxxClient);
  }

  Future<void> bulkOverwriteGlobalCommands(List<SlashCommand> commands) async {
    // Since this is overwriting all globals, overwrite the stored list.
    globalCommandsList = commands;

    List<JsonData> returnedCommands = await rawHttpClient.bulkOverwriteGlobalCommands(commands);

    if (returnedCommands.isNotEmpty) {
      for (JsonData command in returnedCommands) {
        // Get matching command object
        SlashCommand thisCommand = globalCommandsList.firstWhere(
          (element) => element.name == command["name"]);

        // Register data for the command from discord.
        thisCommand.registerCommandData(Snowflake(int.parse(command["id"])),
          _nyxxClient.app.id);
      }
    }
  }

  /// Logically connect the command objects made with already created commands on Discord.
  ///
  /// This does not update or override any commands on the platform, as such with the introduction
  /// of a new command, it will need to be added. This simply assigns the proper command
  /// data with commands in the globalCommandsList. **This should be utilized after commands
  /// have been added to the globalCommandsList and/or updated in the event of name changes.**
  Future<void> syncGlobalCommands() async {
    List<JsonData> rawGlobalCmds = await rawHttpClient.getAllGlobalCommands();
    if (rawGlobalCmds.length != globalCommandsList.length) {
      //TODO: Adjust to logging implementation and/or throw exception.
      print("There was a mismatch of the number of global commands and local commands added. "
       "Make sure you have added all your commands and/or created them globally before syncing.");
    }

    for (JsonData rawCommand in rawGlobalCmds) {
      try {
        // Get the matching SlashCommand object.
        SlashCommand cmd = globalCommandsList.firstWhere((element) => element.name == rawCommand["name"]);

        // Register command data.
        cmd.registerCommandData(Snowflake(int.parse(rawCommand["id"])), _nyxxClient.app.id);

      } on StateError catch (exception) {
        //TODO: Adjust to proper logging method when implemented.
        print("There was an issue getting the matching local command for the global command ${rawCommand["name"]}; "
        "exception: $exception");

        continue;
      }
    }
  }

}
