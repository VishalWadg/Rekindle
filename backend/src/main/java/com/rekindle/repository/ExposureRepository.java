package com.rekindle.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.rekindle.entity.Exposure;

public interface ExposureRepository extends JpaRepository<Exposure, UUID> {
    
}
