import '../enums.dart';
import '../typedefs.dart';

/// Represents the data an interaction holds.
class InteractionData {
  /// Invoked command ID
  late BigInt id;

  /// Invoked command name
  late String name;

  /// Invoked command type
  late ApplicationCommandType type;

  /// Resolved users, roles, channels, or attachments.
  JsonData? resolved;

  /// Parameters & their values from the user.
  List<JsonData>? options;

  /// ID of the guild the command is registered to.
  BigInt? guild_id;

  /// ID of the targeted user or message for a user or message command.
  BigInt? target_id;

  /// The custom ID of a modal or message component.
  String? custom_id;

  /// For message components, the type of the component ran.
  int? component_type;

  /// Selected values from a select menu message component.
  List<JsonData>? values;

  /// Values submitted by a user from a modal.
  List<JsonData>? components;

  /// Initialize with data from a raw json map.
  InteractionData.fromJson(JsonData payload) {
    this.id = BigInt.parse(payload["id"]);
    this.name = payload["name"];
    this.type = ApplicationCommandType.fromInt(int.parse(payload["type"]));

    this.resolved = payload["resolved"];
    this.options = payload["options"];

    if(payload["guild_id"] != null) {
      this.guild_id = BigInt.parse(payload["guild_id"]);
    }

    if(payload["target_id"] != null) {
      this.target_id = BigInt.parse(payload["target_id"]);
    }

    this.custom_id = payload["custom_id"];
    this.component_type = payload["component_type"];
    this.values = payload["values"];
    this.components = payload["components"];
  }

  @override
  String toString() {
    return """[ID: $id
      Command name: $name
      Type: $type:${type.value}
      Resolved information: $resolved
      User options: $options
      Custom ID: $custom_id
      Component type: $component_type
      Option values: $values
      Target ID: $target_id]""";
  }
}
