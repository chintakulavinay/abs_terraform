pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Set Environment') {
            steps {
                script {

                    if (env.BRANCH_NAME == 'dev') {
                        env.TF_DIR = 'environments/dev'
                    }
                    else if (env.BRANCH_NAME == 'qa') {
                        env.TF_DIR = 'environments/qa'
                    }
                    else if (env.BRANCH_NAME == 'main') {
                        env.TF_DIR = 'environments/prod'
                    }
                    else {
                        error "Unsupported branch: ${env.BRANCH_NAME}"
                    }

                    echo "Branch: ${env.BRANCH_NAME}"
                    echo "Terraform Directory: ${env.TF_DIR}"
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${env.TF_DIR}") {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding',
                         credentialsId: 'aws-terraform']
                    ]) {
                        bat 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir("${env.TF_DIR}") {
                    bat 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${env.TF_DIR}") {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding',
                         credentialsId: 'aws-terraform']
                    ]) {
                        bat 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Prod Approval') {
            when {
                branch 'main'
            }
            steps {
                input 'Approve Production Deployment?'
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${env.TF_DIR}") {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding',
                         credentialsId: 'aws-terraform']
                    ]) {
                        bat 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }
    }
}