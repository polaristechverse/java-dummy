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
    }
}
