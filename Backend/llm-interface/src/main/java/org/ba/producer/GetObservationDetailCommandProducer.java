package org.ba.producer;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;

import org.ba.consumer.GetObervationDetailEventConsumer;
import org.ba.models.shared.commands.CommandType;
import org.ba.models.shared.commands.GetObservationDetailCommand;
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


@ApplicationScoped
public class GetObservationDetailCommandProducer {
    private static final Logger log = LoggerFactory.getLogger(GetObservationDetailCommandProducer.class);

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
            channel.exchangeDeclare(CommandType.GET_OBSERVATION_DETAIL_COMMAND.type, BuiltinExchangeType.TOPIC, true);
            channel.queueDeclare("observation.data.request", true, false, false, null);
            channel.queueBind("observation.data.request", CommandType.GET_OBSERVATION_DETAIL_COMMAND.type, "observation.get.command");
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }

    public void sendObservationRequest(int observationId) throws Exception {
        GetObservationDetailCommand command = 
            GetObservationDetailCommand.builder()
                .timeStamp(OffsetDateTime.now())
                .observationId(String.valueOf(observationId))
                .type(CommandType.GET_OBSERVATION_DETAIL_COMMAND)
                .build();
        log.info("sending command with: {}", command.toString());
        send(serializeMessage(command));
    }

    private String serializeMessage(GetObservationDetailCommand command) throws JsonProcessingException {
        return objectMapper.writeValueAsString(command);
    }

    private void send(String message) {
        try {
            channel.basicPublish(CommandType.GET_OBSERVATION_DETAIL_COMMAND.type, "#", null, message.getBytes(StandardCharsets.UTF_8));
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }
}

