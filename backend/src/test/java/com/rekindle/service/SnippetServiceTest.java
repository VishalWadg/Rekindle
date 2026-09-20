package com.rekindle.service;

import com.rekindle.dto.CreateSnippetRequest;
import com.rekindle.dto.SnippetResponse;
import com.rekindle.dto.UpdateSnippetRequest;
import com.rekindle.entity.Interest;
import com.rekindle.entity.Snippet;
import com.rekindle.mapper.SnippetMapper;
import com.rekindle.repository.SnippetRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mapstruct.factory.Mappers;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class SnippetServiceTest {

    @Mock
    private SnippetRepository snippetRepository;

    @Mock
    private InterestService interestService;

    private SnippetMapper snippetMapper;
    private SnippetService snippetService;

    @BeforeEach
    void setUp() {
        snippetMapper = Mappers.getMapper(SnippetMapper.class);
        snippetService = new SnippetService(snippetRepository, interestService, snippetMapper);
    }

    @Test
    @DisplayName("getSnippetsByInterest should return mapped snippets when interest exists")
    void getSnippetsByInterest_WhenInterestExists_ReturnsSnippets() {
        UUID interestId = UUID.randomUUID();
        Interest interest = new Interest("physics");
        interest.setId(interestId);

        Snippet snippet = new Snippet(interest, "Energy cannot be created or destroyed.");
        snippet.setId(UUID.randomUUID());

        when(interestService.findEntityById(interestId)).thenReturn(interest);
        when(snippetRepository.findByInterestId(interestId)).thenReturn(List.of(snippet));

        List<SnippetResponse> results = snippetService.getSnippetsByInterest(interestId);

        assertThat(results).hasSize(1);
        assertThat(results.get(0).interestId()).isEqualTo(interestId);
        assertThat(results.get(0).interestName()).isEqualTo("physics");
        assertThat(results.get(0).content()).isEqualTo("Energy cannot be created or destroyed.");
    }

    @Test
    @DisplayName("createSnippet should associate with parent interest and save")
    void createSnippet_SavesSnippet() {
        UUID interestId = UUID.randomUUID();
        Interest interest = new Interest("psychology");
        interest.setId(interestId);

        CreateSnippetRequest request = new CreateSnippetRequest("Thinking, Fast and Slow");

        when(interestService.findEntityById(interestId)).thenReturn(interest);

        Snippet saved = new Snippet(interest, "Thinking, Fast and Slow");
        saved.setId(UUID.randomUUID());
        when(snippetRepository.save(any(Snippet.class))).thenReturn(saved);

        SnippetResponse result = snippetService.createSnippet(interestId, request);

        assertThat(result.interestName()).isEqualTo("psychology");
        assertThat(result.content()).isEqualTo("Thinking, Fast and Slow");
        verify(snippetRepository).save(any(Snippet.class));
    }

    @Test
    @DisplayName("updateSnippet should update content and save")
    void updateSnippet_UpdatesContent() {
        UUID snippetId = UUID.randomUUID();
        Interest interest = new Interest("art");
        interest.setId(UUID.randomUUID());

        Snippet snippet = new Snippet(interest, "Old content");
        snippet.setId(snippetId);

        when(snippetRepository.findById(snippetId)).thenReturn(Optional.of(snippet));
        when(snippetRepository.save(any(Snippet.class))).thenAnswer(inv -> inv.getArgument(0));

        SnippetResponse result = snippetService.updateSnippet(snippetId, new UpdateSnippetRequest("  New trimmed content  "));

        assertThat(result.content()).isEqualTo("New trimmed content");
        verify(snippetRepository).save(snippet);
    }

    @Test
    @DisplayName("deleteSnippet should throw 404 when snippet not found")
    void deleteSnippet_WhenNotFound_ThrowsException() {
        UUID id = UUID.randomUUID();
        when(snippetRepository.existsById(id)).thenReturn(false);

        assertThatThrownBy(() -> snippetService.deleteSnippet(id))
                .isInstanceOf(ResponseStatusException.class)
                .satisfies(ex -> assertThat(((ResponseStatusException) ex).getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND));

        verify(snippetRepository, never()).deleteById(id);
    }
}
