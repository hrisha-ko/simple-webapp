pipeline {
    agent { 
        label 'centos' 
    }
    
    environment {
        dockerhub = credentials('dockerhub')
    }
    
    stages {
        stage('=====VARIABLES=====') {
            steps {
                sh "echo $dockerhub"
                sh "echo $USER"
                sh 'docker version'
            }
        }
    
        stage('Delete workspace before build starts') {
            steps {
                echo 'Deleting workspace'
                deleteDir()
            }
        }
    
        stage('=====Checkout=====') {
            steps{
                git branch: 'main', url: 'https://github.com/hrisha-ko/simple-webapp.git'
                sh "pwd"
                sh "ls -lan"    
            }
        }
        
        stage('=====Build docker image=====') {
            steps{
                sh 'pwd'
                sh 'docker build -t grishako2020/simple-webapp:0.1.3 .'
            }
        }
    
        stage('=====Push docker image to DockerHub=====') {
            steps{
                withDockerRegistry(credentialsId: 'dockerhubtoken', url: 'https://index.docker.io/v1/') {
                    sh '''
                        docker push grishako2020/simple-webapp:0.1.3
                    '''
                }
            }
        }
    
        stage('Remove local docker images') {
            steps{
                sh 'docker rmi grishako2020/simple-webapp:0.1.3'
            }
        }
    }
}