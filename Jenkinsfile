pipeline {
    agent any
	options {
        skipStagesAfterUnstable()
    }
    stages {
		stage('Check Docker') {
            steps {
                sh 'docker ps -a'
                sh 'docker images'
            }
        }
        stage('Build') { 
            steps {
                sh 'dotnet restore' 
                sh 'dotnet build --no-restore' 
            }
        }
		stage('Test') {
            steps {
                sh 'dotnet test --no-build --no-restore'
            }
        }
		stage('Deploy') {
			steps {
				sh '''
					docker build -t simplewebapi:latest .
					docker stop simplewebapi || true
					docker rm simplewebapi || true
					docker run -d --name simplewebapi -p 5555:8888 simplewebapi:latest
				'''
			}
		}
    }
}