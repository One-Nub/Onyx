import 'package:nyxx/nyxx.dart';

/// Represents the data an interaction holds from a raw perspective.
class InteractionData {
  /// Invoked command ID
  late Snowflake id;

  /// Invoked command name
  late String name;

  /// Invoked command type
  late int type;

  /// Resolved users, roles, and channels
  Map<String, dynamic>? resolved;

  /// Parameters & their values from the user
  List<Map<String, dynamic>>? options;

  /// For components, the custom ID.
  String? custom_id;

  /// For components, the type of the component ran.
  int? component_type;

  /// Selected value(s) from a select option component.
  List<Map<String, dynamic>>? values;

  /// ID of the targeted user or message for a user or message command.
  Snowflake? target_id;

  /// Initialize with data from a raw json map.
  InteractionData.fromJson(Map<String, dynamic> payload) {
    // No type casting normally because the map will already have types determined except for
    // this.id because the id in the payload is too long to be considered an int automatically?
    this.id = Snowflake(int.parse(payload["id"]));
    this.name = payload["name"];
    this.type = payload["type"];

    this.resolved = payload["resolved"];
    this.options = payload["options"];
    this.custom_id = payload["custom_id"];
    this.component_type = payload["component_type"];
    this.values = payload["values"];
    this.target_id = payload["target_id"];
  }

  @override
  String toString() {
    return "[ID: $id, Command name: $name, Type: $type, Resolved information: $resolved, "
      "User options: $options, Custom ID: $custom_id, Component type: $component_type, "
      "Option values: $values, Target ID: $target_id]";
  }
}
