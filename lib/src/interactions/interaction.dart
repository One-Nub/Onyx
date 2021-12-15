import 'package:nyxx/nyxx.dart';

import 'interaction_data.dart';

class Interaction {
  late Snowflake id;
  late Snowflake application_id;
  late int type;
  InteractionData? data;
  Snowflake? guild_id;
  Snowflake? channel_id;
  Member? member;
  User? user;
  late String token;
  late int version;
  Message? message;

  Interaction(this.id, this.application_id, this.type, this.data, this.guild_id, this.channel_id, this.member, this.user, this.token, this.version, this.message);

  Interaction.fromRawJson(Map<String, dynamic> payload, INyxx client) {
    this.id = Snowflake(payload["id"] as int);
    this.application_id = Snowflake(payload["application_id"] as int);
    this.type = payload["type"] as int;
    this.guild_id = payload["guild_id"] ?? null;
    this.channel_id = payload["channel_id"] ?? null;
    this.token = payload["token"];
    this.version = payload["version"] as int;

    if(payload.containsKey("data")) {
      this.data = InteractionData.fromJson(payload["data"]);
    }

    if(payload.containsKey("member")) {
      this.member = EntityUtility.createGuildMember(client, guild_id!, payload["member"]);
    }
    else if(payload.containsKey("user")) {
      this.user = EntityUtility.createUser(client, payload["user"]);
    }

    if(payload.containsKey("message")) {
      this.message = EntityUtility.createMessage(client, payload["message"]);
    }
  }
}