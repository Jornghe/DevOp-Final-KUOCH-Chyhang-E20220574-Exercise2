#!/bin/bash

# Start SSH daemon
service ssh start || true

# Start NGINX
service nginx start || true

# Try to build and run Spring Boot (non-fatal if it fails)
if [ -f /app/pom.xml ]; then
    cd /app
    mvn package -DskipTests -q 2>&1 | tail -5 || echo "Maven build failed, skipping Spring Boot startup"
    JAR=$(find /app/target -name "*.jar" 2>/dev/null | head -1)
    if [ -n "$JAR" ]; then
        echo "Starting Spring Boot: $JAR"
        java -jar "$JAR" &
    fi
fi

# Keep container alive
tail -f /dev/null
