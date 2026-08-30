# syntax=docker/dockerfile:1

# Identical application to the Maven example, built with Gradle. The starter is
# resolved from Maven Central; settings.gradle forbids mavenLocal outright.
# JDK 21 is pinned deliberately: Lombok's annotation processing is version
# sensitive and breaks on newer JDKs.

FROM eclipse-temurin:21-jdk AS build

# Capped so a build on a small VPS cannot starve the containers around it.
ENV GRADLE_OPTS="-Dorg.gradle.jvmargs=-Xmx512m -Dorg.gradle.daemon=false"

WORKDIR /src

COPY gradle gradle
COPY gradlew build.gradle settings.gradle gradle.properties ./
RUN chmod +x gradlew

COPY src ./src

RUN --mount=type=cache,target=/root/.gradle \
    ./gradlew --no-daemon bootJar \
    && cp build/libs/*-SNAPSHOT.jar /app.jar

FROM eclipse-temurin:21-jre

WORKDIR /app

ENV JAVA_OPTS="-XX:MaxRAMPercentage=70 -XX:+UseSerialGC -Xss512k"

COPY --from=build /app.jar /app/app.jar

RUN useradd --system --uid 10001 worker
USER worker

EXPOSE 8081

ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar /app/app.jar"]
