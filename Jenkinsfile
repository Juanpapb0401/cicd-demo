pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // El taller pide obtener el código
                checkout scm
            }
        }

        stage('Build') {
            steps {
                // Compilar la aplicación (mvn install o mvn package)
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                // Construir la imagen: docker build -t mi-app:latest
                sh 'docker build -t mi-app:latest .'
            }
        }

        stage('Test') {
            steps {
                // Ejecutar pruebas básicas
                sh 'mvn test'
            }
        }
    }
}