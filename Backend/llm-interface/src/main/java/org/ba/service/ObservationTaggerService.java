package org.ba.service;

import org.ba.producer.GetObservationDetailCommandProducer;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

@ApplicationScoped
public class ObservationTaggerService {
    @Inject
    GetObservationDetailCommandProducer producer;

    public void triggerObservationTags() {
        try {
            producer.sendObservationRequest(5);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
