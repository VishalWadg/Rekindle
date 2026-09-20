package com.rekindle.controller;

import com.rekindle.dto.SurfaceResponse;
import com.rekindle.service.SuggestionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/surface")
@RequiredArgsConstructor
@Tag(name = "Surface", description = "Endpoints for surfacing rediscovery thoughts")
public class SurfaceController {

    private final SuggestionService suggestionService;

    @GetMapping
    @Operation(
            summary = "Surface a thought",
            description = "Surfaces a thought snippet using Thompson Sampling bandit weights and 24h Redis recency suppression"
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Successfully surfaced a thought"),
            @ApiResponse(responseCode = "204", description = "No eligible thoughts available to surface")
    })
    public ResponseEntity<SurfaceResponse> surface() {
        return suggestionService.suggestSnippet()
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.noContent().build());
    }
}
