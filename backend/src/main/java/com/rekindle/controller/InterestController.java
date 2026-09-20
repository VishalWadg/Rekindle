package com.rekindle.controller;

import com.rekindle.dto.CreateInterestRequest;
import com.rekindle.dto.InterestResponse;
import com.rekindle.service.InterestService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/interests")
@RequiredArgsConstructor
@Tag(name = "Interests", description = "Endpoints for managing topics of interest")
public class InterestController {

    private final InterestService interestService;

    @GetMapping
    @Operation(summary = "Get all interests", description = "Retrieves all saved interests with their snippet counts and weights")
    public List<InterestResponse> getAllInterests() {
        return interestService.getAllInterests();
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get an interest by ID")
    public InterestResponse getInterestById(@PathVariable UUID id) {
        return interestService.getInterestById(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Create an interest", description = "Creates a new interest category with default beta-binomial prior (alpha=1, beta=1)")
    public InterestResponse createInterest(@Valid @RequestBody CreateInterestRequest request) {
        return interestService.createInterest(request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    @Operation(summary = "Delete an interest", description = "Deletes an interest and cascades deletion to all associated snippets")
    public void deleteInterest(@PathVariable UUID id) {
        interestService.deleteInterest(id);
    }
}
