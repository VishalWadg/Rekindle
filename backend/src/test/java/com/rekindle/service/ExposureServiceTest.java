package com.rekindle.service;

import com.rekindle.dto.FeedbackRequest;
import com.rekindle.dto.FeedbackResponse;
import com.rekindle.entity.Exposure;
import com.rekindle.entity.Interest;
import com.rekindle.entity.Snippet;
import com.rekindle.repository.ExposureRepository;
import com.rekindle.repository.InterestRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ExposureServiceTest {

    @Mock
    private ExposureRepository exposureRepository;

    @Mock
    private InterestRepository interestRepository;

    private ExposureService exposureService;

    @BeforeEach
    void setUp() {
        exposureService = new ExposureService(exposureRepository, interestRepository);
    }

    @Test
    @DisplayName("recordFeedback with 'keep' should increment parent interest alpha")
    void recordFeedback_WhenKeep_IncrementsAlpha() {
        Interest interest = new Interest("art");
        interest.setId(UUID.randomUUID());
        interest.setAlpha(1);
        interest.setBeta(1);

        Snippet snippet = new Snippet(interest, "Paint every day.");
        Exposure exposure = new Exposure(snippet);
        UUID exposureId = UUID.randomUUID();
        exposure.setId(exposureId);

        when(exposureRepository.findById(exposureId)).thenReturn(Optional.of(exposure));

        FeedbackResponse response = exposureService.recordFeedback(exposureId, new FeedbackRequest("keep"));

        assertThat(response.reaction()).isEqualTo("keep");
        assertThat(response.updatedAlpha()).isEqualTo(2);
        assertThat(response.updatedBeta()).isEqualTo(1);
        assertThat(interest.getAlpha()).isEqualTo(2);

        verify(exposureRepository).save(exposure);
        verify(interestRepository).save(interest);
    }

    @Test
    @DisplayName("recordFeedback with 'explore' should increment parent interest alpha")
    void recordFeedback_WhenExplore_IncrementsAlpha() {
        Interest interest = new Interest("history");
        interest.setId(UUID.randomUUID());
        interest.setAlpha(2);
        interest.setBeta(1);

        Snippet snippet = new Snippet(interest, "The past is never dead.");
        Exposure exposure = new Exposure(snippet);
        UUID exposureId = UUID.randomUUID();
        exposure.setId(exposureId);

        when(exposureRepository.findById(exposureId)).thenReturn(Optional.of(exposure));

        FeedbackResponse response = exposureService.recordFeedback(exposureId, new FeedbackRequest("explore"));

        assertThat(response.reaction()).isEqualTo("explore");
        assertThat(response.updatedAlpha()).isEqualTo(3);
        assertThat(response.updatedBeta()).isEqualTo(1);
        assertThat(interest.getAlpha()).isEqualTo(3);

        verify(interestRepository).save(interest);
    }

    @Test
    @DisplayName("recordFeedback with 'skip' should increment parent interest beta")
    void recordFeedback_WhenSkip_IncrementsBeta() {
        Interest interest = new Interest("gardening");
        interest.setId(UUID.randomUUID());
        interest.setAlpha(1);
        interest.setBeta(1);

        Snippet snippet = new Snippet(interest, "Water your plants.");
        Exposure exposure = new Exposure(snippet);
        UUID exposureId = UUID.randomUUID();
        exposure.setId(exposureId);

        when(exposureRepository.findById(exposureId)).thenReturn(Optional.of(exposure));

        FeedbackResponse response = exposureService.recordFeedback(exposureId, new FeedbackRequest("skip"));

        assertThat(response.reaction()).isEqualTo("skip");
        assertThat(response.updatedAlpha()).isEqualTo(1);
        assertThat(response.updatedBeta()).isEqualTo(2);
        assertThat(interest.getBeta()).isEqualTo(2);

        verify(interestRepository).save(interest);
    }

    @Test
    @DisplayName("recordFeedback should throw 404 when exposure does not exist")
    void recordFeedback_WhenNotFound_ThrowsException() {
        UUID id = UUID.randomUUID();
        when(exposureRepository.findById(id)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> exposureService.recordFeedback(id, new FeedbackRequest("keep")))
                .isInstanceOf(ResponseStatusException.class)
                .satisfies(ex -> assertThat(((ResponseStatusException) ex).getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND));

        verifyNoInteractions(interestRepository);
    }

    @Test
    @DisplayName("recordFeedback should be idempotent if already responded")
    void recordFeedback_WhenAlreadyResponded_DoesNotDoubleCount() {
        Interest interest = new Interest("science");
        interest.setId(UUID.randomUUID());
        interest.setAlpha(3);
        interest.setBeta(2);

        Snippet snippet = new Snippet(interest, "E = mc^2");
        Exposure exposure = new Exposure(snippet);
        UUID exposureId = UUID.randomUUID();
        exposure.setId(exposureId);
        exposure.setReaction("keep");
        exposure.setRespondedAt(LocalDateTime.now().minusMinutes(5));

        when(exposureRepository.findById(exposureId)).thenReturn(Optional.of(exposure));

        FeedbackResponse response = exposureService.recordFeedback(exposureId, new FeedbackRequest("keep"));

        assertThat(response.updatedAlpha()).isEqualTo(3);
        assertThat(response.updatedBeta()).isEqualTo(2);
        verify(exposureRepository, never()).save(any());
        verify(interestRepository, never()).save(any());
    }
}
