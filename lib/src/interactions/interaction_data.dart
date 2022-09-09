import '../enums.dart';
import '../typedefs.dart';

/// Common base representing for all implementing InteractionData subclasses.
///
/// It ended up existing this way since between all interaction data instances there is
/// no common values within the payload per type.
/// https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-object-interaction-data
abstract class InteractionData {}

class ApplicationCommandData implements InteractionData {
  /// Invoked command ID
  late BigInt id;

  /// Invoked command name
  late String name;

  /// Invoked command type
  late ApplicationCommandType type;

  /// Resolved users, roles, channels, or attachments.
  JsonData? resolved;

  /// Parameters & their values from the user.
  List<ApplicationCommandOption>? options;

  /// ID of the guild the command is registered to.
  BigInt? guild_id;

  /// ID of the targeted user or message for a user or message command.
  BigInt? target_id;

  ApplicationCommandData.fromJson(JsonData payload) {
    this.id = BigInt.parse(payload["id"]);
    this.name = payload["name"];
    this.type = ApplicationCommandType.fromInt(payload["type"]);

    this.resolved = payload["resolved"];

    if(payload["options"] != null) {
      options = [];
      (payload["options"] as List).forEach((element) {
        options!.add(ApplicationCommandOption.fromJson(element));
      });
    }

    if(payload["guild_id"] != null) {
      this.guild_id = BigInt.parse(payload["guild_id"]);
    }

    if(payload["target_id"] != null) {
      this.target_id = BigInt.parse(payload["target_id"]);
    }
  }

  @override
  String toString() {
    return "id: $id\n"
      "name: $name\n"
      "type: $type:${type.value}\n"
      "resolved: $resolved\n"
      "options: $options\n"
      "guild_id: $guild_id\n"
      "target_id: $target_id";
  }
}

class ApplicationCommandOption {
  late String name;
  late ApplicationCommandOptionType type;
  dynamic? value;
  List<ApplicationCommandOption>? options;
  late bool focused;

  ApplicationCommandOption.fromJson(JsonData payload) {
    name = payload["name"];
    type = ApplicationCommandOptionType.fromInt(payload["type"]);
    value = payload["value"];

    if(payload["options"] != null) {
      options = [];
      (payload["options"] as List).forEach((element) {
        options!.add(ApplicationCommandOption.fromJson(element));
      });
    }

    if(payload["focused"] == null) {
      focused = false;
    } else {
      focused = payload["focused"];
    }
  }

  @override
  String toString() {
    return "name: $name\n"
      "type: $type\n"
      "value: $value\n"
      "options: $options\n"
      "focused: $focused";
  }
}

class MessageComponentData implements InteractionData {
  /// The custom ID of a modal or message component.
  String? custom_id;

  /// For message components, the type of the component ran.
  ComponentType? component_type;

  /// Selected values from a select menu message component.
  List<dynamic>? values;

  MessageComponentData.fromJson(JsonData payload) {
    this.custom_id = payload["custom_id"];

    if(payload["component_type"] != null) {
      this.component_type = ComponentType.fromInt(payload["component_type"]);
    }

    this.values = payload["values"];
  }

  @override
  String toString() {
    return "custom_id: $custom_id\n"
      "component_type: $component_type\n"
      "values: $values";
  }
}

class ModalSubmitData implements InteractionData {
  /// The custom ID of a modal or message component.
  String? custom_id;

  /// Values submitted by a user from a modal.
  List<dynamic>? components;

  ModalSubmitData.fromJson(JsonData payload) {
    this.custom_id = payload["custom_id"];
    this.components = payload["components"];
  }

  @override
  String toString() {
    return "custom_id: $custom_id\n"
      "components: $components";
  }
}
