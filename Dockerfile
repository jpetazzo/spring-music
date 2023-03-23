FROM --platform=$BUILDPLATFORM gradle:jdk17
COPY . .
RUN --mount=type=cache,target=/home/gradle/.gradle ./gradlew clean assemble

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=0 /home/gradle/build/ /app/
CMD test "$PROFILE" && PROFILE_FLAG="-Dspring.profiles.active=$PROFILE" ;\
    exec java $PROFILE_FLAG -jar libs/spring-music-1.0.jar
EXPOSE 8080
