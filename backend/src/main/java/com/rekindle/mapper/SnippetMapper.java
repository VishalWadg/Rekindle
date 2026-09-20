package com.rekindle.mapper;

import com.rekindle.dto.CreateSnippetRequest;
import com.rekindle.dto.SnippetResponse;
import com.rekindle.entity.Interest;
import com.rekindle.entity.Snippet;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring")
public interface SnippetMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "exposures", ignore = true)
    @Mapping(target = "interest", source = "interest")
    @Mapping(target = "content", source = "request.content")
    Snippet toEntity(CreateSnippetRequest request, Interest interest);

    @Mapping(target = "interestId", source = "interest.id")
    @Mapping(target = "interestName", source = "interest.name")
    SnippetResponse toResponse(Snippet snippet);

    List<SnippetResponse> toResponseList(List<Snippet> snippets);
}
