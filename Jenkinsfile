pipeline {
    agent any

    tools {
        maven 'maven3'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Static Analysis (SonarQube)') {
            steps {
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
                sh 'docker build -t mi-app:latest . '
            }
        }

        stage('Container Security Scan (Trivy)') {
            steps {
                sh 'trivy image --severity CRITICAL --exit-code 0 mi-app:latest'
            }
        }

        stage('Deploy') {
            steps {
                // Ahora se ejecutará siempre
                sh 'docker stop mi-app-prod || true'
                sh 'docker rm mi-app-prod || true'
                sh 'docker run -d --name mi-app-prod -p 80:8080 mi-app:latest'
            }
        }
    }

    post {
        always {
            echo 'Limpiando entorno...'
            cleanWs()
        }
        success {
            echo '✅ Pipeline completado. Aplicación en http://localhost:80'
        }
        failure {
            echo '❌ El pipeline falló.'
        }
    }
}