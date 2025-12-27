pipeline {
    agent any

    parameters {
        booleanParam(
            name: 'FORCE_DEPLOY',
            defaultValue: false,
            description: 'Force build & deploy even if no service changes detected'
        )
    }

    environment {
        NO_CHANGES = "false"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out source code"
                checkout scm
            }
        }
        stage('Detect Changes') {
            steps {
                echo "Detecting changed services"

                sh '''
                  chmod +x detect-changes.sh
                  ./detect-changes.sh
                '''

                script {
                    if (!fileExists('changed-services.txt') ||
                        readFile('changed-services.txt').trim() == "") {

                        if (params.FORCE_DEPLOY) {
                            echo "No code changes, but FORCE_DEPLOY enabled"
                            env.NO_CHANGES = "false"
                        } else {
                            echo "No services changed"
                            env.NO_CHANGES = "true"
                            currentBuild.result = 'SUCCESS'
                        }

                    } else {
                        env.NO_CHANGES = "false"
                    }
                }
            }
        }
        stage('Build Changed Services') {
            when {
                expression { env.NO_CHANGES != "true" }
            }
            steps {
                script {
                    def changes = readFile('changed-services.txt').trim()

                    changes.split('\n').each { line ->
                        def parts = line.split(' ')
                        def serviceDir = parts[0]
                        def imageName  = parts[1]

                        echo "🛠 Building ${serviceDir} → ${imageName}"

                        dir(serviceDir) {
                            if (fileExists('pom.xml')) {
                                sh 'mvn clean package -DskipTests'
                            }
                            sh "docker build -t ${imageName} ."
                        }
                    }
                }
            }
        }
        stage('Deploy Changed Services') {
            when {
                expression { env.NO_CHANGES != "true" }
            }
            steps {
                script {
                    def changes = readFile('changed-services.txt').trim()

                    changes.split('\n').each { line ->
                        def serviceDir = line.split(' ')[0]
                        def serviceName = serviceDir.replace('-service','')

                        echo "♻ Deploying ${serviceName}"

                        sh """
                          docker-compose stop ${serviceName} || true
                          docker-compose rm -f ${serviceName} || true
                          docker-compose up -d ${serviceName}
                        """
                    }
                }
            }
        }
    }
}
