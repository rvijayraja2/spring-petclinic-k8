FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom.xml and download dependencies first (better layer caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Now copy the rest of the source code
COPY src ./src

# Package the application
RUN mvn clean package

# ---------- Stage 2: Run the JAR ----------
FROM openjdk:17-slim
WORKDIR /app

# Copy the built JAR file
COPY --from=build /app/target/*.jar app.jar

# Run the app
CMD ["java", "-jar", "app.jar"]



