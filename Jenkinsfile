@Library('Shared') _

pipeline {
    agent any
    
    parameters {
        string(name: 'Easyshop_Tag', defaultValue: 'latest', description: 'docker image tag easyshop')
        string(name: 'Migration_Tag', defaultValue: 'latest', description: 'docker image tag for migration')
    }
    
    stages {

        stage("Validate Parameters") {
            steps {
                script {
                    if (params.Fullstack_Backend_Tag == '' || params.Fullstack_Frontend_Tag == '') {
                        error("Fullstack_Backend_Tag and Fullstack_Frontend_Tag must be provided.")
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
