@Library('Shared') _

pipeline {
    agent any

    environment{
        SONAR_HOME = tool "Sonar"
    }

    parameters {
        string(name: 'Easyshop_Tag', defaultValue: 'latest', description: 'docker image tag easyshop')
        string(name: 'Migration_Tag', defaultValue: 'latest', description: 'docker image tag for migration')
        booleanParam(name: 'RUN_MIGRATION', defaultValue: false, description: 'Build & push migration image?')
    }
    
    stages {

        stage("Validate Parameters") {
            steps {
                script {
                    if (params.Easyshop_Tag == '' || params.Migration_Tag == '') {
                        error("Easyshop_Tag and Migration_Tag must be provided.")
                    }
                }
            }
        }
        
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Clone Repository') {
            steps {
                git url: "https://github.com/nilesh-fatfatwale/easyshop",
                    branch: "dev"
            }
        }

        stage("SonarQube: Code Analysis"){
            steps{
                script{
                    sonarqube_analysis("Sonar","easyshop","easyshop")
                }
            }
        }

        stage("SonarQube: Code Quality Gates"){
            steps{
                script{
                    sonarqube_code_quality()
                }
            }
        }

        stage("OWASP: Dependency check"){
            steps{
                script{
                    owasp_dependency()
                }
            }
        }
        
        stage('Build Docker Images') {
            parallel {

                stage('Build Main App Image') {
                    steps {
                        script {
                            withCredentials([
                                usernamePassword(
                                    credentialsId: 'DockerHub',
                                    usernameVariable: 'dockerUsername',
                                    passwordVariable: 'dockerPassword'
                                )
                            ]) {
                                docker_build(
                                    "${dockerUsername}",
                                    "easyshop",
                                    "${params.Easyshop_Tag}"
                                )
                            }
                        }
                    }
                }

                stage('Build Migration Image') {
                    when { expression { params.RUN_MIGRATION } }
                    steps {
                        script {
                            withCredentials([
                                usernamePassword(
                                    credentialsId: 'DockerHub',
                                    usernameVariable: 'dockerUsername',
                                    passwordVariable: 'dockerPassword'
                                )
                            ]) {
                                docker_build_multi_env(
                                    dockerHubName: "${dockerUsername}",
                                    imageName: "migration",
                                    imageTag: "${params.Migration_Tag}",
                                    dockerfile: 'scripts/Dockerfile.migration',
                                    context: '.'
                                )
                            }
                        }
                    }
                }

            }
        }

        stage('Security Scan with Trivy') {
            steps {
                script {
                    trivy_scan()
                }
            }
        }

        stage('Push Docker Images') {
            parallel {

                stage('Push Main App Image') {
                    steps {
                        script {
                            withCredentials([
                                usernamePassword(
                                    credentialsId: 'DockerHub',
                                    usernameVariable: 'dockerUsername',
                                    passwordVariable: 'dockerPassword'
                                )
                            ]) {

                                sh "docker login -u ${dockerUsername} -p ${dockerPassword}"
                                sh "docker push ${dockerUsername}/easyshop:${params.Easyshop_Tag}"
                            }
                        }
                    }
                }

                stage('Push Migration Image') {
                    when { expression { params.RUN_MIGRATION } }
                    steps {
                        script {
                            withCredentials([
                                usernamePassword(
                                    credentialsId: 'DockerHub',
                                    usernameVariable: 'dockerUsername',
                                    passwordVariable: 'dockerPassword'
                                )
                            ]) {

                                sh "docker login -u ${dockerUsername} -p ${dockerPassword}"
                                sh "docker push ${dockerUsername}/migration:${params.Migration_Tag}"
                            }
                        }
                    }
                }

            }
        }

    }
}