import 'package:nyxx/nyxx.dart';

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

  InteractionData.fromJson(Map<String, dynamic> payload) {
    this.id = Snowflake(payload["id"] as int);
    this.name = payload["name"];
    this.type = payload["type"] as int;
    this.resolved = payload["resolved"];
    this.options = payload["options"];
    this.custom_id = payload["custom_id"];
    this.component_type = payload["component_type"] as int;
    this.values = payload["values"];
    this.target_id = payload["target_id"];
  }
}