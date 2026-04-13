FROM gradle:8.5-jdk17 AS builder
WORKDIR /app
COPY . .
RUN gradle clean xnatPluginJar -x test

FROM scratch AS artifact
COPY --from=builder /app/build/libs/. /