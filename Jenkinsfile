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
