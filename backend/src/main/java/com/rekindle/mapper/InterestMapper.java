package com.rekindle.mapper;

import com.rekindle.dto.CreateInterestRequest;
import com.rekindle.dto.InterestResponse;
import com.rekindle.entity.Interest;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface InterestMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "alpha", constant = "1")
    @Mapping(target = "beta", constant = "1")
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "snippets", ignore = true)
    Interest toEntity(CreateInterestRequest request);

    @Mapping(target = "snippetCount", source = "snippetCount")
    InterestResponse toResponse(Interest interest, long snippetCount);

    @Mapping(target = "snippetCount", expression = "java(interest.getSnippets() != null ? interest.getSnippets().size() : 0L)")
    InterestResponse toResponse(Interest interest);
}
