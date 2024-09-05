pipeline {
    agent any
    environment {
        GIT_REPO = 'https://github.com/ronaldoydupra/legal-match.git'
        AWS_REGION = 'ap-southeast-1'
        TERRAFORM_DIR = "${env.WORKSPACE}/terraform"
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
                        # Create a directory for Terraform binaries
                        mkdir -p ${TERRAFORM_DIR}
                        
                        # Download Terraform if not already present
                        if [ ! -f "${TERRAFORM_DIR}/terraform" ]; then
                            curl -o terraform.zip https://releases.hashicorp.com/terraform/1.9.5/https://releases.hashicorp.com/terraform/1.9.5/terraform_1.9.5_linux_arm64.zip
                            unzip terraform.zip -d ${TERRAFORM_DIR}
                        fi
                        
                        # Add Terraform to the PATH
                        export PATH=${TERRAFORM_DIR}:$PATH
                        
                        # Verify Terraform installation
                        terraform --version
                        
                        # Initialize Terraform
                        terraform init
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-key-secret', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh '''
                        export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                        export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                        
                        # Verify Terraform is in PATH
                        terraform --version
                        
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
