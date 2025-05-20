package org.ba.core.messages.queues.producers;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.charset.StandardCharsets;
import java.time.OffsetDateTime;
import java.util.List;

//import org.ba.core.messages.queues.consumers.GetObservationDetailCommandConsumer;
import org.ba.core.messages.queues.shared.events.EventType;
import org.ba.core.messages.queues.shared.events.GetObservationDetailEvent;
import org.ba.entities.dto.ObservationDTO;
import org.ba.entities.dto.TagDTO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.rabbitmq.client.BuiltinExchangeType;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;

import io.quarkiverse.rabbitmqclient.RabbitMQClient;
import io.quarkus.runtime.StartupEvent;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.event.Observes;
import jakarta.inject.Inject;
import jakarta.inject.Named;
/* 
@ApplicationScoped
public class GetObservationDetailEventProducer {
    private static final Logger log = LoggerFactory.getLogger(GetObservationDetailCommandConsumer.class);
   
    @Inject
    RabbitMQClient rabbitMQClient;
    private Channel channel;

    @Inject 
    @Named("objectMapper")
    ObjectMapper objectMapper;

    public void onApplicationStart(@Observes StartupEvent event) {
        setupQueues();
    }

    private void setupQueues() {
        try {
            // create a connection
            Connection connection = rabbitMQClient.connect();
            // create a channel
            channel = connection.createChannel();
            // declare exchanges and queues
            channel.exchangeDeclare(EventType.GET_OBSERVATION_DETAIL_EVENT.type, BuiltinExchangeType.TOPIC, true);
            channel.queueDeclare("observation.data.response", true, false, false, null);
            channel.queueBind("observation.data.response", EventType.GET_OBSERVATION_DETAIL_EVENT.type, "observation.get.event");
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }

    public void sendObservationDetailToQueue(ObservationDTO observation, List<TagDTO> tags) throws JsonProcessingException {
        GetObservationDetailEvent event = 
            GetObservationDetailEvent.builder()
                .timeStamp(OffsetDateTime.now())
                .type(EventType.GET_OBSERVATION_DETAIL_EVENT)
                .observation(observation)
                .tags(tags)
                .build();
        log.info("sending event with: {}", event.toString());
        send(serializeMessage(event));
    }

    private String serializeMessage(GetObservationDetailEvent event) throws JsonProcessingException {
        return objectMapper.writeValueAsString(event);
    }

    private void send(String message) {
        try {
            // send a message to the exchange
            channel.basicPublish(EventType.GET_OBSERVATION_DETAIL_EVENT.type, "observation.get.event", null, message.getBytes(StandardCharsets.UTF_8));
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }
}
*/