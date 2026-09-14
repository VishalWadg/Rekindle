package com.rekindle.repository;

import java.util.Collection;
import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.rekindle.entity.Snippet;

public interface SnippetRepository extends JpaRepository<Snippet, UUID> {
    List<Snippet> findByInterestId(UUID interestId);

    List<Snippet> findByInterestIdAndIdNotIn(UUID interestId, Collection<UUID> excludedIds);
}
