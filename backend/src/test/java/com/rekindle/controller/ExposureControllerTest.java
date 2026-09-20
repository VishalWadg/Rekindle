package com.rekindle.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.rekindle.dto.FeedbackRequest;
import com.rekindle.dto.FeedbackResponse;
import com.rekindle.service.ExposureService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDateTime;
import java.util.UUID;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(ExposureController.class)
class ExposureControllerTest {

    @Autowired
    private MockMvc mockMvc;

    private final ObjectMapper objectMapper = new ObjectMapper().findAndRegisterModules();

    @MockitoBean
    private ExposureService exposureService;

    @Test
    @DisplayName("POST /api/exposures/{id}/feedback with 'keep' should return 200 OK with FeedbackResponse")
    void recordFeedback_WhenValid_ReturnsOk() throws Exception {
        UUID exposureId = UUID.randomUUID();
        UUID interestId = UUID.randomUUID();
        FeedbackResponse response = new FeedbackResponse(
                exposureId,
                "keep",
                LocalDateTime.now(),
                interestId,
                2,
                1
        );

        when(exposureService.recordFeedback(eq(exposureId), any(FeedbackRequest.class)))
                .thenReturn(response);

        mockMvc.perform(post("/api/exposures/" + exposureId + "/feedback")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(new FeedbackRequest("keep"))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.exposureId").value(exposureId.toString()))
                .andExpect(jsonPath("$.reaction").value("keep"))
                .andExpect(jsonPath("$.updatedAlpha").value(2))
                .andExpect(jsonPath("$.updatedBeta").value(1));
    }

    @Test
    @DisplayName("POST /api/exposures/{id}/feedback with invalid reaction should return 400 Bad Request")
    void recordFeedback_WhenInvalidReaction_ReturnsBadRequest() throws Exception {
        UUID exposureId = UUID.randomUUID();

        mockMvc.perform(post("/api/exposures/" + exposureId + "/feedback")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"reaction": "love"}
                                """))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("POST /api/exposures/{id}/feedback with blank reaction should return 400 Bad Request")
    void recordFeedback_WhenBlankReaction_ReturnsBadRequest() throws Exception {
        UUID exposureId = UUID.randomUUID();

        mockMvc.perform(post("/api/exposures/" + exposureId + "/feedback")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"reaction": "   "}
                                """))
                .andExpect(status().isBadRequest());
    }
}
