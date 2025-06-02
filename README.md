# 🧠 KI-Unterstütze Feedback-Bögen Generierungs - und Verwaltungstool

Dieses Projekt ermöglicht es, **Beobachtungen pro Lernendem (Learner) und Veranstaltung (Event)** zu erfassen und zu verwalten. Auf Basis dieser Beobachtungen **(Observations)** kann mithilfe von **künstlicher Intelligenz** automatisch ein strukturierter **Feedback-Bogen** generiert werden.

Ziel ist es, Lehrkräften eine einfache, effiziente und objektive Möglichkeit zur Reflexion und Rückmeldung zu geben.

## 🚀 Hauptfunktionen

- 📋 Beobachtungen pro Schüler und Kurs erfassen
- 🗂️ Beobachtungen erfassen.
- 🤖 KI-gestützte Generierung strukturierter Feedback-Dokumente
- 🧑‍🏫 Unterstützt Lehrkräfte im pädagogischen Alltag

## 🛠️ Technologien

- Programmiersprachen: Java, Dart, SQL
- Backend: QuarkusIo, Langchain4j,
- KI-Modul: Ollama (im Beispiel `qwen3:14b`), OpenAI
- Frontend: Flutter (Android/IOS/Chrome)
- Datenbank: PostgreSQL

## 📦 Installation

Zunächst, wenn nicht schon getan, soll das Repository über git clone runtergeladen werden.

```bash
git clone https://github.com/Captain-Ironbump/bachelor_project.git
cd bachelor_project
```

### Bauen und Deployen des Backends (Docker wird benötigt!)
#### ⚠️ Hinweis!
Es sollten sichergestellt sein, das folgende Ports vor dem Deploy Step frei sein:

- `8081` – für den `learn-service`
- `8082` – für das `llm-interface`
- `5432` – für die PostgreSQL Datenbank
- `11122` – für das Embedding Store
- `11434` – für die Lokale Ollama Instanz

Wenn einer dieser Ports bereits belegt ist, kann es beim Starten der Container zu Fehlern kommen.
Zudem sollte (falls die Umgebungsvariable `USE_OPENAI` auf `false` gesetzt wurde) eine Lokale Ollama Instanz auf Port `11434` laufen.  

Eine Ollama-Instanz kann je nach Betriebssystem einfach gestartet werden. Für [macOS](https://ollama.com/download/mac) und [Windows](https://ollama.com/download/windows) muss lediglich der entsprechende Installations-Client heruntergeladen und gestartet werden. Anschließend sind die Anweisungen des Installers zu befolgen.
Für [Linux](https://ollama.com/download/linux) ist eine manuelle Installation erforderlich.  

Zum Start eines Modells kann folgender Befehl verwendet werden:

```bash
ollama run llama3.2
```
Dieser Befehl lädt beim ersten Ausführen automatisch das entsprechende Modell (in diesem Fall `llama3.2`) herunter und startet es.  
(**Wichtig! Modelle können mehr als 10GB groß sein, weshalb der erste Download eines LLM-Model-Images entsprechend lange dauern kann.**)

Informationen zur Installation von Ollama und dessen Modellen finden Sie [hier](https://ollama.com/).  
Im `Backend` Ordner des Repository befindet sich das **build-and-run.sh** Shell-Skript.
```bash
cd $PROJECT_ROOT/Backend/
```
Dies kann wie folgt eingesetzt werden:
```bash
./build-and-run.sh
```

Zusätzlich können folgende Flags gesetzt werden:
```bash
./build-and-run.sh -f -s ~/.m2/some-settings.xml
```

Flag **-f** erlaubt es dem Benutzer, den build step der Quarkus Applikationen zu überspringen. Dies ist hilfreich, wenn der **target** Ordner der Applikationen schon vorhanden ist.  
Die flag **-s [settings.xml]** erlaubt es während dem build Step eine andere settings.xml für Maven zu benutzen.

#### Umgebungsvariablen (Backend)
Das **docker-compose.yml** nimmt für einige Werte einen Standardwert an. Diese können bzw. sollten mithilfe einer .env Datei, oder dem hinzufügen von Umgebungsvariablen im Terminal überschrieben werden.  
Die [.env.example](./.env.example) Datei im Hauptordner zeigt ein kurzes Beispiel der möglichen Umgebungsvariablen.  

| Umgebungsvariable                                         | Beschreibung                                                                  | Standardwert               |
|-----------------------------------------------------------|-------------------------------------------------------------------------------|----------------------------|
| `HOST_IP_ADDRESS`                                         | IP-Adresse des Hosts, die aus dem Docker-Container heraus erreichbar ist.     | `host.docker.internal`     |
| `QUARKUS_PROFILE`                                         | Aktiviert das Docker-spezifische Konfigurationsprofil in Quarkus.             | `docker`                   |
| `QUARKUS_LANGCHAIN4J_OLLAMA__LLAMA__CHAT_MODEL_MODEL_ID`  | Gibt das KI-Modell an, das von LangChain4J über Ollama verwendet wird.        | `qwen3:14b`                |
| `OPENAI_API_CHATBOT_KEY`                                  | API-Schlüssel für die Authentifizierung bei der OpenAI-Schnittstelle.         |                  |
| `OPENAI_API_CHATBOT_BASE_URL`                             | Basis-URL für Anfragen an die OpenAI API (z. B. für lokale Instanzen/Proxys). | `https://api.openai.com/v1/` |
| `OPENAI_API_CHATBOT_MODEL_NAME`                           | GPT Model, welches für die Anfrage benutzt werden soll                        | `gpt-4o-mini` |
| `USE_OPENAI`                                              | Aktiviert OpenAI und deaktiviert Ollama, wenn auf `true` gesetzt; bei `false` wird Ollama verwendet. | `false` |


#### ❗️ Wichtig!
Die Variable `QUARKUS_LANGCHAIN4J_OLLAMA__LLAMA__CHAT_MODEL_MODEL_ID` muss entweder als Umgebungsvariable exportiert oder in die `.env`-Datei eingetragen werden. Sie wird im Build-Prozess benötigt – unabhängig davon, ob Ollama oder ein anderer Anbieter verwendet wird bzw. ob eine Ollama-Instanz gestartet wurde oder nicht.  
Die Variable `OPENAI_API_CHATBOT_BASE_URL` bezieht sich auf die OpenAI API, über die Abfragen an das Sprachmodell gesendet werden.
Damit die Sprachmodelle von OpenAI benutzt werden können, muss vorerst ein API Key generiert werden, dieser wird anschließend in der Ubgebungsvariable `OPENAI_API_CHATBOT_KEY` gesetzt.  
Der API Key kann [hier](https://platform.openai.com/api-keys) generiert werden.  
Die Variable `HOST_IP_ADDRESS` benutzt als Standardwert `host.docker.internal`, dies funktioniert jedoch nur auf MacOS und Windows, füe Linux Geräte sollte hier der Wert angepasst werden. 

### Bauen und Deployen des Frontends (Lokal über Android Studio/VSCode/command Line)
#### ⚠️ Hinweis!

Für das Bauen und Ausführen des Frontends sollte die Flutter SDK auf dem Rechner bereits installiert sein.  
Mehr Information zum installieren von Flutter finden sie [hier](https://docs.flutter.dev/get-started/install?categories=mvo,ar-vr,rmdy,web,mobile&categories=mvo,creative,ar-vr,rmdy,mobile&categories=mvo,creative,ar-vr,rmdy,web,mobile).  
Zudem ist es empfehlenswert, die Android SDK zu installieren (falls die App auf Android emuliert werden soll). Hierzu finden Sie ebenfalls genauere Informationen in der [Flutter Bedienungsanleitung](https://docs.flutter.dev/platform-integration/android/setup).  

#### Bauen und Ausfuhren

Damit das Frontend ausgeführt werden kann, muss zunächst ein Android-Simulator oder ein IOS-Simulator gestartet werden.  
Sollte jedoch als Frontend ein Chrome-Browser benutzt werden, muss hier für kein Simulator gestartet werden.  
Dabei sollte jedoch das Browser Design auf "Hell" eingestellt werden, da das App-Design nur fur diesen Modus vorgesehen ist.  

Im Hauptorder des Repositories befindet sich ein Ordner names `Frontend`.
```bash
cd $PROJECT_ROOT/Frontend/student_initializer/
```

Dies ist der Hauptordner der Flutter Apliaktion. Ab hier kann nun die Flutter Applikation über die `RUN` Schaltfläche von Android Studio oder VSCode die Flutter Applikation gestartet werden.  

Es besteht ebenfalls die Möglichkeit, über den folgenden Befehl die Flutter Applikation mithilfe des Terminals zu starten:
```bash
flutter run
```

## 🏆 Kompetenzen definieren
Kompetenzen werden in `.txt` Dateien innerhalb des `rag` Ordners im `llm-interface/src/main/resources` Ordner des `Backends` definiert. Diese werden in ein Embedding Store als Vektoren gespeichert um die Prompts der LLM mit dem Retrieval-Augmented Generation (RAG) mit diesen Zusatzinformationen dyanamisch zu bestücken.
Die Kompetenzen werden unterhalb ihres Kurses nummieriert aufgelistet. Dazu werden, ebenfalls nummeriert, die Indikatoren der Kompetenz angegeben.  
Die Struktur sieht somit wie folgt aus:
```txt
Course: [Kursname]
Competence 1: [Kompetenz des Kurses]
Indicators:
1.1 [Beschreibung des Indikator 1]
...
1.N [Beschreibung des Indikator N]
```  
Die Datei [01-competence.txt](./Backend/llm-interface/src/main/resources/rag/01-competence.txt) kann als Referenz verwendet und/oder Erweitert werden.

## 🔗 Backend Endpoints

### Learn-Service (Port 8081)

| Methode | Pfad                                               | Beschreibung                                         | Parameter / Query-Parameter                                                                                 |
|---------|----------------------------------------------------|------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|
| GET     | /api/events                                        | Gibt alle Events zurück                              | Query: `withLearnerCount` (Boolean), `eventSortReason` (String)                                             |
| POST    | /api/events                                        | Erstellt ein neues Event                             | Body: `EventDTO`                                                                                            |
| GET     | /api/events/{eventId}                              | Gibt ein Event nach ID zurück                        | Pfad: `eventId` (Long)                                                                                      |
| POST    | /api/learners                                      | Erstellt einen neuen Lerner                          | Body: `LearnerDTO`                                                                                          |
| GET     | /api/learners/{learnerId}                          | Gibt einen Lerner nach ID zurück                     | Pfad: `learnerId` (Long)                                                                                    |
| GET     | /api/learners                                      | Gibt alle Lerner zurück                              | -                                                                                                           |
| POST    | /api/tags                                          | Erstellt einen neuen Tag                             | Body: `TagDTO`                                                                                              |
| GET     | /api/tags                                          | Gibt alle Tags zurück                                | -                                                                                                           |
| POST    | /api/observations                                  | Erstellt eine neue Observation                       | Body: `ObservationDTO`                                                                                      |
| GET     | /api/observations/learnerId/{learnerId}            | Gibt alle Observations eines Lerners zurück           | Pfad: `learnerId` (Long), Query: `sort` (String), `order` (String), `eventId` (Long), `timespanInDays` (int)|
| GET     | /api/observations/count-map                        | Gibt für jeden Lerner die Anzahl der Observations    | Query: `eventId` (Long), `timeSpanInDays` (Integer), `learners` (List<Long>)                                |
| GET     | /api/observations/observationId/{observationId}    | Gibt eine Observation nach ID zurück                 | Pfad: `observationId` (Long)                                                                                |
| DELETE  | /api/observations/{observationId}                  | Löscht eine Observation nach ID                      | Pfad: `observationId` (Long)                                                                                |
| POST    | /api/observations/tags                             | Erstellt eine Observation mit Tags                   | Body: `ObservationWithTagsDTO`                                                                              |
| PATCH   | /api/observations/tags/{observationId}             | Patcht eine Observation mit Tags                     | Pfad: `observationId` (Long), Body: `ObservationWithTagsDTO`                                                |
| GET     | /api/observations/tags/learner/{learnerId}         | Gibt Observations mit Tags eines Lerners zurück      | Pfad: `learnerId` (Long), Query: `eventId` (Long), `sort` (String), `order` (String), `timespanInDays` (int)|
| GET     | /api/observations/tags/observation/{observationId} | Gibt eine Observation mit Tags nach ID zurück        | Pfad: `observationId` (Long)                                                                                |

### llm-interface (Port 8082)

| Methode | Pfad                                                        | Beschreibung                                                        | Parameter / Query-Parameter                                  |
|---------|-------------------------------------------------------------|---------------------------------------------------------------------|--------------------------------------------------------------|
| GET     | /api/reporttrigger/new/event/{eventId}/learner/{learnerId}  | Startet die asynchrone Report-Generierung | Pfad: `eventId` (Long), `learnerId` (Long), Query: `length` (String) |
| GET     | /api/tag-concept/competence/learners/{learnerId}            | Startet die asynchrone Report-Generierung mit Tag-Concept `competence tags` für einen Lerner   | Pfad: `learnerId` (Long), Query: `eventId` (Long), `length` (String) |
| GET     | /api/tag-concept/general/learners/{learnerId}               | Startet die asynchrone Report-Generierung mit Tag-Concept `general tags` für einen Lerner | Pfad: `learnerId` (Long), Query: `eventId` (Long), `length` (String) |