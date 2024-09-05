pipeline {
    agent any
    environment {
        GIT_REPO = 'https://github.com/ronaldoydupra/legal-match.git'
        AWS_REGION = 'ap-southeast-1'
    }
    parameters {
        booleanParam(name: 'CLEANUP', defaultValue: false, description: 'Clean up resources after deployment')
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: "${env.GIT_REPO}"
            }
        }

        stage('Setup Terraform') {
            steps {
                script {
                    sh '''
                        terraform --version || curl -o terraform.zip https://releases.hashicorp.com/terraform/1.0.0/terraform_1.0.0_linux_amd64.zip
                        unzip terraform.zip
                        mv terraform /usr/local/bin/
                        terraform init
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'AWS_SECRET_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh '''
                        export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                        export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                        terraform apply -auto-approve
                    '''
                }
            }
        }

        stage('Error Handling') {
            steps {
                script {
                    try {
                        sh 'terraform apply -auto-approve'
                    } catch (Exception e) {
                        error 'Terraform apply failed!'
                    }
                }
            }
        }

        stage('Cleanup') {
            when {
                expression { return params.CLEANUP }
            }
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
