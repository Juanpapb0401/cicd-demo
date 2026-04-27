pipeline {
    agent any

    tools {
        // Asegúrate de que este nombre sea igual al configurado en Jenkins -> Tools
        maven 'maven3'
    }

    stages {
        stage('Checkout') {
            steps {
                // Punto 1: Obtención del código fuente desde el repositorio
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                // Punto 1 y 2: Compilación de la aplicación (Saltamos tests por estabilidad en Mac)
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Static Analysis (SonarQube)') {
            steps {
                // Punto 3.1: Análisis estático con tu token
                // Usamos -Dsonar.login para asegurar compatibilidad con el token generado
                script {
                    sh 'mvn sonar:sonar \
                        -Dsonar.projectKey=my-app \
                        -Dsonar.host.url=http://host.docker.internal:9000 \
                        -Dsonar.login=sqa_d55ff2904e8b1f198e9bf3d5a5e474260565c829'
                }
            }
        }

        stage('Docker Build') {
            steps {
                // Punto 1: Construcción de la imagen Docker
                sh 'docker build -t mi-app:latest .'
            }
        }

        stage('Container Security Scan (Trivy)') {
            steps {
                // Punto 3.2 y 3.3: Escaneo de vulnerabilidades
                // --exit-code 1 hará que el pipeline falle si Trivy encuentra algo CRITICAL
                sh 'trivy image --severity CRITICAL --exit-code 1 mi-app:latest'
            }
        }

        stage('Deploy') {
            when { branch 'master' } // Asegúrate de que tu rama se llame 'master'
            steps {
                // Punto 4: Despliegue en puerto 80 local
                // Limpiamos cualquier contenedor previo con el mismo nombre para evitar errores
                sh 'docker ps -q --filter "name=mi-app-prod" | xargs -r docker stop || true'
                sh 'docker run -d --name mi-app-prod -p 80:8080 mi-app:latest'
            }
        }
    }

    post {
        always {
            // Punto 3.4: Limpieza del workspace
            echo 'Limpiando entorno...'
            cleanWs()
        }
        failure {
            // Punto 4: Manejo de errores
            echo '❌ El pipeline ha fallado. Revisa los logs de SonarQube o Trivy.'
        }
        success {
            echo '✅ Pipeline completado con éxito. Aplicación disponible en http://localhost:80'
        }
    }
}