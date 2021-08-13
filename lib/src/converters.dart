import 'package:nyxx/nyxx.dart';

/// Contains all converters provided in Onyx.
class OnyxConverter {
  /// Constructor for a new OnyxConverter object, not necessary for accessing converter methods.
  OnyxConverter();

  /// Regex to get a discriminator. Utilized to remove discriminator in guild member name search.
  static RegExp _discriminatorRegex = RegExp(r"#\d{4}$");

  /// Gets a single role from the API based on a [roleID] or a [roleName] in a single [guildID].
  ///
  /// [debug] is used for determining the error if a role cannot be gotten. When it is
  /// true, `try, catch` the method or else it will terminate the execution of the method
  /// it is called inside.
  static Future<Role?> getSingleRole(NyxxRest client, int guildID,
    {int? roleID, String? roleName, bool debug: false}) async {
      if(roleID == null && roleName == null) return null;

      return await _getSingleRole(client, guildID, roleID: roleID, roleName: roleName)
        .catchError((_) => null, test: (_) => !debug);
  }

  /// Gets a single role from the API based on a [roleID] or a [roleName] in a single [guildID].
  ///
  /// Fetches all the roles in a guild and returns the first role where the role
  /// is the same as either the role ID or the role name.
  ///
  /// Contains all the logic necessary for the public method. This is separate
  /// since if it was all in the public method, it would not be possible
  /// to return null from the stream. This is due to non-nullable syntax on returning
  /// elements from an error case not allowing null as a value.
  static Future<Role?> _getSingleRole(NyxxRest client, int guildID,
    {int? roleID, String? roleName}) async {
      Stream<Role> roleStream = client.httpEndpoints.fetchGuildRoles(Snowflake(guildID));
      Role? resultingRole = await roleStream.firstWhere((element) {
        return element.id == roleID || element.name == roleName;
      });

      return resultingRole;
    }



  /// Gets a single guild member from the API based on a [memberID] or [memberName] in a [guildID].
  ///
  /// [debug] is used for determining the error if a Member cannot be gotten. When it is
  /// true, `try, catch` the method or else it will terminate the execution of the method
  /// it is called inside.
  static Future<Member?> getGuildMember(NyxxRest client, int guildID,
    {int? memberID, String? memberName, bool debug: false}) async {
      if(memberID == null && memberName == null) return null;

      return _getGuildMember(client, guildID, memberID: memberID, memberName: memberName)
        .catchError((_) => null, test: (_) => !debug);
  }


  /// Gets a single guild member from the API based on a [memberID] or [memberName] in a [guildID].
  ///
  /// First fetches for a guild member based on the ID, if not provided or null
  /// then searches for a guild member based on username & nickname. If that's
  /// null, returns null.
  ///
  /// Contains all the logic necessary for the public method. This is separate
  /// since if it was all in the public method, it would not be possible
  /// to return null from the stream. This is due to non-nullable syntax on returning
  /// elements from an error case not allowing null as a value.
  static Future<Member?> _getGuildMember(NyxxRest client, int guildID,
    {int? memberID, String? memberName}) async {
      Member? resultingMember;
      if(memberID != null) {
        resultingMember =
          await client.httpEndpoints.fetchGuildMember(Snowflake(guildID), Snowflake(memberID));
      }

      if(resultingMember == null && memberName != null) {
        memberName = memberName.replaceFirst(_discriminatorRegex, "");
        Stream<Member> memberStream = await
          client.httpEndpoints.searchGuildMembers(Snowflake(guildID), memberName);
        resultingMember = await memberStream.first;
      }

      return resultingMember;
    }
}
