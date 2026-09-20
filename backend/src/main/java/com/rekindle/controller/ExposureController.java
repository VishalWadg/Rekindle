package com.rekindle.controller;

import com.rekindle.dto.FeedbackRequest;
import com.rekindle.dto.FeedbackResponse;
import com.rekindle.service.ExposureService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/exposures")
@RequiredArgsConstructor
@Tag(name = "Exposures", description = "Endpoints for recording thought rediscovery feedback")
public class ExposureController {

    private final ExposureService exposureService;

    @PostMapping("/{id}/feedback")
    @Operation(
            summary = "Record feedback for an exposure",
            description = "Updates exposure reaction (keep, skip, explore) and shifts parent interest Beta distribution weights"
    )
    public FeedbackResponse recordFeedback(
            @PathVariable UUID id,
            @Valid @RequestBody FeedbackRequest request) {
        return exposureService.recordFeedback(id, request);
    }
}
