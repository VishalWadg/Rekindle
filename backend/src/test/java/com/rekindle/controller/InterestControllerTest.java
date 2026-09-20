package com.rekindle.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.rekindle.dto.CreateInterestRequest;
import com.rekindle.dto.InterestResponse;
import com.rekindle.service.InterestService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(InterestController.class)
class InterestControllerTest {

    @Autowired
    private MockMvc mockMvc;

    private final ObjectMapper objectMapper = new ObjectMapper().findAndRegisterModules();

    @MockitoBean
    private InterestService interestService;

    @Test
    @DisplayName("POST /api/interests with blank name should return 400 Bad Request")
    void createInterest_WhenNameIsBlank_ReturnsBadRequest() throws Exception {
        CreateInterestRequest request = new CreateInterestRequest("   ");

        mockMvc.perform(post("/api/interests")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("POST /api/interests with valid name should return 201 Created")
    void createInterest_WhenValid_ReturnsCreated() throws Exception {
        UUID id = UUID.randomUUID();
        CreateInterestRequest request = new CreateInterestRequest("gardening");
        InterestResponse response = new InterestResponse(id, "gardening", 1, 1, 0L, LocalDateTime.now());

        when(interestService.createInterest(any(CreateInterestRequest.class))).thenReturn(response);

        mockMvc.perform(post("/api/interests")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").value(id.toString()))
                .andExpect(jsonPath("$.name").value("gardening"))
                .andExpect(jsonPath("$.snippetCount").value(0));
    }

    @Test
    @DisplayName("GET /api/interests should return 200 OK with list")
    void getAllInterests_ReturnsOkWithList() throws Exception {
        UUID id = UUID.randomUUID();
        InterestResponse response = new InterestResponse(id, "astronomy", 1, 1, 3L, LocalDateTime.now());
        when(interestService.getAllInterests()).thenReturn(List.of(response));

        mockMvc.perform(get("/api/interests"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].name").value("astronomy"))
                .andExpect(jsonPath("$[0].snippetCount").value(3));
    }
}
