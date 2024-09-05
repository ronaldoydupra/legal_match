pipeline {
    agent any

    environment {
        TF_VERSION = '1.4.0'  // Specify the Terraform version you're using
        TF_STATE_BUCKET = 'lg-terraform-state-bucket'  // S3 bucket for storing Terraform state
        TF_STATE_KEY = 'terraform/state.tfstate'  // Key for the Terraform state file in the bucket
        TF_STATE_REGION = 'ap-southeast-1'  // AWS region for the S3 bucket
    }

    stages {
        stage('Setup') {
            steps {
                script {
                    // Install Terraform if it's not already available
                    sh 'curl -LO https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip'
                    sh 'unzip terraform_${TF_VERSION}_linux_amd64.zip'
                    sh 'sudo mv terraform /usr/local/bin/'
                    sh 'terraform version'
                }
            }
        }

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh '''
                    terraform init \
                        -backend-config="bucket=${TF_STATE_BUCKET}" \
                        -backend-config="key=${TF_STATE_KEY}" \
                        -backend-config="region=${TF_STATE_REGION}"
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-key-secret', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh '''
                        export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                        export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                        
                        # Verify Terraform is in PATH
                        terraform --version
                        
                        terraform apply -auto-approve tfplan
                      '''
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/*.tfstate*', allowEmptyArchive: true
            junit '**/test-results/*.xml'
        }

        success {
            echo 'Terraform deployment was successful!'
        }

        failure {
            echo 'Terraform deployment failed.'
        }
    }
}
}
