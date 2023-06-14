import '../enums.dart';
import '../utilities/typedefs.dart';
import 'component_base.dart';

/// Represents a Select Menu component.
///
/// A select menu has five possible typings. [ComponentType.string_select], [ComponentType.user_select],
/// [ComponentType.role_select], [ComponentType.mentionable_select] and [ComponentType.channel_select].
/// The default is [ComponentType.string_select].
///
/// The [SelectMenu.options] value is only acceptable for a select menu of ComponentType.select_menu. All
/// other types have options provided by Discord.
///
/// https://discord.com/developers/docs/interactions/message-components#select-menus
class SelectMenu implements Component {
  /// The component type.
  late ComponentType type;

  /// Developer defined identifier for this selection menu.
  ///
  /// Limited to 100 characters at most.
  late String custom_id;

  /// The [SelectMenuOption]s that will be displayed for this Select Menu component.
  ///
  /// Limited to 25 options to choose from at most.
  late List<SelectMenuOption> options;

  /// Text that will appear if nothing is selected.
  ///
  /// Limited to 150 characters at most.
  String? placeholderText;

  /// Minimum number of values that can be selected.
  ///
  /// Default is 1, minimum is 0, maximum is 25.
  int? min_values;

  /// Maximum number of values that can be selected.
  ///
  /// Default is 1, maximum is 25.
  int? max_values;

  /// Disables the select menu.
  ///
  /// Disabled if true, enabled if false.
  late bool disabled;

  SelectMenu(
      {required this.custom_id,
      this.type = ComponentType.string_select,
      List<SelectMenuOption>? options,
      this.placeholderText,
      this.min_values,
      this.max_values,
      this.disabled = false}) {
    if (options != null) {
      this.options = options;
    } else {
      this.options = [];
    }
  }

  SelectMenu.fromJson(JsonData data) {
    custom_id = data["custom_id"];

    type = ComponentType.fromInt(data["type"]);

    options = [];
    (data["options"] as List).forEach((element) {
      options.add(SelectMenuOption.fromJson(element));
    });

    placeholderText = data["placeholder"];
    min_values = data["min_values"];
    max_values = data["max_values"];

    if (data["disabled"] == null) {
      disabled = false;
    } else {
      disabled = data["disabled"];
    }
  }

  /// Add an [option] to this Select Menu.
  void addOption(SelectMenuOption option) => options.add(option);

  JsonData toJson() {
    JsonData finalData = {"type": type.value, "custom_id": custom_id, "disabled": disabled};

    // Only add options list to a string-based select_menu.
    if (type == ComponentType.string_select) {
      List<JsonData> optionsList = [];
      options.forEach((element) => optionsList.add(element.toJson()));
      finalData["options"] = optionsList;
    }

    if (placeholderText != null) finalData["placeholder"] = placeholderText;

    if (min_values != null) finalData["min_values"] = min_values;

    if (max_values != null) finalData["max_values"] = max_values;

    return finalData;
  }
}

/// An option for a [SelectMenu] component.
///
/// https://discord.com/developers/docs/interactions/message-components#select-menu-object-select-option-structure
class SelectMenuOption {
  /// The name of this option that users will see.
  ///
  /// 100 characters at most.
  late String label;

  /// Developer defined value for this option.
  ///
  /// 100 characters as most.
  late String value;

  /// An additional description for this option.
  ///
  /// 100 characters at most.
  String? description;

  /// A partial emoji that will be shown with this option.
  ///
  /// Partial emojis consist of the `id`, `name`, and `animated` fields.
  /// https://discord.com/developers/docs/resources/emoji#emoji-object
  JsonData? emoji;

  /// Will show this option as selected by default if true.
  bool? defaultSelection;

  SelectMenuOption(
      {required this.label, required this.value, this.description, this.emoji, this.defaultSelection});

  SelectMenuOption.fromJson(JsonData data) {
    label = data["label"];
    value = data["value"];
    description = data["description"];
    emoji = data["emoji"];
    defaultSelection = data["default"];
  }

  JsonData toJson() {
    JsonData finalData = {"label": label, "value": value};

    if (description != null) finalData["description"] = description;

    if (emoji != null) finalData["emoji"] = emoji;

    if (defaultSelection != null) finalData["default"] = defaultSelection;

    return finalData;
  }

  @override
  String toString() {
    return "${toJson()}";
  }
}
