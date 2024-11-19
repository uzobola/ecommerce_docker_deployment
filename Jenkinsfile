pipeline {
    agent any

    environment {
        DOCKER_CREDS = credentials('docker-hub-credentials')
	DB_PASSWORD = credentials('db_password')
    }

    stages {
        stage('Build') {
            agent any
            steps {
                sh '''#!/bin/bash
                # Setup Python virtual environment
                echo "Setting up Python virtual environment..."

                python3.9 -m venv venv
                source venv/bin/activate
                pip install pip --upgrade
                # Install Python dependencies
                echo "Installing Python dependencies..."
                pip install --no-cache-dir -r backend/requirements.txt
                echo "Build stage completed successfully!"
                '''
            }
        }

        stage('Test') {
            agent any
            steps {
                sh '''#!/bin/bash
                source venv/bin/activate

                # Create directory for test reports
                mkdir -p test-reports

                # Run migrations on test database
                pip install pytest-django
                python backend/manage.py makemigrations
                python backend/manage.py migrate

                # Run tests
                pytest backend/account/tests.py --verbose --junit-xml test-reports/results.xml
                
                echo "Test stage completed successfully!"
                '''
            }
        }

        stage('Cleanup') {
            agent { label 'build-node' }
            steps {
                sh '''
                  # Only clean Docker system
                  docker system prune -f
                  
                  # Safer git clean that preserves terraform state
                  git clean -ffdx -e "*.tfstate*" -e ".terraform/*"
                '''
            }
        }

        stage('Build & Push Images') {
            agent { label 'build-node' }
            steps {
                sh 'echo ${DOCKER_CREDS_PSW} | docker login -u ${DOCKER_CREDS_USR} --password-stdin'
                
                // Build and push backend
                sh '''
                  docker build -t uzobol/ecommerce-backend:latest -f Dockerfile.backend .
                  docker push uzobol/ecommerce-backend:latest
                '''
                
                // Build and push frontend
                sh '''
                  docker build -t uzobol/ecommerce-frontend:latest -f Dockerfile.frontend .
                  docker push uzobol/ecommerce-frontend:latest
                '''
            }
        }

        stage('Terraform Plan') {
            agent { label 'build-node' }
            steps {
                dir('Terraform') {
                    sh '''
                    echo "Initializing Terraform..."
                    terraform init

                    echo "Running Terraform plan..."
                    terraform plan -out=tfplan \
                      -var="dockerhub_username=${DOCKER_CREDS_USR}" \
                      -var="dockerhub_password=${DOCKER_CREDS_PSW}"
		      -var="instance_type=t3.micro" \
              	      -var="key_name=uzo-wl6" \
                      -var="ami_id=ami-0c02fb55956c7d316" \
                      -var="vpc_cidr=10.0.0.0/16" \
                      -var='public_subnet_cidrs=["10.0.1.0/24", "10.0.2.0/24"]' \
                      -var='private_subnet_cidrs=["10.0.3.0/24", "10.0.4.0/24"]' \
                      -var='availability_zones=["us-east-1a", "us-east-1b"]' \
                      -var="db_username=userdb" \
                      -var="db_password=${DB_PASSWORD}"
		    '''
                }
            }
        }

        stage('Terraform Apply') {
            agent { label 'build-node' }
            steps {
                dir('Terraform') {
                    sh '''
                    echo "Applying Terraform configuration..."
                    terraform apply -auto-approve tfplan
                    '''
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline completed."
            sh '''
            docker logout
            docker system prune -f
            '''
        }

        success {
            echo "Terraform applied successfully!"
        }

        failure {
            echo "Pipeline failed. Cleaning up resources..."
            dir('Terraform') {
                sh '''
                terraform destroy -auto-approve \
                  -var="dockerhub_username=${DOCKER_CREDS_USR}" \
                  -var="dockerhub_password=${DOCKER_CREDS_PSW}"
                '''
            }
        }
    }
}

