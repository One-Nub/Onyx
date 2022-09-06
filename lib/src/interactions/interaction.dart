import '../enums.dart';
import '../typedefs.dart';
import '../metadata.dart';
import 'interaction_data.dart';

class Interaction with Metadata {
  late BigInt id;
  late BigInt application_id;
  late InteractionType type;
  InteractionData? data;
  BigInt? guild_id;
  BigInt? channel_id;
  JsonData? member;
  JsonData? user;
  late String token;
  late int version;
  JsonData? message;
  String? app_permissions;
  String? locale;
  String? guild_locale;

  Interaction(Map<String, dynamic> payload) {
    this.id = BigInt.parse(payload["id"]);
    this.application_id = BigInt.parse(payload["application_id"]);
    this.type = InteractionType.fromInt(payload["type"]);

    if(payload.containsKey("data")) {
      if (payload["data"].containsKey("id")) {
        this.data = ApplicationCommandData.fromJson(payload["data"]);
      } else if (payload["data"].containsKey("component_type")) {
        this.data = MessageComponentData.fromJson(payload["data"]);
      } else if (payload["data"].containsKey("components")) {
        this.data = ModalSubmitData.fromJson(payload["data"]);
      }
    }

    if (payload["guild_id"] != null) {
      this.guild_id = BigInt.parse(payload["guild_id"]);
    }

    if (payload["channel_id"] != null) {
      this.channel_id = BigInt.parse(payload["channel_id"]);
    }

    if(payload.containsKey("member")) {
      this.member = payload["member"];
    }
    else if(payload.containsKey("user")) {
      this.user = payload["user"];
    }

    this.token = payload["token"];
    this.version = payload["version"];

    if(payload.containsKey("message")) {
      this.message = payload["message"];
    }

    if(payload.containsKey("app_permissions")) {
      this.app_permissions = app_permissions;
    }

    if(payload.containsKey("locale")) {
      this.locale = locale;
    }

    if(payload.containsKey("guild_locale")) {
      this.guild_locale = guild_locale;
    }
  }

  @override
  String toString() {
    return """Interaction ID: $id
      \tApplication ID: $application_id
      \tType: $type:${type.value}
      \tData: ${data.toString()}
      \tGuild ID: $guild_id
      \tChannel ID: $channel_id
      \tMember: $member
      \tUser: $user
      \tToken: $token
      \tVersion: $version
      \tMessage: $message
      \tApp permissions: $app_permissions
      \tLocale: $locale
      \tGuild locale: $guild_locale""";
  }
}
