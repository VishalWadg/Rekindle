package com.rekindle.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CreateInterestRequest(
    @NotBlank(message = "Interest name cannot be blank")
    @Size(max = 100, message = "Interest name cannot exceed 100 characters")
    String name
) {}
