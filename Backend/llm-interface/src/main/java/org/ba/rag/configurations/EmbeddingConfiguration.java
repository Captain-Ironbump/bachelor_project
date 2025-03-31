package org.ba.rag.configurations;

import org.eclipse.microprofile.config.inject.ConfigProperties;

import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.model.embedding.onnx.allminilml6v2q.AllMiniLmL6V2QuantizedEmbeddingModel;
import dev.langchain4j.store.embedding.EmbeddingStore;
import dev.langchain4j.store.embedding.pgvector.PgVectorEmbeddingStore;
import io.quarkus.logging.Log;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.inject.Produces;
import jakarta.inject.Named;


public class EmbeddingConfiguration {
    /* 
    @Produces
    @Named("infinispanEmbeddingStoreTest")
    @ApplicationScoped
    InfinispanEmbeddingStore createStore() {
        InfinispanSchema schema = new InfinispanSchema("embeddings-cache", 384L, 2);
        ConfigurationBuilder builder = new ConfigurationBuilder();
        builder.addServer()
            .host("0.0.0.0")
            .port(11222)
            .security()
            .authentication()
            .username("myuser")
            .password("mypassword")
        ;
        builder.connectionTimeout(5000);
        builder.socketTimeout(5000);
        builder.maxRetries(3);
        RemoteCacheManager cacheManager = new RemoteCacheManager(builder.build());
        return InfinispanEmbeddingStore.builder().schema(schema).cacheManager(cacheManager).build();
    }*/

    @Produces
    @ApplicationScoped
    @Named("pgVectorEmbeddingStore")
    EmbeddingStore<TextSegment> createEmbeddingStore(
        @Named("allMiniLmL6V2QuantizedEmbeddingModelTest") EmbeddingModel embeddingModel,
        @ConfigProperties(prefix = "pgvector.database") PgVectorDatabaseConfiguration serverConfig
    ) {
        Log.info(embeddingModel.dimension());
        Log.info(serverConfig.toString());
        return PgVectorEmbeddingStore.builder()
            .host(serverConfig.getHost())
            .port(serverConfig.getPort())
            .database("postgres")
            .user(serverConfig.getUser())
            .password(serverConfig.getPassword())
            .table(serverConfig.getTable())
            .dimension(embeddingModel.dimension())
            .createTable(true)
            .build();
    }

    @Produces
    @ApplicationScoped
    @Named("allMiniLmL6V2QuantizedEmbeddingModelTest")
    EmbeddingModel createEmbeddingModel() {
        return new AllMiniLmL6V2QuantizedEmbeddingModel();
    }
}
