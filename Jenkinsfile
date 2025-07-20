pipeline {
    agent any
	options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Build') { 
            steps {
                sh 'dotnet restore' 
                sh 'dotnet build --no-restore' 
            }
        }
		stage('Test') {
            steps {
                sh 'dotnet test --no-build --no-restore --collect "XPlat Code Coverage"'
            }
            post {
                always {
                    recordCoverage(tools: [[parser: 'COBERTURA', pattern: '**/*.xml']], sourceDirectories: [[path: 'SimpleWebApi.Test/TestResults']])
                }
            }
        }
		stage('Deliver') {
            steps {
                sh 'dotnet publish SimpleWebApi --no-restore -o published'
            }
            post {
                success {
                    archiveArtifacts 'published/*.*'
                }
            }
        }
		stage('Deploy') {
			steps {
				sh '''
					docker build -t simplewebapi:latest .
					docker stop simplewebapi || true
					docker rm simplewebapi || true
					docker run -d --name simplewebapi -p 5000:80 simplewebapi:latest
				'''
			}
		}
    }
}