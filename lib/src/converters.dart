part of onyx;

class OnyxConverter {
  OnyxConverter();

  static RegExp _discriminatorRegex = RegExp(r"#\d{4}$");

  static Future<Role?> getSingleRole(NyxxRest client, int guildID,
    {int? roleID, String? roleName}) async {
      Stream<Role> roleStream = client.httpEndpoints.fetchGuildRoles(Snowflake(guildID));
      Role? resultingRole = await roleStream.firstWhere((element) {
        return element.id == roleID || element.name == roleName;
      });

      return resultingRole;
  }

  static Future<Member?> getGuildMember(NyxxRest client, int guildID,
    {int? memberID, String? memberName}) async {
      return _getGuildMember(client, guildID, memberID: memberID, memberName: memberName)
        .catchError((_) => null);
  }

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
