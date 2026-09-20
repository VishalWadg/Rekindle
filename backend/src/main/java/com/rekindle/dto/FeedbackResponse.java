package com.rekindle.dto;

import java.time.LocalDateTime;
import java.util.UUID;

public record FeedbackResponse(
    UUID exposureId,
    String reaction,
    LocalDateTime respondedAt,
    UUID interestId,
    int updatedAlpha,
    int updatedBeta
) {}
