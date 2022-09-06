import './enums.dart';
import './interactions/interaction.dart';
import './interactions/interaction_data.dart';
import './streams.dart';

class Onyx {
  Map<String, Function> appCommandHandlers = {};
  Map<String, Function> genericComponentHandlers = {};
  Map<String, Function> genericModalHandlers = {};

  OnyxStreams interactionStreams = OnyxStreams();

  Onyx();

  void dispatchInteraction(Interaction interaction) {
    if (interaction.type == InteractionType.application_command) {
      ApplicationCommandData? commandData = interaction.data as ApplicationCommandData?;
      if(commandData ==  null) {
        throw UnimplementedError("The given application command interaction does not contain any data. "
          "This is unsupported when dispatching.");
      }

      String interactionName = commandData.name;
      if (appCommandHandlers.containsKey(interactionName)) {
        appCommandHandlers[interactionName]!(interaction);
      } else {
        // error msg, no handler found
      }

    } else if (interaction.type == InteractionType.message_component) {
      MessageComponentData? componentData = interaction.data as MessageComponentData?;
      if(componentData == null) {
        throw UnimplementedError("The given message component interaction does not contain any data. "
          "This is unsupported when dispatching.");
      }

      String? customID = componentData.custom_id;
      if (customID != null && genericComponentHandlers.containsKey(customID)) {
        genericComponentHandlers[customID]!(interaction);
      } else {
        interactionStreams.componentController.add(interaction);
      }

    } else if (interaction.type == InteractionType.autocomplete) {
      interactionStreams.autocompleteController.add(interaction);

    } else if (interaction.type == InteractionType.modal_submit) {
      ModalSubmitData? modalData = interaction.data as ModalSubmitData?;
      if(modalData == null) {
        throw UnimplementedError("The given modal submit interaction does not contain any data. "
          "This is unsupported when dispatching.");
      }

      String? customID = modalData.custom_id;
      if (customID != null && genericModalHandlers.containsKey(customID)) {
        genericModalHandlers[customID]!(interaction);
      } else {
        interactionStreams.modalController.add(interaction);
      }

    } else {
      throw UnimplementedError("The given interaction type of ${interaction.type} is not "
        "accepted to be dispatched.");
    }
  }

  void registerAppCommandHandler(String name, Function(Interaction) handler) {
    appCommandHandlers.update(name, (value) => handler, ifAbsent: () => handler);
  }

  void registerGenericComponentHandler(String customID, Function(Interaction) handler) {
    genericComponentHandlers.update(customID, (value) => handler, ifAbsent: () => handler);
  }

  void registerGenericModalHandler(String customID, Function(Interaction) handler) {
    genericModalHandlers.update(customID, (value) => handler, ifAbsent: () => handler);
  }

}
