pipeline {
    agent any

    environment {
        TF_VERSION = '1.9.5'
        LOCAL_TFSTATE_PATH = '/var/jenkins_home/terraform-state'
    }

    stages {
        stage('Setup Terraform') {
            steps {
                script {
                    sh '''
                    # Check if Terraform is already installed
                    if ! command -v /var/jenkins_home/bin/terraform >/dev/null 2>&1; then
                        echo "Terraform not found, installing..."
                        curl -LO https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
                        unzip terraform_${TF_VERSION}_linux_amd64.zip
                        mv terraform terraform_${TF_VERSION}
                        mkdir -p /var/jenkins_home/bin
                        mv terraform_${TF_VERSION} /var/jenkins_home/bin/terraform
                        chmod +x /var/jenkins_home/bin/terraform
                    else
                        echo "Terraform already installed."
                    fi
                    /var/jenkins_home/bin/terraform --version
                    '''
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
                    withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-key-secret', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh '''
                        export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                        export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                        /var/jenkins_home/bin/terraform init -backend-config="path=${LOCAL_TFSTATE_PATH}/terraform.tfstate" -reconfigure
                        '''
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh '/var/jenkins_home/bin/terraform plan -out=tfplan'
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
                        /var/jenkins_home/bin/terraform apply -auto-approve tfplan
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/*.tfstate*', allowEmptyArchive: true
            junit '**/test-results/*.xml'
            cleanWs()
        }

        success {
            echo 'Terraform deployment was successful!'
        }

        failure {
            echo 'Terraform deployment failed.'
        }
    }
}
