pipeline {
    agent {
        label 'Dev'
    }
    stages{
        stage('SCM CHECKOUT'){
            steps{
                echo "Checking out source code"
                checkout scm
            }
        }
        stage('Detect Changed Services') {
            steps {
                echo "Detecting which services changed"
                sh '''
                  chmod +x detect-changes.sh
                  ./detect-changes.sh
                '''
                script {
                    if (!fileExists('changed-services.txt') ||
                        readFile('changed-services.txt').trim() == "") {
                        echo "No services changed"
                        currentBuild.result = 'SUCCESS'
                        env.NO_CHANGES = "true"
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

                        echo "Building ${serviceDir} → ${imageName}"

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
                        def parts = line.split(' ')
                        def serviceDir = parts[0]
                        def imageName  = parts[1]

                        def containerName = serviceDir.replace('-service','')

                        echo "♻ Deploying ${containerName}"

                        sh """
                          docker stop ${containerName} || true
                          docker rm ${containerName} || true
                          docker run -d --name ${containerName} ${imageName}
                        """
                    }
                }
            }
        }
    }
}
