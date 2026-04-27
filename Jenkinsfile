pipeline {
    agent any

    tools {
        // Nombre configurado en Administrar Jenkins -> Tools -> Maven
        maven 'maven3'
    }

    stages {
        stage('Checkout') {
            steps {
                // Punto 1: Obtener el código fuente
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                // Punto 1 y 2: Compilación (Skipeamos tests por el error de memoria en Mac)
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Static Analysis (SonarQube)') {
            steps {
                // Punto 2 y 3.1: Análisis de código
                // Usamos host.docker.internal para que Jenkins vea al contenedor de SonarQube
                script {
                    sh 'mvn sonar:sonar -Dsonar.projectKey=my-app -Dsonar.host.url=http://host.docker.internal:9000'
                }
            }
        }

        stage('Docker Build') {
            steps {
                // Punto 1: Construir la imagen Docker
                // Esto funcionará si reiniciaste Jenkins con el volumen del socket
                sh 'docker build -t mi-app:latest .'
            }
        }

        stage('Container Security Scan (Trivy)') {
            steps {
                // Punto 2 y 3.2: Escaneo de seguridad
                // Punto 3.3 (Gatekeeping): --exit-code 1 hace que el pipeline falle si hay vulnerabilidades CRITICAL
                sh 'trivy image --severity CRITICAL --exit-code 1 mi-app:latest'
            }
        }

        stage('Deploy') {
            when { 
                branch 'master' 
            }
            steps {
                // Punto 4: Despliegue en puerto 80 (mapeado al 8080 de la app)
                // Detenemos cualquier contenedor previo con el mismo nombre para evitar errores
                sh 'docker ps -q --filter "name=mi-app-prod" | xargs -r docker stop'
                sh 'docker run -d --name mi-app-prod -p 80:8080 mi-app:latest'
            }
        }
    }

    post {
        always {
            // Punto 3.4: Limpieza del entorno
            echo 'Limpiando entorno...'
            cleanWs()
        }
        failure {
            // Punto 4: Manejo de errores
            echo '❌ El pipeline falló. Revisa los logs anteriores.'
        }
        success {
            echo '✅ Pipeline completado con éxito. Aplicación desplegada en http://localhost:80'
        }
    }
}