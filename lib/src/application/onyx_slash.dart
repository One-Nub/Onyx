import 'package:nyxx/nyxx.dart';

import '../http/slash_endpoints.dart';
import 'structures/slash_command.dart';

class OnyxSlash {
  late NyxxRest _nyxxClient;
  late SlashEndpoints rawHttpClient;
  List<SlashCommand> globalCommandsList = [];

  OnyxSlash(this._nyxxClient, List<SlashCommand> commandsList) {
    rawHttpClient = SlashEndpoints(_nyxxClient);

  }

  Future<void> bulkUpdateGlobalCommands(List<SlashCommand> commands) async {
    ///TODO: Handle association of IDs to commands in list.
    
    // Since this is overwriting all globals, overwrite the stored list.
    globalCommandsList = commands;

    await rawHttpClient.bulkOverwriteGlobalCommands(commands);
  }


  Future<void> syncGlobalCommands() async {
    await rawHttpClient.getAllGlobalCommands();
  }
  
}
