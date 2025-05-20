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

Zunächts, wenn nicht schon getan, soll das Repository über git clone runtergeladen werden.

```bash
git clone https://github.com/Captain-Ironbump/bachelor_project.git
cd bachelor_project
```
### Bauen und Deployen des **Backends** (Docker wird genötigt!)
Im Hauptordner des Repository befindet sich die **build-and-deploy.sh** Shell-Skript Datei.
Diese kann wie folgt eingesetzt werden:
```bash
./build-and-deploy.sh
```
Zusätzlich können folgende Flags gesetzt werden:
```bash
./build-and-deploy.sh -f -s ~/.m2/some-settings.xml
```
Flag **-f** erlaubt es dem Benutzer den build step der Quarkus Applikationen zu überspringen. Dies ist hilfreich, wenn der **target** Ordner der Applikationen schon vorhanden ist.  
Die flag **-s [settings.xml]** erlaubt es während dem build Step eine andere settings.xml für Maven zu benutzen.

### Umgebungvariablen
Das **docker-compose.yml** nimmt für gewisse Werte einen Standartwert an. Diese können mithilfe einer .env Datei, oder dem hinzufügen von Umgebungsvariablen im Terminal überschrieben werden.  
Die [.env.example](./.env.example) Datei im Hauptordner zeigt ein kurzes Beipsiel der möglichen Umgebungsvariablen. 