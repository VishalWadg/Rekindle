package com.rekindle.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "exposures")
public class Exposure {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "snippet_id", nullable = false)
    private Snippet snippet;

    @Column(name = "surfaced_at", nullable = false, updatable = false)
    private LocalDateTime surfacedAt;

    @Column(nullable = false)
    private String reaction = "none";

    @Column(name = "responded_at")
    private LocalDateTime respondedAt;

    public Exposure() {
    }

    public Exposure(Snippet snippet) {
        this.snippet = snippet;
        this.reaction = "none";
    }

    @PrePersist
    protected void onCreate() {
        if (this.surfacedAt == null) {
            this.surfacedAt = LocalDateTime.now();
        }
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public Snippet getSnippet() {
        return snippet;
    }

    public void setSnippet(Snippet snippet) {
        this.snippet = snippet;
    }

    public LocalDateTime getSurfacedAt() {
        return surfacedAt;
    }

    public void setSurfacedAt(LocalDateTime surfacedAt) {
        this.surfacedAt = surfacedAt;
    }

    public String getReaction() {
        return reaction;
    }

    public void setReaction(String reaction) {
        this.reaction = reaction;
    }

    public LocalDateTime getRespondedAt() {
        return respondedAt;
    }

    public void setRespondedAt(LocalDateTime respondedAt) {
        this.respondedAt = respondedAt;
    }
}