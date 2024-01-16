FROM maven:3.9.2-eclipse-temurin-17-alpine AS build

# ARG EUREKA_SERVICE_URL

# ENV EUREKA_SERVICE_URL=${EUREKA_SERVICE_URL}

WORKDIR /app

COPY .mvn/ .mvn
COPY pom.xml ./
RUN mvn dependency:go-offline
COPY ./src ./src

RUN mvn clean package -Dmaven.test.skip.exec

## BUILD JAR

FROM eclipse-temurin:17-alpine

WORKDIR /app

COPY --from=build ./app/target/*.jar ./ms-discovery.jar

CMD ["java", "-jar", "ms-discovery.jar"]