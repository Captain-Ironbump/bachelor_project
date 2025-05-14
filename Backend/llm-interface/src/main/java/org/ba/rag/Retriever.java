package org.ba.rag;

import java.util.List;

import dev.langchain4j.data.document.Metadata;
import dev.langchain4j.data.message.UserMessage;
import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.rag.DefaultRetrievalAugmentor;
import dev.langchain4j.rag.RetrievalAugmentor;
import dev.langchain4j.rag.content.injector.ContentInjector;
import dev.langchain4j.rag.content.retriever.EmbeddingStoreContentRetriever;
import dev.langchain4j.rag.query.Query;
import dev.langchain4j.store.embedding.EmbeddingStore;
import dev.langchain4j.store.embedding.filter.Filter;
import dev.langchain4j.store.embedding.filter.MetadataFilterBuilder;
import io.quarkus.logging.Log;
//import dev.langchain4j.store.embedding.pgvector.PgVectorEmbeddingStore;
import dev.langchain4j.rag.content.Content;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Named;

import java.util.function.Supplier;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


@ApplicationScoped
public class Retriever implements Supplier<RetrievalAugmentor> {

    //private final RetrievalAugmentor augmentor;
    private final EmbeddingStore<TextSegment> embeddingStore;
    private final EmbeddingModel embeddingModel;

    private String extractCourseName(Query query) {
        if (query == null || query.text() == null) {
            return "";
        }
        Pattern pattern = Pattern.compile("course name is:?\\s*(.+)", Pattern.CASE_INSENSITIVE);
        Matcher matcher = pattern.matcher(query.text());
        return matcher.find() ? matcher.group(1).trim() : "";
    }

    public Retriever(
        @Named("pgVectorEmbeddingStore") EmbeddingStore<TextSegment> embeddingStore,
        @Named("allMiniLmL6V2QuantizedEmbeddingModelTest") EmbeddingModel embeddingModel) {
            this.embeddingStore = embeddingStore;
            this.embeddingModel = embeddingModel;
        }

    @Override
    public RetrievalAugmentor get() {
       return DefaultRetrievalAugmentor.builder()
                .contentRetriever(userMessage -> {
                    String courseName = extractCourseName(userMessage);
                    Log.info("Course name: " + courseName);
                    EmbeddingStoreContentRetriever contentRetriever = EmbeddingStoreContentRetriever.builder()
                        .embeddingModel(embeddingModel)
                        .embeddingStore(embeddingStore)
                        .dynamicMaxResults(query -> 10)
                        .minScore(0.5)
                        .filter(MetadataFilterBuilder.metadataKey("course").isEqualTo(courseName))
                        .build();
                    return contentRetriever.retrieve(userMessage);
                })
                .contentInjector((contents, userMessage) -> {
                    StringBuffer prompt = new StringBuffer(userMessage.singleText());
                    if (contents.isEmpty()) {
                        String noDataMessage = "\nNo information could be fetched from the RAG database for the given course name.\n";
                        prompt.append(noDataMessage).toString();
                        Log.info(prompt.toString());
                        return new UserMessage(prompt.toString());
                    }
                    prompt.append("\nPlease, only use the following information from the RAG database for the competences with the given course name:\n");
                    contents.forEach(content -> prompt.append("- ").append(content.textSegment().text()).append("\n"));
                    Log.info(prompt.toString());
                    return new UserMessage(prompt.toString());
                })
                .build();
    }
}
