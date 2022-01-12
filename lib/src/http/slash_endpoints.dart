import 'dart:convert' show jsonEncode;

// Library has a typo in "IHttpResponseSucess"
import 'package:nyxx/nyxx.dart' show INyxxRest, IHttpResponseSucess, Snowflake, IHttpResponseError;

import '../application/structures/slash_command.dart';
import '../application/structures/slash_permissions.dart';

typedef JsonData = Map<String, dynamic>;

/// Provides direct access to the slash command endpoints. OnyxSlash contains
/// additional extension methods alongside these endpoints.
class SlashEndpoints {
  INyxxRest restClient;

  SlashEndpoints(this.restClient);

  /// Returns all global commands for your application. Contains list of
  /// raw data for [SlashCommand] objects, which will be empty upon error or if no
  /// commands are registered.
  Future<List<JsonData>> getAllGlobalCommands() async {
    List<JsonData> cmds = [];

    var response = await restClient.httpEndpoints.sendRawRequest(
      "/applications/${restClient.app.id}/commands", "GET");

    if (response.runtimeType == IHttpResponseSucess) {
      response = response as IHttpResponseSucess;
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

    if(response is IHttpResponseSucess) {
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

    if(response is IHttpResponseSucess) {
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

    if(response is IHttpResponseSucess) {
      return response.jsonBody;
    } else {
      return {};
    }
  }

  /// Delete a global command. Returns true upon success.
  Future<bool> deleteGlobalCommand(int commandID) async {
    var response = await restClient.httpEndpoints.sendRawRequest(
      "/applications/${restClient.app.id}/commands/$commandID", "DELETE");

    if(response is IHttpResponseSucess) {
      return response.statusCode == 204;
    } else {
      return false;
    }
  }

  /// Overwrites all global commands at once.
  ///
  /// Any command not included will be removed, any commands with matching names
  /// will be overridden with the one sent from here. Send an empty array to
  /// delete all global commands. A raw list of the commands that were made/overridden
  /// will be returned.
  Future<List<JsonData>> bulkOverwriteGlobalCommands(List<SlashCommand> commands) async {
    List<JsonData> resultingList = [];

    var response = await restClient.httpEndpoints.sendRawRequest(
      "/applications/${restClient.app.id}/commands", "PUT", body: jsonEncode(commands));

    if(response is IHttpResponseSucess) {
      List<dynamic> rawResponse = response.jsonBody;

      if(rawResponse.isNotEmpty) {
        // Response is a list of command objects.
        for(JsonData rawCommand in rawResponse) {
          // Data registration is left to OnyxSlash or the user.
          resultingList.add(rawCommand);
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

    if(response is IHttpResponseSucess) {
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

    if(response is IHttpResponseSucess) {
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

    if(response is IHttpResponseSucess) {
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

    if(response is IHttpResponseSucess) {
      return response.jsonBody;
    } else {
      return {};
    }
  }

  /// Delete a guild command. Return value based upon if deletion was successful or not.
  Future<bool> deleteGuildCommand(int commandID, int guildID) async {
    var response = await restClient.httpEndpoints.sendRawRequest(
      "/applications/${restClient.app.id}/guilds/$guildID/commands/$commandID", "DELETE");

    if(response is IHttpResponseSucess) {
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

    if(response is IHttpResponseSucess) {
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

  // --------------------- Guild Command Permissions --------------------- //

  /// Get all permissions set for all commands (if any) in [guildID].
  Future<List<JsonData>> getAllGuildCommandPermissions(int guildID) async {
    List<JsonData> resultingList = [];

    var response = await restClient.httpEndpoints.sendRawRequest(
      "/applications/${restClient.app.id}/guilds/$guildID/commands/permissions", "GET");

    if(response is IHttpResponseSucess) {
      List<dynamic> responseData = response.jsonBody;

      if(responseData.isNotEmpty) {
        responseData.forEach((element) => resultingList.add(element));
      }
    }

    return resultingList;
  }

  /// Get the current permissions for [commandID] in [guildID].
  Future<JsonData> getGuildCommandPermissions(int guildID, int commandID) async {
    var response = await restClient.httpEndpoints.sendRawRequest(
      "/applications/${restClient.app.id}/guilds/$guildID/commands/$commandID/permissions", "GET");

    if(response is IHttpResponseSucess) {
      return response.jsonBody;
    } else {
      return {};
    }
  }

  /// Overwrite [permissions] for [commandID] in [guildID]. At most 10 permission
  /// overrides can be set on a single command in a guild.
  Future<JsonData> editGuildCommandPermissions(
    int guildID,
    int commandID,
    List<SlashPermission> permissions) async {

      List<JsonData> permissionData = [];
      permissions.forEach((element) => permissionData.add(element.toJson()));

      var response = await restClient.httpEndpoints.sendRawRequest(
      "/applications/${restClient.app.id}/guilds/$guildID/commands/$commandID/permissions", "PUT",
      body: {
        "permissions": permissionData
      });

      if(response is IHttpResponseSucess) {
        return response.jsonBody;
      } else {
        print(response);
        return {};
      }
  }

  /// Edits permissions for all commands in [guildID] (via override). Commands with
  /// no permission data set in [permissions] will have their permissions cleared.
  Future<List<JsonData>> editAllGuildCommandPermissions(
    int guildID,
    List<GuildCommandPermissions> permissions) async {
      List<JsonData> partialData = [];
      permissions.forEach((element) => partialData.add(element.buildPartial()));

      var response = await restClient.httpEndpoints.sendRawRequest(
        "/applications/${restClient.app.id}/guilds/$guildID/commands/permissions", "PUT",
        body: jsonEncode(partialData));

      if(response is IHttpResponseSucess) {
        // reponse.jsonBody is List<dynamic>, not List<JsonData> so
        // spreading values into a properly typed list works.
        List<JsonData> output = [...response.jsonBody];
        return output;
      } else {
        response = response as IHttpResponseError;
        return [];
      }
  }
}
