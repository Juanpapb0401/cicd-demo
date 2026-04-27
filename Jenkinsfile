pipeline {
    agent any

    tools {
        // Este nombre 'maven3' debe ser el mismo que pusiste 
        // en Administrar Jenkins -> Tools -> Maven
        maven 'maven3'
    }

    stages {
        stage('Checkout') {
            steps {
                // Obtiene el código desde tu repositorio
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                // Punto 1 y 2: Compila y ejecuta pruebas unitarias
                sh 'mvn clean package'
            }
        }

        stage('Static Analysis (SonarQube)') {
            steps {
                // Punto 2 y 3.1: Análisis estático de código
                // Asegúrate de tener SonarQube corriendo en el puerto 9000
                script {
                    sh 'mvn sonar:sonar -Dsonar.projectKey=my-app -Dsonar.host.url=http://localhost:9000'
                }
            }
        }

        stage('Docker Build') {
            steps {
                // Punto 1: Construcción de la imagen
                sh 'docker build -t mi-app:latest .'
            }
        }

        stage('Container Security Scan (Trivy)') {
            steps {
                // Punto 2 y 3.2: Escaneo de vulnerabilidades
                // Punto 3.3: --exit-code 1 hace que el pipeline falle si hay vulnerabilidades CRITICAL
                sh 'trivy image --severity CRITICAL --exit-code 1 mi-app:latest'
            }
        }

        stage('Deploy') {
            when { 
                branch 'master' // Solo despliega si estás en la rama principal
            }
            steps {
                // Punto 4: Despliegue en el puerto 80
                // Primero detiene cualquier contenedor previo para evitar conflictos
                sh 'docker ps -q --filter "name=mi-app-container" | xargs -r docker stop'
                sh 'docker run -d --rm --name mi-app-container -p 80:8080 mi-app:latest'
            }
        }
    }

    post {
        always {
            // Punto 3.4: Limpieza del espacio de trabajo
            echo 'Limpiando entorno...'
            cleanWs()
        }
        failure {
            // Punto 4: Notificación en caso de error
            echo '❌ El pipeline falló. Revisa los logs de SonarQube o Trivy.'
        }
        success {
            echo '✅ Pipeline completado con éxito y aplicación desplegada.'
        }
    }
}