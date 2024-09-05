pipeline {
    agent any

    environment {
        TF_VERSION = '1.4.0'
        TF_STATE_BUCKET = 'lg-terraform-state-bucket'
        TF_STATE_KEY = 'terraform/state.tfstate'
        TF_STATE_REGION = 'ap-southeast-1'
    }

    stages {
        stage('Setup Terraform') {
            steps {
                script {
                    // Check if Terraform is already installed, else download it locally
                    sh '''
                    if ! command -v terraform >/dev/null 2>&1; then
                        echo "Terraform not found, installing..."
                        curl -LO https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
                        unzip terraform_${TF_VERSION}_linux_amd64.zip
                        mv terraform terraform_${TF_VERSION}  # Rename to avoid conflict
                        mkdir -p $HOME/bin
                        mv terraform_${TF_VERSION} $HOME/bin/terraform
                        export PATH=$PATH:$HOME/bin
                    else
                        echo "Terraform already installed."
                    fi
                    terraform --version
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

                        terraform init \
                            -backend-config="bucket=${TF_STATE_BUCKET}" \
                            -backend-config="key=${TF_STATE_KEY}" \
                            -backend-config="region=${TF_STATE_REGION}"
                        '''
                    }
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
                    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'AWS_ACCESS_KEY_ID'),
                                     string(credentialsId: 'AWS_SECRET_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh '''
                        export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                        export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}

                        terraform apply -auto-approve tfplan
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
