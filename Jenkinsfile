pipeline {
    agent any

    environment {
        TF_VERSION = '1.9.5'  // Define your Terraform version here
        LOCAL_TFSTATE_PATH = '/var/jenkins_home/terraform-state'
        CLEANUP_ENABLED = true  // Set this to false if you want to skip cleanup
    }

    stages {
        stage('Clone Git Repository') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        stage('Setup Terraform') {
            steps {
                script {
                    sh '''
                    # Check if Terraform is already installed
                    if ! command -v /var/jenkins_home/bin/terraform >/dev/null 2>&1; then
                        echo "Terraform not found, installing..."
                        curl -LO https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
                        unzip terraform_${TF_VERSION}_linux_amd64.zip
                        mkdir -p /var/jenkins_home/bin
                        mv terraform terraform_${TF_VERSION}
                        chmod +x /var/jenkins_home/bin/terraform
                    else
                        echo "Terraform already installed."
                    fi
                    /var/jenkins_home/bin/terraform --version
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-key-secret', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh '''
                        mkdir -p ${LOCAL_TFSTATE_PATH}
                        export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                        export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                        /var/jenkins_home/bin/terraform init -backend-config="path=${LOCAL_TFSTATE_PATH}/terraform.tfstate" -reconfigure
                        '''
                    }
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
                        /var/jenkins_home/bin/terraform apply -auto-approve
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                // Cleanup stage based on the flag
                if (env.CLEANUP_ENABLED.toBoolean()) {
                    echo 'Cleaning up Terraform-managed infrastructure...'
                    withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-key-secret', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh '''
                        export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                        export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                        /var/jenkins_home/bin/terraform destroy -auto-approve
                        '''
                    }
                } else {
                    echo 'Cleanup step is disabled.'
                }
            }
        }

        success {
            echo 'Terraform deployment was successful!'
        }

        failure {
            echo 'Terraform deployment failed.'
            // Optional: Add notification or additional error handling here
        }

        cleanup {
            cleanWs()  // Clean workspace
        }
    }
}
