FROM maven:3.8-openjdk-8 AS build
WORKDIR /app
COPY . .
# Skip tests to speed up build
RUN mvn clean package -DskipTests -f vhrserver/pom.xml

FROM openjdk:8-jdk-alpine
# Copy the built jar from the vhr-web module
COPY --from=build /app/vhrserver/vhr-web/target/vhr-web-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java","-jar","/app.jar"]
