package com.rekindle.service;

import com.rekindle.dto.CreateInterestRequest;
import com.rekindle.dto.InterestResponse;
import com.rekindle.entity.Interest;
import com.rekindle.mapper.InterestMapper;
import com.rekindle.repository.InterestRepository;
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
import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class InterestServiceTest {

    @Mock
    private InterestRepository interestRepository;

    @Mock
    private SnippetRepository snippetRepository;

    private InterestMapper interestMapper;
    private InterestService interestService;

    @BeforeEach
    void setUp() {
        interestMapper = Mappers.getMapper(InterestMapper.class);
        interestService = new InterestService(interestRepository, snippetRepository, interestMapper);
    }

    @Test
    @DisplayName("getAllInterests should return interests with correct snippet counts")
    void getAllInterests_ReturnsMappedResponsesWithCounts() {
        UUID id = UUID.randomUUID();
        Interest interest = new Interest("stoicism");
        interest.setId(id);

        when(interestRepository.findAll()).thenReturn(List.of(interest));
        when(snippetRepository.countByInterestId(id)).thenReturn(5L);

        List<InterestResponse> result = interestService.getAllInterests();

        assertThat(result).hasSize(1);
        assertThat(result.get(0).name()).isEqualTo("stoicism");
        assertThat(result.get(0).snippetCount()).isEqualTo(5L);
        assertThat(result.get(0).alpha()).isEqualTo(1);
        assertThat(result.get(0).beta()).isEqualTo(1);
    }

    @Test
    @DisplayName("getInterestById should return interest when found")
    void getInterestById_WhenFound_ReturnsResponse() {
        UUID id = UUID.randomUUID();
        Interest interest = new Interest("poetry");
        interest.setId(id);

        when(interestRepository.findById(id)).thenReturn(Optional.of(interest));
        when(snippetRepository.countByInterestId(id)).thenReturn(2L);

        InterestResponse result = interestService.getInterestById(id);

        assertThat(result.id()).isEqualTo(id);
        assertThat(result.name()).isEqualTo("poetry");
        assertThat(result.snippetCount()).isEqualTo(2L);
    }

    @Test
    @DisplayName("getInterestById should throw 404 when not found")
    void getInterestById_WhenNotFound_ThrowsResponseStatusException() {
        UUID id = UUID.randomUUID();
        when(interestRepository.findById(id)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> interestService.getInterestById(id))
                .isInstanceOf(ResponseStatusException.class)
                .satisfies(ex -> assertThat(((ResponseStatusException) ex).getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND));
    }

    @Test
    @DisplayName("createInterest should normalize name to lowercase, trim spaces, and save")
    void createInterest_NormalizesAndSaves() {
        CreateInterestRequest request = new CreateInterestRequest("  Architecture  ");
        when(interestRepository.existsByNameIgnoreCase("architecture")).thenReturn(false);

        Interest savedInterest = new Interest("architecture");
        savedInterest.setId(UUID.randomUUID());
        when(interestRepository.save(any(Interest.class))).thenReturn(savedInterest);

        InterestResponse result = interestService.createInterest(request);

        assertThat(result.name()).isEqualTo("architecture");
        assertThat(result.snippetCount()).isEqualTo(0L);
        verify(interestRepository).save(argThat(i -> i.getName().equals("architecture")));
    }

    @Test
    @DisplayName("createInterest should throw 409 Conflict when name already exists")
    void createInterest_WhenDuplicate_ThrowsConflict() {
        CreateInterestRequest request = new CreateInterestRequest("History");
        when(interestRepository.existsByNameIgnoreCase("history")).thenReturn(true);

        assertThatThrownBy(() -> interestService.createInterest(request))
                .isInstanceOf(ResponseStatusException.class)
                .satisfies(ex -> assertThat(((ResponseStatusException) ex).getStatusCode()).isEqualTo(HttpStatus.CONFLICT));

        verify(interestRepository, never()).save(any());
    }

    @Test
    @DisplayName("deleteInterest should delete when ID exists")
    void deleteInterest_WhenExists_DeletesSuccessfully() {
        UUID id = UUID.randomUUID();
        when(interestRepository.existsById(id)).thenReturn(true);

        interestService.deleteInterest(id);

        verify(interestRepository).deleteById(id);
    }

    @Test
    @DisplayName("deleteInterest should throw 404 when ID does not exist")
    void deleteInterest_WhenNotExists_ThrowsNotFound() {
        UUID id = UUID.randomUUID();
        when(interestRepository.existsById(id)).thenReturn(false);

        assertThatThrownBy(() -> interestService.deleteInterest(id))
                .isInstanceOf(ResponseStatusException.class)
                .satisfies(ex -> assertThat(((ResponseStatusException) ex).getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND));

        verify(interestRepository, never()).deleteById(id);
    }
}
