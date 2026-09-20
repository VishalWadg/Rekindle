package com.rekindle.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public record FeedbackRequest(
    @NotBlank(message = "Reaction cannot be blank")
    @Pattern(regexp = "^(keep|skip|explore)$", message = "Reaction must be one of: 'keep', 'skip', or 'explore'")
    String reaction
) {}
