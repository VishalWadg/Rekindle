package com.rekindle.service;

import com.rekindle.dto.SurfaceResponse;
import com.rekindle.entity.Exposure;
import com.rekindle.entity.Interest;
import com.rekindle.entity.Snippet;
import com.rekindle.repository.ExposureRepository;
import com.rekindle.repository.InterestRepository;
import com.rekindle.repository.SnippetRepository;
import lombok.RequiredArgsConstructor;
import org.apache.commons.math3.distribution.BetaDistribution;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.concurrent.ThreadLocalRandom;

@Service
@RequiredArgsConstructor
public class SuggestionService {

    private final InterestRepository interestRepository;
    private final SnippetRepository snippetRepository;
    private final ExposureRepository exposureRepository;
    private final RecencyCacheService recencyCacheService;

    @Transactional
    public Optional<SurfaceResponse> suggestSnippet() {
        List<Interest> eligibleInterests = interestRepository.findEligibleInterests();
        if (eligibleInterests == null || eligibleInterests.isEmpty()) {
            return Optional.empty();
        }

        // 1. Thompson Sampling: sample each interest's Beta distribution
        Interest winningInterest = eligibleInterests.stream()
                .max(Comparator.comparingDouble(this::sampleInterest))
                .orElse(eligibleInterests.get(0));

        // 2. Query candidates excluding recently surfaced snippet IDs
        Set<UUID> recentIds = recencyCacheService.getRecentlySeenSnippetIds();
        List<Snippet> candidates;

        if (recentIds.isEmpty()) {
            candidates = snippetRepository.findByInterestId(winningInterest.getId());
        } else {
            candidates = snippetRepository.findByInterestIdAndIdNotIn(winningInterest.getId(), recentIds);
        }

        // Fallback: if all snippets in this topic were seen in the last 24h, allow re-surfacing
        if (candidates == null || candidates.isEmpty()) {
            candidates = snippetRepository.findByInterestId(winningInterest.getId());
        }

        if (candidates == null || candidates.isEmpty()) {
            return Optional.empty();
        }

        // 3. Pick random snippet from candidates
        int index = ThreadLocalRandom.current().nextInt(candidates.size());
        Snippet chosenSnippet = candidates.get(index);

        // 4. Create and save Exposure
        Exposure exposure = new Exposure(chosenSnippet);
        Exposure savedExposure = exposureRepository.save(exposure);

        // 5. Update Redis recency cooldown
        recencyCacheService.markSnippetAsSeen(chosenSnippet.getId());

        // 6. Return response
        return Optional.of(new SurfaceResponse(
                savedExposure.getId(),
                chosenSnippet.getId(),
                winningInterest.getId(),
                winningInterest.getName(),
                chosenSnippet.getContent(),
                chosenSnippet.getCreatedAt()
        ));
    }

    protected double sampleInterest(Interest interest) {
        double alpha = Math.max(1.0, interest.getAlpha());
        double beta = Math.max(1.0, interest.getBeta());
        return new BetaDistribution(alpha, beta).sample();
    }
}
