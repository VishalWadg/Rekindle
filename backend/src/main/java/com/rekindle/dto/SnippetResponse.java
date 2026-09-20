package com.rekindle.dto;

import java.time.LocalDateTime;
import java.util.UUID;

public record SnippetResponse(
    UUID id,
    UUID interestId,
    String interestName,
    String content,
    LocalDateTime createdAt
) {}
