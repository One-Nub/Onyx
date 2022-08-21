enum ApplicationCommandType {
  chat_input(1),
  user(2),
  message(3);

  const ApplicationCommandType(this.value);
  final int value;

  factory ApplicationCommandType.fromInt(int value) {
    switch(value) {
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

enum ButtonStyle {
  primary(1),
  secondary(2),
  success(3),
  danger(4),
  link(5);

  const ButtonStyle(this.value);
  final int value;

  factory ButtonStyle.fromInt(int value) {
    switch(value) {
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

enum ComponentType {
  action_row(1),
  button(2),
  select_menu(3),
  text_input(4);

  const ComponentType(this.value);
  final int value;

  factory ComponentType.fromInt(int value) {
    switch(value) {
      case 1:
        return ComponentType.action_row;
      case 2:
        return ComponentType.button;
      case 3:
        return ComponentType.select_menu;
      case 4:
        return ComponentType.text_input;
      default:
        throw UnimplementedError("The type $value is not implemented as a component type.");
    }
  }
}

enum InteractionType {
  ping(1),
  application_command(2),
  message_component(3),
  autocomplete(4),
  modal_submit(5);

  const InteractionType(this.value);
  final int value;

  factory InteractionType.fromInt(int value) {
    switch(value) {
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

enum InteractionResponseType {
  pong(1),
  message_response(4),
  defer_message_response(5),
  defer_update_message(6),
  update_message(7),
  autcomplete_suggestions(8),
  modal(9);

  const InteractionResponseType(this.value);
  final int value;

  factory InteractionResponseType.fromInt(int value) {
    switch(value) {
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
        return InteractionResponseType.autcomplete_suggestions;
      case 9:
        return InteractionResponseType.modal;
      default:
        throw UnimplementedError("The type $value is not implemented as an interaction response type.");
    }
  }
}

enum TextInputStyle {
  short(1),
  paragraph(2);

  const TextInputStyle(this.value);
  final int value;

  factory TextInputStyle.fromInt(int value) {
    switch(value) {
      case 1:
        return TextInputStyle.short;
      case 2:
        return TextInputStyle.paragraph;
      default:
        throw UnimplementedError("The type $value is not implemented as an text input style type.");
    }
  }
}
