pipeline {
    agent any

    environment {
        TF_STATE_BUCKET = 'lg-terraform-state-bucket'
        TF_STATE_KEY = 'terraform/state.tfstate'
        TF_STATE_REGION = 'ap-southeast-1'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Run Terraform in Docker') {
            steps {
                script {
                    // Run the hashicorp/terraform Docker image to execute Terraform commands
                    sh '''
                    docker run --rm \
                        -v $(pwd):/workspace \
                        -w /workspace \
                        -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
                        -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
                        hashicorp/terraform:1.4.0 \
                        terraform init -backend-config="bucket=${TF_STATE_BUCKET}" \
                                       -backend-config="key=${TF_STATE_KEY}" \
                                       -backend-config="region=${TF_STATE_REGION}"

                    docker run --rm \
                        -v $(pwd):/workspace \
                        -w /workspace \
                        -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
                        -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
                        hashicorp/terraform:1.4.0 \
                        terraform plan -out=tfplan
                    '''
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                script {
                    sh '''
                    docker run --rm \
                        -v $(pwd):/workspace \
                        -w /workspace \
                        -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
                        -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
                        hashicorp/terraform:1.4.0 \
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
