import '../enums.dart';
import '../utilities/typedefs.dart';

import '../components/action_row.dart';
import '../components/button.dart';
import '../components/component_base.dart';
import '../components/select_menu.dart';
import '../components/text_input.dart';

/// Common base representing for all implementing InteractionData subclasses.
///
/// It ended up existing this way since between all interaction data instances there is
/// no common values within the payload per type.
/// https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-object-interaction-data
abstract class InteractionData {}

/// Representation of application command data for an Interaction.
///
/// https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-object-application-command-data-structure
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

  /// Instantiate from a decoded JSON [payload].
  ApplicationCommandData.fromJson(JsonData payload) {
    this.id = BigInt.parse(payload["id"]);
    this.name = payload["name"];
    this.type = ApplicationCommandType.fromInt(payload["type"]);

    this.resolved = payload["resolved"];

    if (payload["options"] != null) {
      options = [];
      (payload["options"] as List).forEach((element) {
        options!.add(ApplicationCommandOption.fromJson(element));
      });
    }

    if (payload["guild_id"] != null) {
      this.guild_id = BigInt.parse(payload["guild_id"]);
    }

    if (payload["target_id"] != null) {
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

/// Representation of an application command option.
///
/// https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-object-application-command-interaction-data-option-structure
class ApplicationCommandOption {
  /// Parameter name
  late String name;

  /// The type of the option.
  late ApplicationCommandOptionType type;

  /// Value of the option from the user.
  ///
  /// Can be null, string, int, or double.
  dynamic value;

  /// Nested options if this option is a group or subcommand.
  List<ApplicationCommandOption>? options;

  /// True if this field is focused, used for autocompletion.
  late bool focused;

  ApplicationCommandOption.fromJson(JsonData payload) {
    name = payload["name"];
    type = ApplicationCommandOptionType.fromInt(payload["type"]);
    value = payload["value"];

    if (payload["options"] != null) {
      options = [];
      (payload["options"] as List).forEach((element) {
        options!.add(ApplicationCommandOption.fromJson(element));
      });
    }

    if (payload["focused"] == null) {
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

/// Representation of message component data for an Interaction.
///
/// https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-object-message-component-data-structure
class MessageComponentData implements InteractionData {
  /// The custom ID of a modal or message component.
  late String custom_id;

  /// For message components, the type of the component ran.
  late ComponentType component_type;

  /// Selected values from a select menu message component.
  List<String>? values;

  MessageComponentData.fromJson(JsonData payload) {
    this.custom_id = payload["custom_id"];

    if (payload["component_type"] != null) {
      this.component_type = ComponentType.fromInt(payload["component_type"]);
    }

    values = [...payload["values"]];
  }

  @override
  String toString() {
    return "custom_id: $custom_id\n"
        "component_type: $component_type\n"
        "values: $values";
  }
}

/// Representation of data that was submitted from a modal.
///
/// https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-object-modal-submit-data-structure
class ModalSubmitData implements InteractionData {
  /// The custom ID of a modal or message component.
  late String custom_id;

  /// Values submitted by a user from a modal.
  late List<Component> components;

  ModalSubmitData.fromJson(JsonData payload) {
    this.custom_id = payload["custom_id"];
    this.components = [];

    (payload["components"] as List).forEach((element) {
      var componentType = ComponentType.fromInt(element["type"]);

      // Although only text responses are supported rn, might as well cover all the bases
      // here for the future.
      if (componentType == ComponentType.action_row) {
        components.add(ActionRow.fromJson(element));
      } else if (componentType == ComponentType.button) {
        components.add(Button.fromJson(element));
      } else if (componentType == ComponentType.select_menu) {
        components.add(SelectMenu.fromJson(element));
      } else if (componentType == ComponentType.text_input) {
        components.add(TextInputResponse.fromJson(element));
      } else {
        throw UnimplementedError("A component type of $componentType is not supported yet!");
      }
    });
  }

  @override
  String toString() {
    return "custom_id: $custom_id\n"
        "components: $components";
  }
}
