enum NotificationPermissionState {
  granted,
  denied,
  unknown,
}

enum NotificationLevel {
  off,
  rare,
  gentle,
  more,
}

enum NotificationVoice {
  calm,
  playful,
}

enum DeliveryWindow {
  morning, // 08:00 - 12:00
  afternoon, // 12:00 - 17:00
  evening, // 17:00 - 21:00
}

enum SnippetSource {
  onboarding,
  manual,
  notificationReply,
  importSource,
}

enum ExposureKind {
  snippet,
  interestCheck,
  offer,
  choice,
  capturePrompt,
}

enum ExposureChannel {
  inApp,
  push,
}

enum Reaction {
  none,
  keep,
  skip,
  explore,
  yes,
  notNow,
  less,
  captured,
  pickA,
  pickB,
  neither,
  expired,
}

enum RespondedVia {
  notificationAction,
  notificationTap,
  inApp,
}
