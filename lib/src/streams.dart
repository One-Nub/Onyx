import 'dart:async';

import './interactions/interaction.dart';

/// Contains event streams that can be listened to.
class OnyxStreams {
  /// Controller for the component interaction stream.
  ///
  /// It is likely that you will not need to use this unless you want
  /// to dispatch events manually.
  StreamController<Interaction> componentController = StreamController.broadcast();

  /// Controller for the autocomplete interaction stream.
  ///
  /// It is likely that you will not need to use this unless you want
  /// to dispatch events manually.
  StreamController<Interaction> autocompleteController = StreamController.broadcast();

  /// Controller for the modal response stream.
  ///
  /// It is likely that you will not need to use this unless you want
  /// to dispatch events manually.
  StreamController<Interaction> modalController = StreamController.broadcast();

  /// Stream consisting of component interactions.
  static late Stream<Interaction> componentStream;

  /// Stream consisting of autocomplete interactions.
  static late Stream<Interaction> autocompleteStream;

  /// Stream consisting of modal submission interactions.
  static late Stream<Interaction> modalStream;

  OnyxStreams() {
    componentStream = componentController.stream;
    autocompleteStream = autocompleteController.stream;
    modalStream = modalController.stream;
  }
}
