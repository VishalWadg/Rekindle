import 'enums.dart';

final class Interest {
  const Interest({
    required this.id,
    required this.name,
    required this.nameKey,
    this.alpha = 1.0,
    this.beta = 1.0,
    this.pushCooldownUntil,
    this.archivedAt,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String nameKey;
  final double alpha;
  final double beta;
  final DateTime? pushCooldownUntil;
  final DateTime? archivedAt;
  final DateTime createdAt;

  bool get isArchived => archivedAt != null;

  Interest copyWith({
    String? id,
    String? name,
    String? nameKey,
    double? alpha,
    double? beta,
    DateTime? pushCooldownUntil,
    DateTime? archivedAt,
    DateTime? createdAt,
  }) {
    return Interest(
      id: id ?? this.id,
      name: name ?? this.name,
      nameKey: nameKey ?? this.nameKey,
      alpha: alpha ?? this.alpha,
      beta: beta ?? this.beta,
      pushCooldownUntil: pushCooldownUntil ?? this.pushCooldownUntil,
      archivedAt: archivedAt ?? this.archivedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

final class Snippet {
  const Snippet({
    required this.id,
    required this.interestId,
    required this.content,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String interestId;
  final String content;
  final SnippetSource source;
  final DateTime createdAt;
  final DateTime updatedAt;
}

final class Exposure {
  const Exposure({
    required this.id,
    required this.interestId,
    this.snippetId,
    this.altInterestId,
    required this.kind,
    required this.templateCode,
    required this.copyVariant,
    required this.voice,
    required this.channel,
    this.notificationId,
    this.scheduledFor,
    required this.surfacedAt,
    this.expiresAt,
    this.deliveredAt,
    this.respondedAt,
    this.reaction = Reaction.none,
    this.respondedVia,
    this.responseText,
    this.planReason,
  });

  final String id;
  final String interestId;
  final String? snippetId;
  final String? altInterestId;
  final ExposureKind kind;
  final String templateCode;
  final String copyVariant;
  final NotificationVoice voice;
  final ExposureChannel channel;
  final int? notificationId;
  final DateTime? scheduledFor;
  final DateTime surfacedAt;
  final DateTime? expiresAt;
  final DateTime? deliveredAt;
  final DateTime? respondedAt;
  final Reaction reaction;
  final RespondedVia? respondedVia;
  final String? responseText;
  final Map<String, dynamic>? planReason;

  bool get isAnswered => reaction != Reaction.none;
}

final class NotificationSettings {
  const NotificationSettings({
    this.id = 1,
    this.level = NotificationLevel.gentle,
    this.windows = const {DeliveryWindow.morning, DeliveryWindow.evening},
    this.voice = NotificationVoice.calm,
    this.showTextOnLockScreen = false,
    this.pausedUntil,
    this.consecutiveIgnored = 0,
    this.backoffStep = 0,
    this.lastNudgeAt,
  });

  final int id;
  final NotificationLevel level;
  final Set<DeliveryWindow> windows;
  final NotificationVoice voice;
  final bool showTextOnLockScreen;
  final DateTime? pausedUntil;
  final int consecutiveIgnored;
  final int backoffStep;
  final DateTime? lastNudgeAt;

  NotificationSettings copyWith({
    int? id,
    NotificationLevel? level,
    Set<DeliveryWindow>? windows,
    NotificationVoice? voice,
    bool? showTextOnLockScreen,
    DateTime? pausedUntil,
    int? consecutiveIgnored,
    int? backoffStep,
    DateTime? lastNudgeAt,
  }) {
    return NotificationSettings(
      id: id ?? this.id,
      level: level ?? this.level,
      windows: windows ?? this.windows,
      voice: voice ?? this.voice,
      showTextOnLockScreen: showTextOnLockScreen ?? this.showTextOnLockScreen,
      pausedUntil: pausedUntil ?? this.pausedUntil,
      consecutiveIgnored: consecutiveIgnored ?? this.consecutiveIgnored,
      backoffStep: backoffStep ?? this.backoffStep,
      lastNudgeAt: lastNudgeAt ?? this.lastNudgeAt,
    );
  }
}

final class AppState {
  const AppState({
    this.id = 1,
    required this.installSeed,
    required this.timezone,
    this.onboardingCompletedAt,
    this.lastSeenAt,
    this.notificationPermission = NotificationPermissionState.unknown,
    this.permissionReaskDueAt,
    this.quietCardPending = false,
    this.insightsEnabled = true,
    this.plannerLastRunAt,
    this.appVersion = '0.2.0',
    required this.createdAt,
  });

  final int id;
  final int installSeed;
  final String timezone;
  final DateTime? onboardingCompletedAt;
  final DateTime? lastSeenAt;
  final NotificationPermissionState notificationPermission;
  final DateTime? permissionReaskDueAt;
  final bool quietCardPending;
  final bool insightsEnabled;
  final DateTime? plannerLastRunAt;
  final String appVersion;
  final DateTime createdAt;

  bool get isOnboardingCompleted => onboardingCompletedAt != null;
}

final class ResponseCommand {
  const ResponseCommand({
    required this.exposureId,
    required this.reaction,
    required this.via,
    this.text,
  });

  final String exposureId;
  final Reaction reaction;
  final RespondedVia via;
  final String? text;
}

final class ResponseResult {
  const ResponseResult({
    required this.applied,
    required this.reaction,
  });

  final bool applied;
  final Reaction reaction;
}

final class OnboardingDraft {
  const OnboardingDraft({
    this.selectedInterests = const [],
    this.memories = const {},
    this.level = NotificationLevel.gentle,
    this.windows = const {DeliveryWindow.morning, DeliveryWindow.evening},
    this.voice = NotificationVoice.calm,
    this.showTextOnLockScreen = false,
    this.requestFirstNudgeQuickly = false,
  });

  final List<String> selectedInterests;
  final Map<String, String> memories;
  final NotificationLevel level;
  final Set<DeliveryWindow> windows;
  final NotificationVoice voice;
  final bool showTextOnLockScreen;
  final bool requestFirstNudgeQuickly;

  OnboardingDraft copyWith({
    List<String>? selectedInterests,
    Map<String, String>? memories,
    NotificationLevel? level,
    Set<DeliveryWindow>? windows,
    NotificationVoice? voice,
    bool? showTextOnLockScreen,
    bool? requestFirstNudgeQuickly,
  }) {
    return OnboardingDraft(
      selectedInterests: selectedInterests ?? this.selectedInterests,
      memories: memories ?? this.memories,
      level: level ?? this.level,
      windows: windows ?? this.windows,
      voice: voice ?? this.voice,
      showTextOnLockScreen: showTextOnLockScreen ?? this.showTextOnLockScreen,
      requestFirstNudgeQuickly: requestFirstNudgeQuickly ?? this.requestFirstNudgeQuickly,
    );
  }
}
