package org.ba.core.messages.queues.consumers;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.charset.StandardCharsets;
import java.util.List;

import org.ba.core.ObservationService;
import org.ba.core.TagService;
import org.ba.core.messages.queues.producers.GetObservationDetailEventProducer;
import org.ba.core.messages.queues.shared.commands.CommandType;
import org.ba.entities.dto.ObservationDTO;
import org.ba.entities.dto.TagDTO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.rabbitmq.client.AMQP;
import com.rabbitmq.client.BuiltinExchangeType;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.DefaultConsumer;
import com.rabbitmq.client.Envelope;

import io.quarkiverse.rabbitmqclient.RabbitMQClient;
import io.quarkus.runtime.StartupEvent;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.context.control.ActivateRequestContext;
import jakarta.enterprise.event.Observes;
import jakarta.inject.Inject;
import jakarta.inject.Named;

@ApplicationScoped
public class GetObservationDetailCommandConsumer {
    private static final Logger log = LoggerFactory.getLogger(GetObservationDetailCommandConsumer.class);

    @Inject
    RabbitMQClient rabbitMQClient;
    private Channel channel;

    @Inject
    ObservationService observationService; 

    @Inject
    TagService tagService;

    @Inject
    GetObservationDetailEventProducer producer;

    @Inject 
    @Named("objectMapper")
    ObjectMapper objectMapper;

    public void onApplicationStart(@Observes StartupEvent event) {
        setupQueues();
        setupReceiving();
    }

    private void setupQueues() {
        try {
            // create a connection
            Connection connection = rabbitMQClient.connect();
            // create a channel
            channel = connection.createChannel();
            // declare exchanges and queues
            channel.exchangeDeclare(CommandType.GET_OBSERVATION_DETAIL_COMMAND.type, BuiltinExchangeType.TOPIC, true);
            channel.queueDeclare("observation.data.request", true, false, false, null);
            channel.queueBind("observation.data.request", CommandType.GET_OBSERVATION_DETAIL_COMMAND.type, "observation.get.command");
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }

    private void setupReceiving() {
        try {
            channel.basicConsume("observation.data.request", true, new DefaultConsumer(channel) {
                @Override
                public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties, byte[] body) throws IOException {
                    processMessage(body);
                }
            });
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }

    @ActivateRequestContext
    public void processMessage(byte[] body) throws IOException {
        log.info("Received: " + new String(body, StandardCharsets.UTF_8));
        JsonNode root = objectMapper.readTree(body);
        Long observationId = root.get("observationId").asLong();
        ObservationDTO observation = observationService.getObservationById(observationId);
        log.info("Observation DTO: {}", observation.toString());
        List<TagDTO> tags = tagService.fetchAllTags();
        sendObservationDetailToQueue(observation, tags);
    }

    private void sendObservationDetailToQueue(ObservationDTO observation, List<TagDTO> tags) {
        try {
            producer.sendObservationDetailToQueue(observation, tags);
        } catch (JsonProcessingException e) {
            log.error("Json parse error", e.getMessage());
        }
    }
}
