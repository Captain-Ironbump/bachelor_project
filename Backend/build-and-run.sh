#!/bin/bash


# Load .env
if [ -f .env ]; then
  echo "🔄 Loading environment variables from .env"
  set -o allexport
  source .env
  set +o allexport

  echo "✅ Loaded environment variables:"
  grep -v '^#' .env | grep '=' | while IFS='=' read -r key value; do
    echo "$key=${!key}"
  done
else
  echo "⚠️  No .env file found."
fi



SKIP_BUILD=false
MAVEN_SETTINGS=""

while getopts "s:f" opt; do
  case ${opt} in
    s) 
      MAVEN_SETTINGS="-s $OPTARG"
      echo "Using custom Maven settings file: $OPTARG"
    ;;
    f)
      SKIP_BUILD=true
      echo "Set Skipping"
    ;;
    *) echo default
    ;;
  esac
done

if [[ "$SKIP_BUILD" = false ]]; then
  echo "Building Service 'learn-service'..."
  cd learn-service
  ./mvnw clean package $MAVEN_SETTINGS -DskipTests || exit 1
  cd ..

  echo "Building Service 'llm-interface'..."
  cd llm-interface
  ./mvnw clean package $MAVEN_SETTINGS -DskipTests || exit 1
  cd ..
else
  echo "Skipping build for 'learn-service'"
  echo "Skipping build for 'llm-interface'"
fi

# Run Docker Compose
echo "Starting Docker Compose..."
docker-compose up --build

