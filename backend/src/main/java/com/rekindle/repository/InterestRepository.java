package com.rekindle.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.rekindle.entity.Interest;

public interface InterestRepository extends JpaRepository<Interest, UUID> {
    @Query("SELECT DISTINCT i FROM Interest i JOIN i.snippets s")
    List<Interest> findEligibleInterests();

    boolean existsByNameIgnoreCase(String name);
}
