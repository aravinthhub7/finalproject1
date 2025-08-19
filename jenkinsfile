pipeline {
    agent any

    environment {
        BRANCH_NAME = "${env.GIT_BRANCH}".replace("origin/", "")
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/aravinthhub7/finalproject1.git'
            }
        }

        stage('Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials',
                                                 usernameVariable: 'DOCKERHUB_USER',
                                                 passwordVariable: 'DOCKERHUB_PASS')]) {
                    script {
                        if (BRANCH_NAME == "dev") {
                            env.IMAGE_TAG = "dev:latest"
                        } else if (BRANCH_NAME == "master") {
                            env.IMAGE_TAG = "prod:latest"
                        } else {
                            env.IMAGE_TAG = "test:latest"
                        }
                    }

                    sh '''
                        chmod +x build.sh deploy.sh
                        ./build.sh
                        ./deploy.sh
                    '''
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                sh '''
                    docker compose down || true
                    DOCKERHUB_USER=$DOCKERHUB_USER IMAGE_TAG=$IMAGE_TAG docker compose up -d
                '''
            }
        }
    }
}
