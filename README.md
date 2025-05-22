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
- KI-Modul: Ollama (im Beispiel 'qwen3:14b'), OpenAI
- Frontend: Flutter (Android/IOS/Browser)
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
Damit eine Ollama Instanz mit dem Docker Containern Kommunizieren kann, sollte beim starten der Instanz folgender Befehl eingegeben werden:

```bash
OLLAMA_HOST=0.0.0.0 ollama server
```
Informationen zur Installation von Ollama und dessen Modellen finden Sie [hier](https://ollama.com/)
Im Hauptordner des Repository befindet sich das **build-and-deploy.sh** Shell-Skript.
Dies kann wie folgt eingesetzt werden:
```bash
./build-and-deploy.sh
```

Zusätzlich können folgende Flags gesetzt werden:
```bash
./build-and-deploy.sh -f -s ~/.m2/some-settings.xml
```

Flag **-f** erlaubt es dem Benutzer, den build step der Quarkus Applikationen zu überspringen. Dies ist hilfreich, wenn der **target** Ordner der Applikationen schon vorhanden ist.  
Die flag **-s [settings.xml]** erlaubt es während dem build Step eine andere settings.xml für Maven zu benutzen.

#### Umgebungsvariablen (Backend)
Das **docker-compose.yml** nimmt für einige Werte einen Standardwert an. Diese können bzw. sollten mithilfe einer .env Datei, oder dem hinzufügen von Umgebungsvariablen im Terminal überschrieben werden.    
Die [.env.example](./.env.example) Datei im Hauptordner zeigt ein kurzes Beispiel der möglichen Umgebungsvariablen.  
#### Wichtig!
Die Variable `QUARKUS_LANGCHAIN4J_OLLAMA__LLAMA__CHAT_MODEL_MODEL_ID` muss entweder Exportiert, oder zu der `.env` Datei hinzugefügt werden, da diese im, Build Prozess genötigt wird.

### Bauen und Deployen des Frontends (Lokal über Android Studio/VSCode/command Line)
#### ⚠️ Hinweis!

Für das Bauen und Ausführen des Frontends sollte die Flutter SDK auf dem Rechner bereits installiert sein.  
Mehr Information zum installieren von Flutter finden sie [hier](https://docs.flutter.dev/get-started/install?categories=mvo,ar-vr,rmdy,web,mobile&categories=mvo,creative,ar-vr,rmdy,mobile&categories=mvo,creative,ar-vr,rmdy,web,mobile)  
Zudem ist es empfehlenswert, die Android SDK zu installieren (falls die App auf Android emuliert werden soll). Hierzu finden Sie ebenfalls genauere Informationen in der [Flutter Bedienungsanleitung](https://docs.flutter.dev/platform-integration/android/setup)

#### Bauen und Ausfuhren

Damit das Frontend ausgeführt werden kann, muss zunächst ein Android-Simulator oder ein IOS-Simulator gestartet werden.  
Sollte jedoch als Frontend ein Chrome-Browser benutzt werden, muss hier fur kein Simulator gestartet werden.  
Dabei sollte jedoch das Browser Design auf "Hell" eingestellt werden, da das App-Design nur fur diesen Modus vorgesehen ist.

Im Hauptorder des Repositories befindet sich ein Ordner names `Frontend`.
```bash
cd ./Frontend/student_initializer
```

Dies ist der Hauptordner der Flutter Apliaktion. Ab hier kann nun die Flutter Applikation über die `RUN` Schaltfläche von Android Studio oder VSCode die Flutter Applikation gestartet werden.  

Es besteht ebenfalls die Möglichkeit, über den folgenden Befehl die Flutter Applikation mithilfe des Terminals zu starten:
```bash
flutter run
```