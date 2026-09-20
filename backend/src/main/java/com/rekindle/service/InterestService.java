package com.rekindle.service;

import com.rekindle.dto.CreateInterestRequest;
import com.rekindle.dto.InterestResponse;
import com.rekindle.entity.Interest;
import com.rekindle.mapper.InterestMapper;
import com.rekindle.repository.InterestRepository;
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
public class InterestService {

    private final InterestRepository interestRepository;
    private final SnippetRepository snippetRepository;
    private final InterestMapper interestMapper;

    public List<InterestResponse> getAllInterests() {
        return interestRepository.findAll().stream()
                .map(interest -> {
                    long count = snippetRepository.countByInterestId(interest.getId());
                    return interestMapper.toResponse(interest, count);
                })
                .toList();
    }

    public InterestResponse getInterestById(UUID id) {
        Interest interest = findEntityById(id);
        long count = snippetRepository.countByInterestId(id);
        return interestMapper.toResponse(interest, count);
    }

    @Transactional
    public InterestResponse createInterest(CreateInterestRequest request) {
        String normalizedName = request.name().trim().toLowerCase();
        if (interestRepository.existsByNameIgnoreCase(normalizedName)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Interest already exists: " + normalizedName);
        }

        Interest interest = new Interest(normalizedName);
        Interest saved = interestRepository.save(interest);
        return interestMapper.toResponse(saved, 0L);
    }

    @Transactional
    public void deleteInterest(UUID id) {
        if (!interestRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Interest not found with id: " + id);
        }
        interestRepository.deleteById(id);
    }

    public Interest findEntityById(UUID id) {
        return interestRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Interest not found with id: " + id));
    }
}
