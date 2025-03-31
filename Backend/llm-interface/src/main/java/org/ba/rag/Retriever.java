package org.ba.rag;

import java.util.List;
import dev.langchain4j.data.message.UserMessage;
import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.model.embedding.onnx.allminilml6v2q.AllMiniLmL6V2QuantizedEmbeddingModel;
import dev.langchain4j.rag.DefaultRetrievalAugmentor;
import dev.langchain4j.rag.RetrievalAugmentor;
import dev.langchain4j.rag.content.injector.ContentInjector;
import dev.langchain4j.rag.content.retriever.EmbeddingStoreContentRetriever;
import dev.langchain4j.store.embedding.EmbeddingStore;
//import dev.langchain4j.store.embedding.pgvector.PgVectorEmbeddingStore;
import dev.langchain4j.rag.content.Content;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Named;

import java.util.function.Supplier;


@ApplicationScoped
public class Retriever implements Supplier<RetrievalAugmentor> {

    private final RetrievalAugmentor augmentor;

    public Retriever(
        @Named("pgVectorEmbeddingStore") EmbeddingStore<TextSegment> embeddingStore,
        @Named("allMiniLmL6V2QuantizedEmbeddingModelTest") EmbeddingModel embeddingModel) {
            EmbeddingStoreContentRetriever contentRetriever = EmbeddingStoreContentRetriever.builder()
                .embeddingModel(embeddingModel)
                .embeddingStore(embeddingStore)
                .maxResults(3)
                .build();
        augmentor = DefaultRetrievalAugmentor
                .builder()
                .contentRetriever(contentRetriever)
                .contentInjector(new ContentInjector() {

                    @Override
                    public UserMessage inject(List<Content> list, UserMessage userMessage) {
                        StringBuffer prompt = new StringBuffer(userMessage.singleText());
                        prompt.append("\nPlease, only use the following information from the RAG database:\n");
                        list.forEach(content -> prompt.append("- ").append(content.textSegment().text()).append("\n"));
                        return new UserMessage(prompt.toString());
                    }
                    
                })
                .build();
        }

    @Override
    public RetrievalAugmentor get() {
        return augmentor;
    }
}
