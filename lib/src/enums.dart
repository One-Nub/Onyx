/// Consists of accepted Application Command types.
enum ApplicationCommandType {
  /// A chat input type, also known as a slash command.
  chat_input(1),

  /// A command type generated from right clicking on a user.
  user(2),

  /// A command type generated from right clicking on a message.
  message(3);

  const ApplicationCommandType(this.value);
  final int value;

  factory ApplicationCommandType.fromInt(int value) {
    switch (value) {
      case 1:
        return ApplicationCommandType.chat_input;
      case 2:
        return ApplicationCommandType.user;
      case 3:
        return ApplicationCommandType.message;
      default:
        throw UnimplementedError("The type $value is not implemented as an application command type.");
    }
  }
}

/// Consists of accepted Application Command option types.
enum ApplicationCommandOptionType {
  sub_command(1),
  sub_command_group(2),
  string(3),
  integer(4),
  boolean(5),
  user(6),
  channel(7),
  role(8),
  mentionable(9),
  number(10),
  attachment(11);

  const ApplicationCommandOptionType(this.value);
  final int value;

  factory ApplicationCommandOptionType.fromInt(int value) {
    switch (value) {
      case 1:
        return ApplicationCommandOptionType.sub_command;
      case 2:
        return ApplicationCommandOptionType.sub_command_group;
      case 3:
        return ApplicationCommandOptionType.string;
      case 4:
        return ApplicationCommandOptionType.integer;
      case 5:
        return ApplicationCommandOptionType.boolean;
      case 6:
        return ApplicationCommandOptionType.user;
      case 7:
        return ApplicationCommandOptionType.channel;
      case 8:
        return ApplicationCommandOptionType.role;
      case 9:
        return ApplicationCommandOptionType.mentionable;
      case 10:
        return ApplicationCommandOptionType.number;
      case 11:
        return ApplicationCommandOptionType.attachment;
      default:
        throw UnimplementedError("The type $value is not implemented as an application command option type.");
    }
  }
}

/// Consists of accepted Button styles.
enum ButtonStyle {
  /// A burple colored button.
  primary(1),

  /// A gray, or neutral, colored button.
  secondary(2),

  /// A green colored button.
  success(3),

  /// A red colored button.
  danger(4),

  /// A gray, or neutral, colored button that links to a URL.
  link(5);

  const ButtonStyle(this.value);
  final int value;

  factory ButtonStyle.fromInt(int value) {
    switch (value) {
      case 1:
        return ButtonStyle.primary;
      case 2:
        return ButtonStyle.secondary;
      case 3:
        return ButtonStyle.success;
      case 4:
        return ButtonStyle.danger;
      case 5:
        return ButtonStyle.link;
      default:
        throw UnimplementedError("The type $value is not implemented as a button style.");
    }
  }
}

/// Consists of accepted Component types.
enum ComponentType {
  /// Container for other components to exist in.
  action_row(1),

  /// A button that users can click on.
  button(2),

  /// A menu with a set of defined text options that can be chosen from.
  string_select(3),

  /// User-provided input. Only works on modals.
  text_input(4),

  /// A menu that contains a list of users to choose from.
  user_select(5),

  /// A menu that contains a list of roles to choose from.
  role_select(6),

  /// A menu that contains a list of users and roles to choose from.
  mentionable_select(7),

  /// A menu that contains a list of channels to choose from.
  channel_select(8);

  const ComponentType(this.value);
  final int value;

  factory ComponentType.fromInt(int value) {
    switch (value) {
      case 1:
        return ComponentType.action_row;
      case 2:
        return ComponentType.button;
      case 3:
        return ComponentType.string_select;
      case 4:
        return ComponentType.text_input;
      case 5:
        return ComponentType.user_select;
      case 6:
        return ComponentType.role_select;
      case 7:
        return ComponentType.mentionable_select;
      case 8:
        return ComponentType.channel_select;
      default:
        throw UnimplementedError("The type $value is not implemented as a component type.");
    }
  }

  /// Determine if this is a select menu.
  bool get isSelectMenu {
    const SELECT_MENU_TYPES = [
      ComponentType.string_select,
      ComponentType.user_select,
      ComponentType.role_select,
      ComponentType.mentionable_select,
      ComponentType.channel_select
    ];

    return SELECT_MENU_TYPES.contains(this);
  }

  /// Determine if this is a button.
  bool get isButton => this == ComponentType.button;

  /// Determine if this is an action row.
  bool get isActionRow => this == ComponentType.action_row;

  /// Determine if this is a text input component.
  bool get isTextInput => this == ComponentType.text_input;
}

/// Consists of accepted Interaction types.
enum InteractionType {
  /// A ping interaction, only received from Discord.
  ping(1),
  application_command(2),
  message_component(3),
  autocomplete(4),
  modal_submit(5);

  const InteractionType(this.value);
  final int value;

  factory InteractionType.fromInt(int value) {
    switch (value) {
      case 1:
        return InteractionType.ping;
      case 2:
        return InteractionType.application_command;
      case 3:
        return InteractionType.message_component;
      case 4:
        return InteractionType.autocomplete;
      case 5:
        return InteractionType.modal_submit;
      default:
        throw UnimplementedError("The type $value is not implemented as an interaction type.");
    }
  }
}

/// Consists of accepted Interaction Response types.
enum InteractionResponseType {
  /// A PONG response, utilized for responding to PING interactions from Discord.
  pong(1),

  /// Respond with a message.
  message_response(4),

  /// Defer an interaction to be responded to later.
  defer_message_response(5),

  /// For components, defer so the original message can be edited later.
  defer_update_message(6),

  /// For components, edit the message that the component was attached to.
  update_message(7),

  /// Reply to an autocomplete interaction with some suggested choices to pick from.
  autocomplete_suggestions(8),

  /// Respond with a modal popup.
  modal(9);

  const InteractionResponseType(this.value);
  final int value;

  factory InteractionResponseType.fromInt(int value) {
    switch (value) {
      case 1:
        return InteractionResponseType.pong;
      case 4:
        return InteractionResponseType.message_response;
      case 5:
        return InteractionResponseType.defer_message_response;
      case 6:
        return InteractionResponseType.defer_update_message;
      case 7:
        return InteractionResponseType.update_message;
      case 8:
        return InteractionResponseType.autocomplete_suggestions;
      case 9:
        return InteractionResponseType.modal;
      default:
        throw UnimplementedError("The type $value is not implemented as an interaction response type.");
    }
  }
}

/// Consists of accepted Text Input styles.
enum TextInputStyle {
  /// A short text input field, fixed size at one line tall.
  short(1),

  /// A long text input field, can be resized.
  paragraph(2);

  const TextInputStyle(this.value);
  final int value;

  factory TextInputStyle.fromInt(int value) {
    switch (value) {
      case 1:
        return TextInputStyle.short;
      case 2:
        return TextInputStyle.paragraph;
      default:
        throw UnimplementedError("The type $value is not implemented as an text input style type.");
    }
  }
}
