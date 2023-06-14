/// Error that is thrown when no matching generic handler is registered within Onyx.
///
/// Explicitly used for types where there is no matching stream for the interaction
/// to be dispatched upon.
///
/// This can be avoided by ensuring that there are handlers registered for all
/// application commands that your application may have.
class HandlerNotFoundError implements Exception {
  final String message;
  HandlerNotFoundError(this.message);
}
