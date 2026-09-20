package com.rekindle.dto;

import java.time.LocalDateTime;
import java.util.UUID;

public record SurfaceResponse(
    UUID exposureId,
    UUID snippetId,
    UUID interestId,
    String interestName,
    String content,
    LocalDateTime createdAt
) {}
