package org.ba.rag;

import dev.langchain4j.data.document.Document;
import dev.langchain4j.data.document.loader.FileSystemDocumentLoader;
import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.model.embedding.onnx.HuggingFaceTokenizer;
import dev.langchain4j.model.embedding.onnx.allminilml6v2q.AllMiniLmL6V2QuantizedEmbeddingModel;
import dev.langchain4j.store.embedding.EmbeddingStore;
import dev.langchain4j.store.embedding.EmbeddingStoreIngestor;
//import dev.langchain4j.store.embedding.pgvector.PgVectorEmbeddingStore;
import io.quarkus.logging.Log;
import io.quarkus.runtime.StartupEvent;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.event.Observes;
import jakarta.inject.Named;

import static dev.langchain4j.data.document.splitter.DocumentSplitters.recursive;

import java.nio.file.Path;
import java.util.List;

import org.eclipse.microprofile.config.inject.ConfigProperty;

@ApplicationScoped
public class Ingestor {    

    public void ingest(
            @Observes StartupEvent ev,
            @Named("pgVectorEmbeddingStore") EmbeddingStore<TextSegment> embeddingStore, 
            @Named("allMiniLmL6V2QuantizedEmbeddingModelTest") EmbeddingModel embeddingModel,
            @ConfigProperty(name = "rag.dir.path", defaultValue = "src/main/resources/rag") Path documents) {
        
        embeddingStore.removeAll();
        List<Document> list = FileSystemDocumentLoader.loadDocumentsRecursively(documents);
        EmbeddingStoreIngestor ingestor = EmbeddingStoreIngestor.builder()
                .embeddingStore(embeddingStore)
                .embeddingModel(embeddingModel)
                .documentSplitter(recursive(100, 25, new HuggingFaceTokenizer()))
                .build();
        Log.info("Ingesting " + list.size() + " documents");
        ingestor.ingest(list);
        Log.info("Document ingested");
    }
}
