// ignore_for_file: constant_identifier_names

/// Status of subscription.
enum AutosaveState {
  IDLE, // as fallback on frontend.
  INIT, // db had just created sub. but mandate is still under process in sys.
  ACTIVE, // If auto save has been setup successfully.
  PAUSE_FROM_APP, // If as has been paused from app for week and month.
  PAUSE_FROM_APP_FOREVER, // If as has been paused from app forever.
  PAUSE_FROM_PSP, // If as has been paused from the psp app, mandate pause.
  CANCELLED; // If this payment is cancelled from psp or not completed by user.

  // If subscription is in paused state from any source.
  bool get isPaused =>
      this == AutosaveState.PAUSE_FROM_APP ||
      this == AutosaveState.PAUSE_FROM_APP_FOREVER ||
      this == AutosaveState.PAUSE_FROM_PSP;

  // If sub is active.
  bool get isActive => this == AutosaveState.ACTIVE;

  // If sub is initialized and mandate is still under process.
  bool get isInitialized => this == AutosaveState.INIT;

  // If it is cancelled.
  bool get isCancelled => this == AutosaveState.CANCELLED;
}
