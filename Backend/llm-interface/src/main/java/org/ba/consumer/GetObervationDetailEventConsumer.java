package org.ba.consumer;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

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

import org.ba.models.Tag;
import org.ba.models.TaggingResult;
import org.ba.models.shared.events.EventType;
import org.ba.service.bots.ObservationTaggerAgent;
import org.ba.service.bots.TagFilterAgent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.context.control.ActivateRequestContext;
import jakarta.enterprise.event.Observes;
import jakarta.inject.Inject;
import jakarta.inject.Named;

@ApplicationScoped
public class GetObervationDetailEventConsumer {
    private static final Logger log = LoggerFactory.getLogger(GetObervationDetailEventConsumer.class);

    @Inject
    RabbitMQClient rabbitMQClient;
    private Channel channel;

    @Inject
    @Named("objectMapper")
    ObjectMapper objectMapper;

    @Inject
    TagFilterAgent tagFilterAgent;

    @Inject
    ObservationTaggerAgent observationTaggerAgent;

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
            channel.exchangeDeclare(EventType.GET_OBSERVATION_DETAIL_EVENT.type, BuiltinExchangeType.TOPIC, true);
            channel.queueDeclare("observation.data.response", true, false, false, null);
            channel.queueBind("observation.data.response", EventType.GET_OBSERVATION_DETAIL_EVENT.type, "observation.get.event");
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }

    private void setupReceiving() {
        try {
            channel.basicConsume("observation.data.response", true, new DefaultConsumer(channel) {
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
    protected void processMessage(byte[] body) throws IOException {
        log.info("Received: " + new String(body, StandardCharsets.UTF_8)); 
        JsonNode root = objectMapper.readTree(body);
        if (!root.has("type") || !EventType.GET_OBSERVATION_DETAIL_EVENT.toString().equals(root.get("type").asText())) {
            log.error("not the expected Event");
            return;
        }
        String observationId = root.get("observation").get("observationId").asText();
        String rawObservation = root.get("observation").get("rawObservation").asText();
        byte[] decodedBytes = Base64.getDecoder().decode(rawObservation);
        String decodedObservation = new String(decodedBytes);
        //decodedBytes = Base64.getDecoder().decode(decodedObservation);
        //String endObservation = new String(decodedBytes);
        log.info("Raw Base64: {}", rawObservation);
        log.info("observationId: {} with observatin {}", observationId, decodedObservation);
        JsonNode tagsNode = root.get("tags");
        List<Tag> tags = new ArrayList<>();

        if (tagsNode != null && tagsNode.isArray()) {
            for (JsonNode tagNode : tagsNode) {
                String tagName = tagNode.get("tag").asText();
                String color = tagNode.get("color").asText();
                tags.add(Tag.builder().tag(tagName).color(color).build());
            }
        }
        List<String> response = tagFilterAgent.filterTags(tags);
        for (String string : response) {
            log.info("{}", string);
        }
        TaggingResult taggingResult = observationTaggerAgent.tagObservation(decodedObservation, observationId, response);
        log.info("{}", taggingResult);
    } 
}

