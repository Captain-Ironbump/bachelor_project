package org.ba.models;

import java.util.Set;

import org.ba.infrastructure.restclient.dto.Event;
import org.ba.infrastructure.restclient.dto.Learner;
import org.ba.infrastructure.restclient.dto.Observation;

import dev.langchain4j.model.output.structured.Description;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DataFetcherResult {
    @Description("The Learner Object")
    private Learner learner;
    @Description("The Event Object")
    private Event event;
    @Description("A Set of Observation Objects")
    private Set<Observation> observations;
}
