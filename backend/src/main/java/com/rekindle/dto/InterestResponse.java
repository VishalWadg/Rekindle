package com.rekindle.dto;

import java.time.LocalDateTime;
import java.util.UUID;

public record InterestResponse(
    UUID id,
    String name,
    int alpha,
    int beta,
    long snippetCount,
    LocalDateTime createdAt
) {}
