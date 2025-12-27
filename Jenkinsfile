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
    }
}
