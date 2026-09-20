package com.rekindle.service;

import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.Collections;
import java.util.Objects;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RecencyCacheService {

    public static final String KEY_PREFIX = "rekindle:recency:";
    public static final Duration DEFAULT_TTL = Duration.ofHours(24);

    private final StringRedisTemplate redisTemplate;

    public void markSnippetAsSeen(UUID snippetId) {
        markSnippetAsSeen(snippetId, DEFAULT_TTL);
    }

    public void markSnippetAsSeen(UUID snippetId, Duration ttl) {
        String key = buildKey(snippetId);
        redisTemplate.opsForValue().set(key, "1", ttl);
    }

    public boolean isSnippetRecentlySeen(UUID snippetId) {
        String key = buildKey(snippetId);
        return Boolean.TRUE.equals(redisTemplate.hasKey(key));
    }

    public Set<UUID> getRecentlySeenSnippetIds() {
        Set<String> keys = redisTemplate.keys(KEY_PREFIX + "*");
        if (keys == null || keys.isEmpty()) {
            return Collections.emptySet();
        }

        return keys.stream()
                .map(key -> key.substring(KEY_PREFIX.length()))
                .map(idStr -> {
                    try {
                        return UUID.fromString(idStr);
                    } catch (IllegalArgumentException e) {
                        return null;
                    }
                })
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
    }

    public void clear() {
        Set<String> keys = redisTemplate.keys(KEY_PREFIX + "*");
        if (keys != null && !keys.isEmpty()) {
            redisTemplate.delete(keys);
        }
    }

    private String buildKey(UUID snippetId) {
        return KEY_PREFIX + snippetId.toString();
    }
}
