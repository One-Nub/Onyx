import 'dart:convert' show jsonEncode;

import 'package:nyxx/nyxx.dart' show NyxxRest, HttpResponseSuccess, Snowflake;
import 'package:onyx/onyx.dart';

typedef JsonData = Map<String, dynamic>;

/// Provides direct access to the slash command endpoints. OnyxSlash contains
/// additional extension methods alongside these endpoints.
class SlashEndpoints {
  NyxxRest restClient;

  SlashEndpoints(this.restClient);

  /// Returns all global commands for your application. Contains list of
  /// raw data for [SlashCommand] objects, which will be empty upon error or if no
  /// commands are registered.
  Future<List<JsonData>> getAllGlobalCommands() async {
    List<JsonData> cmds = [];

    var response = await restClient.httpEndpoints.sendRawRequest(
      "/applications/${restClient.app.id}/commands", "GET");

    if (response.runtimeType == HttpResponseSuccess) {
      response = response as HttpResponseSuccess;
      List<dynamic> rawDataList = response.jsonBody;

      if(rawDataList.isNotEmpty) {
        rawDataList.forEach((element) => cmds.add(element));
      }
    }

    return cmds;
  }

  /// Publishes a command to Discord, overwriting any old command with the same name.
  ///
  /// Sets the values for command ID and application ID on the [command] object.
  Future<void> createGlobalCommand(SlashCommand command) async {
    var response = await restClient.httpEndpoints.sendRawRequest(
      "/applications/${restClient.app.id}/commands", "POST", body: command.toJson());

    if(response is HttpResponseSuccess) {
      Snowflake cmdID = Snowflake(int.parse(response.jsonBody["id"]));

      command.registerCommandData(cmdID, restClient.app.id);
    }
  }

  /// Returns raw data of a synced [SlashCommand] based on a given [commandID].
  ///
  /// An empty map will be returned in the event of an error with sending.
  Future<JsonData> getGlobalCommand(int commandID) async {
    var response = await restClient.httpEndpoints.sendRawRequest(
      "/applications/${restClient.app.id}/commands/$commandID", "GET");

    if(response is HttpResponseSuccess) {
      return response.jsonBody;
    } else {
      return {};
    }
  }

  /// Edit a global command. Returns the updated data of the application command object. Empty map will
  /// be returned if unsuccessful.
  ///
  /// Requires a valid [SlashCommand] with a [commandID] of the command that will be updated.
  /// In the event that the [SlashCommand] has a valid ID already associated with it,
  /// that ID will override any passed [commandID].
  Future<JsonData> editGlobalCommand(SlashCommand command, {int? commandID}) async {
    //TODO: Implement logging to complain in the event both of these are null.
    if(commandID == null && command.id == null) return {};

    if(command.id != null) commandID = command.id!.id;

    var response = await restClient.httpEndpoints.sendRawRequest(
      "/applications/${restClient.app.id}/commands/$commandID", "PATCH",
      body: command.toJson());

    if(response is HttpResponseSuccess) {
      return response.jsonBody;
    } else {
      return {};
    }
  }

  /// Delete a global command. Returns true upon success.
  Future<bool> deleteGlobalCommand(int commandID) async {
    var response = await restClient.httpEndpoints.sendRawRequest(
      "/applications/${restClient.app.id}/commands/$commandID", "DELETE");

    if(response is HttpResponseSuccess) {
      return response.statusCode == 204;
    } else {
      return false;
    }
  }

  /// Overwrites all global commands at once.
  ///
  /// Any command not included will be removed, any commands with matching names
  /// will be overridden with the one sent from here. Send an empty array to
  /// delete all global commands. A list of the commands that were made/overridden
  /// will be returned.
  Future<List<JsonData>> bulkOverwriteGlobalCommands(List<SlashCommand> commands) async {
    //TODO: Decide if the endpoints class should handle registering info to command
    // or to abstract that out to OnyxSlash. For now this will handle that.

    List<JsonData> resultingList = [];

    var response = await restClient.httpEndpoints.sendRawRequest(
      "/applications/${restClient.app.id}/commands", "PUT", body: jsonEncode(commands));

    if(response is HttpResponseSuccess) {
      List<dynamic> rawResponse = response.jsonBody;

      if(rawResponse.isNotEmpty) {
        for(JsonData rawCommand in rawResponse) {
          SlashCommand thisCommand = commands.firstWhere(
            (element) => element.name == rawCommand["name"]);
          thisCommand.registerCommandData(Snowflake(int.parse(rawCommand["id"])),
            restClient.app.id);
        }
      }
    }

    return resultingList;
  }

  // // --------------------- Guild Commands --------------------- //

  /// Get all guild specific commands for a [guildID].
  Future<List<JsonData>> getAllGuildCommands(int guildID) async {
    List<JsonData> guildCmds = [];
    var response = await restClient.httpEndpoints.sendRawRequest(
      "/applications/${restClient.app.id}/guilds/$guildID/commands", "GET");

    if(response is HttpResponseSuccess) {
      List<dynamic> rawResponseList = response.jsonBody;

      if(rawResponseList.isNotEmpty) {
        rawResponseList.forEach((element) => guildCmds.add(element));
      }
    }
    return guildCmds;
  }

  /// Create a command that will only in exist in [guildID].
  ///
  /// Currently registers relevant command data as well.
  Future<void> createGuildCommand(SlashCommand command, int guildID) async {
    var response = await restClient.httpEndpoints.sendRawRequest(
      "/applications/${restClient.app.id}/guilds/$guildID/commands", "POST", body: command.toJson());

    if(response is HttpResponseSuccess) {
      Snowflake cmdID = Snowflake(int.parse(response.jsonBody["id"]));

      command.registerCommandData(cmdID, restClient.app.id, guild_id: Snowflake(guildID));
    }
  }

  /// Get a singular command based on it's [commandID] for a [guildID].
  ///
  /// Returns an empty map in the event the command ID given
  /// does not exist in the given guild ID.
  Future<JsonData> getGuildCommand(int commandID, int guildID) async {
    var response = await restClient.httpEndpoints.sendRawRequest(
      "/applications/${restClient.app.id}/guilds/$guildID/commands/$commandID", "GET");

    if(response is HttpResponseSuccess) {
      return response.jsonBody;
    } else {
      return {};
    }
  }

  /// Edit a guild command. Returns the updated data of the application command object. Empty map will
  /// be returned if unsuccessful.
  ///
  /// Either [command] or a [commandID] is necessary. The ID (if present) set on [command]
  /// will take precedence over [commandID].
  Future<JsonData> editGuildCommand(SlashCommand command, int guildID, {int? commandID}) async {
    //TODO: Implement logging to complain in the event both of these are null.
    if(commandID == null && command.id == null) return {};

    if(command.id != null) commandID = command.id!.id;

    var response = await restClient.httpEndpoints.sendRawRequest(
      "/applications/${restClient.app.id}/guilds/$guildID/commands/$commandID", "PATCH",
      body: command.toJson());

    if(response is HttpResponseSuccess) {
      return response.jsonBody;
    } else {
      return {};
    }
  }

  /// Delete a guild command. Return value based upon if deletion was successful or not.
  Future<bool> deleteGuildCommand(int commandID, int guildID) async {
    var response = await restClient.httpEndpoints.sendRawRequest(
      "/applications/${restClient.app.id}/guilds/$guildID/commands/$commandID", "DELETE");

    if(response is HttpResponseSuccess) {
      return response.statusCode == 204;
    } else {
      return false;
    }
  }

  /// Overwrites all guild commands at once.
  ///
  /// This will replace the entire guild command list with only the commands present
  /// in [commands], excluding global commands.
  Future<List<JsonData>> bulkOverwriteGuildCommands(List<SlashCommand> commands, int guildID) async {
    //TODO: Further changes will be affected by decision in bulkOverwriteGlobal()

    List<JsonData> resultingList = [];

    var response = await restClient.httpEndpoints.sendRawRequest(
      "/applications/${restClient.app.id}/guilds/$guildID/commands", "PUT", body: jsonEncode(commands));

    if(response is HttpResponseSuccess) {
      List<dynamic> rawResponse = response.jsonBody;

      if(rawResponse.isNotEmpty) {
        for(JsonData rawCommand in rawResponse) {
          SlashCommand thisCommand = commands.firstWhere(
            (element) => element.name == rawCommand["name"]);
          thisCommand.registerCommandData(Snowflake(int.parse(rawCommand["id"])),
            restClient.app.id, guild_id: Snowflake(guildID));
        }
      }
    }

    return resultingList;
  }

  // // --------------------- Guild Command Permissions --------------------- //
}
