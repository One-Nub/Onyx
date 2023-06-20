import '../enums.dart';
import '../utilities/typedefs.dart';
import '../utilities/metadata.dart';
import 'interaction_data.dart';

/// Represents an interaction received from Discord.
///
/// Discord documentation: https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-object-interaction-structure
class Interaction with Metadata {
  /// ID of this interaction.
  late BigInt id;

  /// The ID of the application this interaction is for.
  late BigInt application_id;

  /// The type of this interaction.
  late InteractionType type;

  /// The data payload of this interaction.
  ///
  /// This will exist for all interaction types, except PING interactions.
  InteractionData? data;

  /// ID of the guild where this interaction was sent from.
  BigInt? guild_id;

  /// ID of the channel where this interaction was sent from.
  BigInt? channel_id;

  /// Guild member data for the user who triggered this interaction event.
  ///
  /// Will be null if the interaction is not from a guild, as it is mutually
  /// exclusive with [user].
  JsonData? member;

  /// User data for the user who triggered this interaction event.
  ///
  /// Will be null if the interaction is from a guild, as it is mutually
  /// exclusive with [member].
  JsonData? user;

  /// Continuation token that is used for responding to this interaction.
  ///
  /// This is only used in cases where a follow-up event is required (deferring),
  /// or if interactions are being received over the gateway.
  late String token;

  /// Always 1, read only property.
  late int version;

  /// The source message that the components for this interaction were attached to.
  ///
  /// Will be null if this is not an interaction for a component.
  JsonData? message;

  /// Bitwise permission set the bot or app has within the channel that this interaction
  /// was sent from.
  String? app_permissions;

  /// Locale of the user invoking this interaction.
  String? locale;

  /// The preferred locale of the guild for this interaction.
  String? guild_locale;

  /// Create an Interaction from a decoded JSON [payload].
  Interaction(Map<String, dynamic> payload) {
    this.id = BigInt.parse(payload["id"]);
    this.application_id = BigInt.parse(payload["application_id"]);
    this.type = InteractionType.fromInt(payload["type"]);

    if (payload.containsKey("data")) {
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

    if (payload.containsKey("member")) {
      this.member = payload["member"];
    } else if (payload.containsKey("user")) {
      this.user = payload["user"];
    }

    this.token = payload["token"];
    this.version = payload["version"];

    if (payload.containsKey("message")) {
      this.message = payload["message"];
    }

    if (payload.containsKey("app_permissions")) {
      this.app_permissions = payload["app_permissions"];
    }

    if (payload.containsKey("locale")) {
      this.locale = payload["locale"];
    }

    if (payload.containsKey("guild_locale")) {
      this.guild_locale = payload["guild_locale"];
    }
  }

  @override
  String toString() {
    return "Interaction ID: $id\n"
        "Application ID: $application_id\n"
        "Type: $type:${type.value}\n"
        "Data: {${data}}\n"
        "Guild ID: $guild_id\n"
        "Channel ID: $channel_id\n"
        "Member: $member\n"
        "User: $user\n"
        "Token: $token\n"
        "Version: $version\n"
        "Message: $message\n"
        "App permissions: $app_permissions\n"
        "Locale: $locale\n"
        "Guild locale: $guild_locale";
  }
}
