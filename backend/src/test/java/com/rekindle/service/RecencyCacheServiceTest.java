package com.rekindle.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;

import java.time.Duration;
import java.util.Collections;
import java.util.Set;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class RecencyCacheServiceTest {

    @Mock
    private StringRedisTemplate redisTemplate;

    @Mock
    private ValueOperations<String, String> valueOperations;

    private RecencyCacheService recencyCacheService;

    @BeforeEach
    void setUp() {
        recencyCacheService = new RecencyCacheService(redisTemplate);
    }

    @Test
    @DisplayName("markSnippetAsSeen should write to Redis with 24h TTL")
    void markSnippetAsSeen_WritesWith24hTtl() {
        UUID snippetId = UUID.randomUUID();
        String expectedKey = "rekindle:recency:" + snippetId;

        when(redisTemplate.opsForValue()).thenReturn(valueOperations);

        recencyCacheService.markSnippetAsSeen(snippetId);

        verify(valueOperations).set(expectedKey, "1", Duration.ofHours(24));
    }

    @Test
    @DisplayName("isSnippetRecentlySeen should return true when key exists in Redis")
    void isSnippetRecentlySeen_WhenKeyExists_ReturnsTrue() {
        UUID snippetId = UUID.randomUUID();
        String key = "rekindle:recency:" + snippetId;

        when(redisTemplate.hasKey(key)).thenReturn(true);

        boolean result = recencyCacheService.isSnippetRecentlySeen(snippetId);

        assertThat(result).isTrue();
    }

    @Test
    @DisplayName("isSnippetRecentlySeen should return false when key does not exist")
    void isSnippetRecentlySeen_WhenKeyMissing_ReturnsFalse() {
        UUID snippetId = UUID.randomUUID();
        String key = "rekindle:recency:" + snippetId;

        when(redisTemplate.hasKey(key)).thenReturn(false);

        boolean result = recencyCacheService.isSnippetRecentlySeen(snippetId);

        assertThat(result).isFalse();
    }

    @Test
    @DisplayName("getRecentlySeenSnippetIds should parse keys into UUID set")
    void getRecentlySeenSnippetIds_ParsesActiveKeys() {
        UUID id1 = UUID.randomUUID();
        UUID id2 = UUID.randomUUID();

        when(redisTemplate.keys("rekindle:recency:*")).thenReturn(Set.of(
                "rekindle:recency:" + id1,
                "rekindle:recency:" + id2
        ));

        Set<UUID> result = recencyCacheService.getRecentlySeenSnippetIds();

        assertThat(result).containsExactlyInAnyOrder(id1, id2);
    }

    @Test
    @DisplayName("getRecentlySeenSnippetIds should return empty set when no keys match")
    void getRecentlySeenSnippetIds_WhenEmpty_ReturnsEmptySet() {
        when(redisTemplate.keys("rekindle:recency:*")).thenReturn(Collections.emptySet());

        Set<UUID> result = recencyCacheService.getRecentlySeenSnippetIds();

        assertThat(result).isEmpty();
    }

    @Test
    @DisplayName("clear should delete all matched recency keys")
    void clear_DeletesAllRecencyKeys() {
        Set<String> keys = Set.of("rekindle:recency:abc", "rekindle:recency:def");
        when(redisTemplate.keys("rekindle:recency:*")).thenReturn(keys);

        recencyCacheService.clear();

        verify(redisTemplate).delete(keys);
    }
}
