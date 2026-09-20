package com.rekindle.dto;

import jakarta.validation.constraints.NotBlank;

public record CreateSnippetRequest(
    @NotBlank(message = "Content cannot be blank")
    String content
) {}
