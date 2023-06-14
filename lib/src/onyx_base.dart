import './enums.dart';
import './exceptions.dart';
import './interactions/interaction.dart';
import './interactions/interaction_data.dart';
import './streams.dart';

/// Primary interaction dispatcher.
///
/// Interactions can be dispatched via [dispatchInteraction] to its' respective stream, if
/// one exists, or a handler if one is accepted, or exists, for that type of interaction.
///
/// Application command, message component, and modal submissions allow for the registering
/// of a handler that would consume any event if there is a match.
///
/// Without a match or without a handler, like autocomplete interactions, they will be passed
/// towards their respective stream, excluding application commands, as defined in the
/// [interactionStreams] object, or via their respective static definitions on [OnyxStreams].
class Onyx {
  /// Map containing the handlers for application command interactions.
  ///
  /// The string portion is the name of the application command.
  ///
  /// Handler functions should be registered through [registerAppCommandHandler] rather than
  /// manually inserting it into the map.
  Map<String, Function> appCommandHandlers = {};

  /// Map containing the handlers for component interactions.
  ///
  /// The string portion is the custom_id of the component.
  /// Handler functions should be registered through [registerGenericComponentHandler] rather than
  /// manually inserting it into the map.
  Map<String, Function> genericComponentHandlers = {};

  /// Map containing the handlers for modal submission interactions.
  ///
  /// The string portion is the custom_id of the component.
  /// Handler functions should be registered through [registerGenericModalHandler] rather than
  /// manually inserting it into the map.
  Map<String, Function> genericModalHandlers = {};

  /// Map containing the handlers for autocomplete interactions.
  ///
  /// The string portion is the custom_id of the component.
  /// Handler functions should be registered through [registerGenericAutocompleteHandler] rather than
  /// manually inserting it into the map.
  Map<String, Function> genericAutocompleteHandlers = {};

  /// Initializes the component, autocomplete, and modal streams as defined in [OnyxStreams].
  OnyxStreams interactionStreams = OnyxStreams();

  /// Create an Onyx object.
  Onyx();

  /// Dispatch an incoming interaction to the Onyx process to then be handled as necessary.
  ///
  /// Application commands must have a handler that was registered into the [appCommandHandlers] map,
  /// where the name of the command in the interaction matches the name that was defined when registering
  /// the command into the [appCommandHandlers] map. Without a matching handler, the interaction
  /// will be dropped.
  ///
  /// Message component interactions will either be passed to a handler based upon the custom_id
  /// or streamed via [OnyxStreams.componentStream].
  ///
  /// Autocomplete interactions will either be passed to a handler based upon the custom_id
  /// or streamed via [OnyxStreams.autocompleteStream].
  ///
  /// Modal submission interactions will either be passed to a handler based upon the custom_id
  /// or streamed via [OnyxStreams.modalStream].
  void dispatchInteraction(Interaction interaction) {
    if (interaction.type == InteractionType.application_command) {
      ApplicationCommandData? commandData = interaction.data as ApplicationCommandData?;
      if (commandData == null) {
        throw UnsupportedError("The given application command interaction does not contain any data. "
            "This is unsupported when dispatching.");
      }

      String interactionName = commandData.name;
      if (appCommandHandlers.containsKey(interactionName)) {
        appCommandHandlers[interactionName]!(interaction);
      } else {
        throw HandlerNotFoundError(
            "No command handler was registered or found for the command ${interactionName}.");
      }
    } else if (interaction.type == InteractionType.message_component) {
      MessageComponentData? componentData = interaction.data as MessageComponentData?;
      if (componentData == null) {
        throw UnsupportedError("The given message component interaction does not contain any data. "
            "This is unsupported when dispatching.");
      }

      String? customID = componentData.custom_id;

      if (genericComponentHandlers.containsKey(customID)) {
        genericComponentHandlers[customID]!(interaction);
      } else {
        bool success = false;
        for (var key in genericComponentHandlers.keys) {
          if (customID.startsWith(key)) {
            success = true;
            genericComponentHandlers[key]!(interaction);
            break;
          }
        }

        if (!success) interactionStreams.componentController.add(interaction);
      }
    } else if (interaction.type == InteractionType.autocomplete) {
      ApplicationCommandData? autocompleteData = interaction.data as ApplicationCommandData?;
      if (autocompleteData == null) {
        throw UnsupportedError("The given autocomplete interaction does not contain any data. "
            "This is unsupported when dispatching.");
      }

      if (genericAutocompleteHandlers.containsKey(autocompleteData.name)) {
        genericAutocompleteHandlers[autocompleteData.name]!(interaction);
      } else {
        interactionStreams.autocompleteController.add(interaction);
      }
    } else if (interaction.type == InteractionType.modal_submit) {
      ModalSubmitData? modalData = interaction.data as ModalSubmitData?;
      if (modalData == null) {
        throw UnsupportedError("The given modal submit interaction does not contain any data. "
            "This is unsupported when dispatching.");
      }

      String? customID = modalData.custom_id;
      if (genericModalHandlers.containsKey(customID)) {
        genericModalHandlers[customID]!(interaction);
      } else {
        bool success = false;

        for (var key in genericModalHandlers.keys) {
          if (customID.startsWith(key)) {
            success = true;
            genericComponentHandlers[key]!(interaction);
            break;
          }
        }

        if (!success) interactionStreams.modalController.add(interaction);
      }
    } else {
      throw UnsupportedError("The given interaction type of ${interaction.type} is not "
          "accepted to be dispatched.");
    }
  }

  /// Register a command [handler] function to Onyx that will trigger for all
  /// application command interactions name of [name].
  void registerAppCommandHandler(String name, Function(Interaction) handler) {
    appCommandHandlers.update(name, (value) => handler, ifAbsent: () => handler);
  }

  /// Register a component [handler] function to Onyx that will trigger for all
  /// component interactions with a custom id that either matches or is prefixed
  /// with [customID].
  void registerGenericComponentHandler(String customID, Function(Interaction) handler) {
    genericComponentHandlers.update(customID, (value) => handler, ifAbsent: () => handler);
  }

  /// Register a modal submission [handler] function to Onyx that will trigger for all
  /// modal submission interactions with a custom id that either matches or is prefixed
  /// with [customID].
  void registerGenericModalHandler(String customID, Function(Interaction) handler) {
    genericModalHandlers.update(customID, (value) => handler, ifAbsent: () => handler);
  }

  /// Register an autocomplete [handler] function to Onyx that will trigger for all
  /// autocomplete interactions with a command name that matches the given [commandName].
  void registerGenericAutocompleteHandler(String commandName, Function(Interaction) handler) {
    genericAutocompleteHandlers.update(commandName, (value) => handler, ifAbsent: () => handler);
  }
}
