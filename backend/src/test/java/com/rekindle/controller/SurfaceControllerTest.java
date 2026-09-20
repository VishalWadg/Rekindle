package com.rekindle.controller;

import com.rekindle.dto.SurfaceResponse;
import com.rekindle.service.SuggestionService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(SurfaceController.class)
class SurfaceControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private SuggestionService suggestionService;

    @Test
    @DisplayName("GET /api/surface should return 200 OK with SurfaceResponse when thought available")
    void surface_WhenAvailable_ReturnsOkWithResponse() throws Exception {
        UUID exposureId = UUID.randomUUID();
        UUID snippetId = UUID.randomUUID();
        UUID interestId = UUID.randomUUID();

        SurfaceResponse response = new SurfaceResponse(
                exposureId,
                snippetId,
                interestId,
                "poetry",
                "Two roads diverged in a yellow wood",
                LocalDateTime.now()
        );

        when(suggestionService.suggestSnippet()).thenReturn(Optional.of(response));

        mockMvc.perform(get("/api/surface"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.exposureId").value(exposureId.toString()))
                .andExpect(jsonPath("$.snippetId").value(snippetId.toString()))
                .andExpect(jsonPath("$.interestName").value("poetry"))
                .andExpect(jsonPath("$.content").value("Two roads diverged in a yellow wood"));
    }

    @Test
    @DisplayName("GET /api/surface should return 204 No Content when no thoughts available")
    void surface_WhenEmpty_ReturnsNoContent() throws Exception {
        when(suggestionService.suggestSnippet()).thenReturn(Optional.empty());

        mockMvc.perform(get("/api/surface"))
                .andExpect(status().isNoContent());
    }
}
