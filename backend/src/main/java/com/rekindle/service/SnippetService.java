package com.rekindle.service;

import com.rekindle.dto.CreateSnippetRequest;
import com.rekindle.dto.SnippetResponse;
import com.rekindle.dto.UpdateSnippetRequest;
import com.rekindle.entity.Interest;
import com.rekindle.entity.Snippet;
import com.rekindle.mapper.SnippetMapper;
import com.rekindle.repository.SnippetRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class SnippetService {

    private final SnippetRepository snippetRepository;
    private final InterestService interestService;
    private final SnippetMapper snippetMapper;

    public List<SnippetResponse> getSnippetsByInterest(UUID interestId) {
        // Validate that parent interest exists
        interestService.findEntityById(interestId);
        List<Snippet> snippets = snippetRepository.findByInterestId(interestId);
        return snippetMapper.toResponseList(snippets);
    }

    public SnippetResponse getSnippetById(UUID id) {
        Snippet snippet = findEntityById(id);
        return snippetMapper.toResponse(snippet);
    }

    @Transactional
    public SnippetResponse createSnippet(UUID interestId, CreateSnippetRequest request) {
        Interest interest = interestService.findEntityById(interestId);
        Snippet snippet = snippetMapper.toEntity(request, interest);
        Snippet saved = snippetRepository.save(snippet);
        return snippetMapper.toResponse(saved);
    }

    @Transactional
    public SnippetResponse updateSnippet(UUID snippetId, UpdateSnippetRequest request) {
        Snippet snippet = findEntityById(snippetId);
        snippet.setContent(request.content().trim());
        Snippet updated = snippetRepository.save(snippet);
        return snippetMapper.toResponse(updated);
    }

    @Transactional
    public void deleteSnippet(UUID snippetId) {
        if (!snippetRepository.existsById(snippetId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Snippet not found with id: " + snippetId);
        }
        snippetRepository.deleteById(snippetId);
    }

    public Snippet findEntityById(UUID id) {
        return snippetRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Snippet not found with id: " + id));
    }
}
