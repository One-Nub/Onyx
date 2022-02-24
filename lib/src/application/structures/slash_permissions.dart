/// Representation of a single permission for a command.
class SlashPermission {
  /// ID of a role or user
  int id;

  /// Type defining if [id] corresponds to a role or user.
  SlashPermissionType type;

  /// Can the role or user ID use this command?
  bool permission;

  SlashPermission(this.id, this.type, this.permission);

  /// Generate a map/json representation of the object.
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type.value,
      "permission": permission
    };
  }
}

/// Representation of [SlashPermission]s for a SlashCommand in a guild.
class GuildCommandPermissions {
  /// ID of the command.
  int command_id;

  /// ID of the application the command belongs to.
  int? application_id;

  /// ID of the guild.
  int? guild_id;

  /// Permissions that are applied to this command [id] in [guild_id].
  ///
  /// Limit of 10 permissions total can be applied per guild. Anything over will
  /// error.
  List<SlashPermission> permissions = [];

  /// Creates a new command permissions object.
  ///
  /// [guild_id] and [application_id] are optional in the event that a user
  /// is creating solely partial command objects based on a known ID without
  /// getting info such as [guild_id] or the [application_id]. It is not suggested
  /// to intialize without these parameters.
  GuildCommandPermissions(this.command_id, {this.guild_id, this.application_id,
    List<SlashPermission>? permissions}) {
      if(permissions != null) {
        this.permissions = permissions;
      }
    }

  /// Generate partial JSON data to send a command to discord.
  ///
  /// Utilized for editing command permissions. Does not account for the
  /// possibility of over 10 permissions being applied to a command, which will
  /// cause batch permission editing to error, since only 10 permissions settings can be
  /// applied to a single command at once for a guild.
  Map<String, dynamic> buildPartial() {
    Map<String, dynamic> resultingData = {
      "id": this.command_id
    };
    List<Map<String, dynamic>> permissionData = [];
    permissions.forEach((element) => permissionData.add(element.toJson()));
    resultingData["permissions"] = permissionData;

    return resultingData;
  }
}

/// Represent the possible types a slash command permission can be applied to.
enum SlashPermissionType {
  role,
  user
}

/// Apply values to the specified permission types.
extension SlashPermissionTypeValues on SlashPermissionType {
  int get value {
    switch(this) {
      case SlashPermissionType.role:
        return 1;
      case SlashPermissionType.user:
        return 2;
    }
  }
}