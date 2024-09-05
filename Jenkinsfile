pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:1.4.0'
            args '-v /var/jenkins_home:/var/jenkins_home'
        }
    }

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

        stage('Terraform Init') {
            steps {
                sh '''
                terraform init \
                    -backend-config="bucket=${TF_STATE_BUCKET}" \
                    -backend-config="key=${TF_STATE_KEY}" \
                    -backend-config="region=${TF_STATE_REGION}"
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-key-secret', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh '''
                        export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                        export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                        
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
