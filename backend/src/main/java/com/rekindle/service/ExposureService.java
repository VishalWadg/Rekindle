package com.rekindle.service;

import com.rekindle.dto.FeedbackRequest;
import com.rekindle.dto.FeedbackResponse;
import com.rekindle.entity.Exposure;
import com.rekindle.entity.Interest;
import com.rekindle.repository.ExposureRepository;
import com.rekindle.repository.InterestRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ExposureService {

    private final ExposureRepository exposureRepository;
    private final InterestRepository interestRepository;

    @Transactional
    public FeedbackResponse recordFeedback(UUID exposureId, FeedbackRequest request) {
        Exposure exposure = exposureRepository.findById(exposureId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Exposure not found with id: " + exposureId));

        String reaction = request.reaction().trim().toLowerCase();

        // Idempotency: if already responded, return current state without double counting
        if (exposure.getRespondedAt() != null) {
            Interest interest = exposure.getSnippet().getInterest();
            return new FeedbackResponse(
                    exposure.getId(),
                    exposure.getReaction(),
                    exposure.getRespondedAt(),
                    interest.getId(),
                    interest.getAlpha(),
                    interest.getBeta()
            );
        }

        exposure.setReaction(reaction);
        LocalDateTime now = LocalDateTime.now();
        exposure.setRespondedAt(now);
        exposureRepository.save(exposure);

        Interest interest = exposure.getSnippet().getInterest();
        if ("keep".equals(reaction) || "explore".equals(reaction)) {
            interest.setAlpha(interest.getAlpha() + 1);
        } else if ("skip".equals(reaction)) {
            interest.setBeta(interest.getBeta() + 1);
        }
        interestRepository.save(interest);

        return new FeedbackResponse(
                exposure.getId(),
                reaction,
                now,
                interest.getId(),
                interest.getAlpha(),
                interest.getBeta()
        );
    }
}
