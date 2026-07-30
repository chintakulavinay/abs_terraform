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
                    env.TF_DIR = 'environments/dev'

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
                        bat 'terraform plan -var-file=terraform.tfvars -out=tfplan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${env.TF_DIR}") {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding',
                         credentialsId: 'aws-terraform']
                    ]) {
                        bat 'terraform apply -auto-approve -var-file=terraform.tfvars tfplan'
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Dev deployment completed successfully.'
        }

        failure {
            echo 'Dev deployment failed.'
        }
    }
}