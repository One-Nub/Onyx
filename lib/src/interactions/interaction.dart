import 'package:nyxx/nyxx.dart';
import 'package:nyxx/src/core/user/member.dart';
import 'package:nyxx/src/core/user/user.dart';
import 'package:nyxx/src/core/message/message.dart';

import 'interaction_data.dart';

class Interaction {
  late Snowflake id;
  late Snowflake application_id;
  late int type;
  InteractionData? data;
  Snowflake? guild_id;
  Snowflake? channel_id;
  IMember? member;
  IUser? user;
  late String token;
  late int version;
  IMessage? message;

  Interaction(this.id, this.application_id, this.type, this.data, this.guild_id, this.channel_id, this.member, this.user, this.token, this.version, this.message);

  Interaction.fromRawJson(Map<String, dynamic> payload, INyxx client) {
    this.id = Snowflake(int.parse(payload["id"]));
    this.application_id = Snowflake(int.parse(payload["application_id"]));
    this.type = payload["type"];

    if(payload.containsKey("data")) {
      this.data = InteractionData.fromJson(payload["data"]);
    }

    if (payload["guild_id"] != null) {
      this.guild_id = Snowflake(payload["guild_id"]);
    }

    if (payload["channel_id"] != null) {
      this.channel_id = Snowflake(payload["channel_id"]);
    }

    if(payload.containsKey("member")) {
      this.member = Member(client, payload["member"], guild_id!);
    }
    else if(payload.containsKey("user")) {
      this.user = User(client, payload["user"]);
    }

    this.token = payload["token"];
    this.version = payload["version"];

    if(payload.containsKey("message")) {
      this.message = Message(client, payload["message"]);
    }
  }

  @override
  String toString() {
    return "ID: $id, Application ID: $application_id, Type: $type, Data: ${data.toString()}, "
      "Guild ID: $guild_id, Channel ID: $channel_id, Member: $member, User: $user, "
      "Token: $token, Version: $version, Message: $message";
  }
}
