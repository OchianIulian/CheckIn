# syntax=docker/dockerfile:1

# --- Build stage ---
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

COPY pom.xml .
COPY .mvn .mvn
COPY mvnw mvnw
RUN chmod +x mvnw

# Cache dependencies first
RUN ./mvnw -q -DskipTests dependency:go-offline

# Copy sources and build
COPY src src
RUN ./mvnw -q -DskipTests clean package

# --- Run stage ---
FROM eclipse-temurin:21-jre
WORKDIR /app

# Create non-root user
RUN useradd -m appuser
USER appuser

# Copy built jar
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

# Use JAVA_OPTS for tuning from env
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
