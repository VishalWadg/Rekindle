package com.rekindle.service;

import com.rekindle.dto.SurfaceResponse;
import com.rekindle.entity.Exposure;
import com.rekindle.entity.Interest;
import com.rekindle.entity.Snippet;
import com.rekindle.repository.ExposureRepository;
import com.rekindle.repository.InterestRepository;
import com.rekindle.repository.SnippetRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.*;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class SuggestionServiceTest {

    @Mock
    private InterestRepository interestRepository;

    @Mock
    private SnippetRepository snippetRepository;

    @Mock
    private ExposureRepository exposureRepository;

    @Mock
    private RecencyCacheService recencyCacheService;

    private SuggestionService suggestionService;

    @BeforeEach
    void setUp() {
        suggestionService = new SuggestionService(
                interestRepository,
                snippetRepository,
                exposureRepository,
                recencyCacheService
        );
    }

    @Test
    @DisplayName("suggestSnippet should return empty when no eligible interests exist")
    void suggestSnippet_WhenNoEligibleInterests_ReturnsEmpty() {
        when(interestRepository.findEligibleInterests()).thenReturn(Collections.emptyList());

        Optional<SurfaceResponse> result = suggestionService.suggestSnippet();

        assertThat(result).isEmpty();
        verifyNoInteractions(exposureRepository);
        verifyNoInteractions(recencyCacheService);
    }

    @Test
    @DisplayName("suggestSnippet should select snippet, save exposure, and update Redis")
    void suggestSnippet_WhenEligible_SelectsSavesAndRecords() {
        UUID interestId = UUID.randomUUID();
        Interest interest = new Interest("stoicism");
        interest.setId(interestId);
        interest.setAlpha(5);
        interest.setBeta(2);

        UUID snippetId = UUID.randomUUID();
        Snippet snippet = new Snippet(interest, "Amor fati.");
        snippet.setId(snippetId);

        when(interestRepository.findEligibleInterests()).thenReturn(List.of(interest));
        when(recencyCacheService.getRecentlySeenSnippetIds()).thenReturn(Collections.emptySet());
        when(snippetRepository.findByInterestId(interestId)).thenReturn(List.of(snippet));

        UUID exposureId = UUID.randomUUID();
        when(exposureRepository.save(any(Exposure.class))).thenAnswer(inv -> {
            Exposure exp = inv.getArgument(0);
            exp.setId(exposureId);
            return exp;
        });

        Optional<SurfaceResponse> result = suggestionService.suggestSnippet();

        assertThat(result).isPresent();
        SurfaceResponse response = result.get();
        assertThat(response.exposureId()).isEqualTo(exposureId);
        assertThat(response.snippetId()).isEqualTo(snippetId);
        assertThat(response.interestName()).isEqualTo("stoicism");
        assertThat(response.content()).isEqualTo("Amor fati.");

        verify(exposureRepository).save(any(Exposure.class));
        verify(recencyCacheService).markSnippetAsSeen(snippetId);
    }

    @Test
    @DisplayName("suggestSnippet should filter out recently seen snippet IDs")
    void suggestSnippet_WhenRecentIdsPresent_FiltersOutSeenSnippets() {
        UUID interestId = UUID.randomUUID();
        Interest interest = new Interest("mindfulness");
        interest.setId(interestId);

        UUID recentId = UUID.randomUUID();
        UUID freshId = UUID.randomUUID();
        Snippet freshSnippet = new Snippet(interest, "Breathe in, breathe out.");
        freshSnippet.setId(freshId);

        when(interestRepository.findEligibleInterests()).thenReturn(List.of(interest));
        when(recencyCacheService.getRecentlySeenSnippetIds()).thenReturn(Set.of(recentId));
        when(snippetRepository.findByInterestIdAndIdNotIn(interestId, Set.of(recentId)))
                .thenReturn(List.of(freshSnippet));

        when(exposureRepository.save(any(Exposure.class))).thenAnswer(inv -> {
            Exposure exp = inv.getArgument(0);
            exp.setId(UUID.randomUUID());
            return exp;
        });

        Optional<SurfaceResponse> result = suggestionService.suggestSnippet();

        assertThat(result).isPresent();
        assertThat(result.get().snippetId()).isEqualTo(freshId);
        verify(recencyCacheService).markSnippetAsSeen(freshId);
    }

    @Test
    @DisplayName("suggestSnippet should fallback to all snippets if all snippets in winning topic were recently seen")
    void suggestSnippet_FallbackWhenAllSnippetsSeen() {
        UUID interestId = UUID.randomUUID();
        Interest interest = new Interest("music");
        interest.setId(interestId);

        UUID snippetId = UUID.randomUUID();
        Snippet snippet = new Snippet(interest, "Without music, life would be a mistake.");
        snippet.setId(snippetId);

        when(interestRepository.findEligibleInterests()).thenReturn(List.of(interest));
        when(recencyCacheService.getRecentlySeenSnippetIds()).thenReturn(Set.of(snippetId));
        // Filtering returns empty
        when(snippetRepository.findByInterestIdAndIdNotIn(interestId, Set.of(snippetId)))
                .thenReturn(Collections.emptyList());
        // Fallback returns the snippet
        when(snippetRepository.findByInterestId(interestId)).thenReturn(List.of(snippet));

        when(exposureRepository.save(any(Exposure.class))).thenAnswer(inv -> {
            Exposure exp = inv.getArgument(0);
            exp.setId(UUID.randomUUID());
            return exp;
        });

        Optional<SurfaceResponse> result = suggestionService.suggestSnippet();

        assertThat(result).isPresent();
        assertThat(result.get().content()).isEqualTo("Without music, life would be a mistake.");
    }
}
