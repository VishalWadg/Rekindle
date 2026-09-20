package com.rekindle.controller;

import com.rekindle.dto.CreateSnippetRequest;
import com.rekindle.dto.SnippetResponse;
import com.rekindle.dto.UpdateSnippetRequest;
import com.rekindle.service.SnippetService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
@Tag(name = "Snippets", description = "Endpoints for managing thoughts, quotes, and notes")
public class SnippetController {

    private final SnippetService snippetService;

    @GetMapping("/interests/{interestId}/snippets")
    @Operation(summary = "Get snippets for an interest", description = "Retrieves all snippets categorized under the specified interest")
    public List<SnippetResponse> getSnippetsByInterest(@PathVariable UUID interestId) {
        return snippetService.getSnippetsByInterest(interestId);
    }

    @GetMapping("/snippets/{id}")
    @Operation(summary = "Get a single snippet by ID")
    public SnippetResponse getSnippetById(@PathVariable UUID id) {
        return snippetService.getSnippetById(id);
    }

    @PostMapping("/interests/{interestId}/snippets")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Create a snippet", description = "Adds a new thought or quote under a specific interest")
    public SnippetResponse createSnippet(
            @PathVariable UUID interestId,
            @Valid @RequestBody CreateSnippetRequest request) {
        return snippetService.createSnippet(interestId, request);
    }

    @PutMapping("/snippets/{id}")
    @Operation(summary = "Update a snippet", description = "Updates the content of an existing thought snippet")
    public SnippetResponse updateSnippet(
            @PathVariable UUID id,
            @Valid @RequestBody UpdateSnippetRequest request) {
        return snippetService.updateSnippet(id, request);
    }

    @DeleteMapping("/snippets/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    @Operation(summary = "Delete a snippet", description = "Permanently deletes a thought snippet")
    public void deleteSnippet(@PathVariable UUID id) {
        snippetService.deleteSnippet(id);
    }
}
