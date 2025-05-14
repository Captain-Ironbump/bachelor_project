package org.ba.rag;

import dev.langchain4j.data.document.Document;
import dev.langchain4j.data.document.loader.FileSystemDocumentLoader;
import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.store.embedding.EmbeddingStore;
import dev.langchain4j.store.embedding.EmbeddingStoreIngestor;
//import dev.langchain4j.store.embedding.pgvector.PgVectorEmbeddingStore;
import io.quarkus.logging.Log;
import io.quarkus.runtime.StartupEvent;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.event.Observes;
import jakarta.inject.Named;

import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.eclipse.microprofile.config.inject.ConfigProperty;

@ApplicationScoped
public class Ingestor {

    public static String extractCourseName(String text) {
        String[] lines = text.split("\n");
        for (String line : lines) {
            if (line.startsWith("Course:")) {
                return line.substring(7).trim();
            }
        }
        return null;
    }

        
    private static String extractCompetenceName(String trimmedComp) {
        String[] lines = trimmedComp.split("\n");
        for (String line : lines) {
            if (line.startsWith("Competence")) {
                return line.substring(12).trim();
            }
        }
        return null;
    }

    public void ingest(
            @Observes StartupEvent ev,
            @Named("pgVectorEmbeddingStore") EmbeddingStore<TextSegment> embeddingStore, 
            @Named("allMiniLmL6V2QuantizedEmbeddingModelTest") EmbeddingModel embeddingModel,
            @ConfigProperty(name = "rag.dir.path", defaultValue = "src/main/resources/rag") Path documents) {
        
        embeddingStore.removeAll();
        List<Document> list = FileSystemDocumentLoader.loadDocumentsRecursively(documents);
        Log.info("Loaded " + list.size() + " documents for ingestion");

        List<Document> courseChunks = new ArrayList<>();

        /* 
        for (Document doc : list) {
            String[] blocks = doc.text().split("(?=Course:)");
    
            for (String block : blocks) {
                String trimmed = block.trim();
                if (!trimmed.isEmpty()) {
                    courseChunks.add(Document.from(trimmed));
                }
            }
        }
        */
        for (Document document : list) {
            String[] courseBlocks = document.text().split("(?=Course: )");
            for (String courseBlock : courseBlocks) {
                Log.info(courseBlock);
                String trimmedBlock = courseBlock.trim();
                if (trimmedBlock.isEmpty()) continue;
                String courseName = extractCourseName(trimmedBlock);
                if (courseName == null) continue;

                String[] competenceBlocks = trimmedBlock.split("(?=Competence )");
                for (String competenceBlock : competenceBlocks) {
                    Log.info(competenceBlock);
                    String trimmedComp = competenceBlock.trim();
                    if (trimmedComp.isEmpty()) continue;

                    Log.info(trimmedComp);
                    String competenceName = extractCompetenceName(trimmedComp);
                    if (competenceName == null) continue;

                    Pattern indicatorPattern = Pattern.compile("(\\d\\.\\d)\\s+(.*?)(?=\\n\\d\\.\\d|$)", Pattern.DOTALL);
                    Matcher matcher = indicatorPattern.matcher(trimmedBlock);


                    while (matcher.find()) {
                        String indicatorNumber = matcher.group(1).trim();
                        String indicatorText = matcher.group(2).trim();

                        Log.info(courseName);
                        Log.info(competenceName);
                        Log.info(indicatorNumber);
                        Log.info(indicatorText);
                        // Build content
                        String content = String.format("""
                            Course: %s
                            Competence: %s
                            Indicator: %s
                            Text: %s
                            """, courseName, competenceName, indicatorNumber, indicatorText);

                        // Create single-document chunk
                        Document indicatorDoc = Document.from(content);
                        
                        Map<String, String> metadata = Map.of(
                                "course", courseName,
                                "competence", competenceName,
                                "indicator", indicatorNumber
                        );
                        
                        for (var mapEntry : metadata.entrySet()) {
                            indicatorDoc.metadata().put(mapEntry.getKey(), mapEntry.getValue());
                        }

                        courseChunks.add(indicatorDoc);
                    }

                }
            }
        }
        
    
        EmbeddingStoreIngestor ingestor = EmbeddingStoreIngestor.builder()
                .embeddingStore(embeddingStore)
                .embeddingModel(embeddingModel)
                .build();

        for (Document chunk : courseChunks) {
            ingestor.ingest(chunk);
        }
        Log.info("Document ingested");
    }
}
