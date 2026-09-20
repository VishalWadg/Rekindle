package com.rekindle.dto;

import jakarta.validation.constraints.NotBlank;

public record UpdateSnippetRequest(
    @NotBlank(message = "Content cannot be blank")
    String content
) {}
