pipeline {
  agent any

  environment {
    DOCKER_CREDS = credentials('docker-hub-credentials')
  }

  stages {
    stage ('Build') {
      agent any
      steps {
        sh '''#!/bin/bash
        # Setup Python virtual environment
        echo "Setting up Python virtual environment..."
	cd /home/ubuntu/ecommerce_docker_deployment/
        python3 -m venv venv
        source venv/bin/activate

        # Install Python dependencies
        echo "Installing Python dependencies..."
        pip install --no-cache-dir -r requirements.txt
	pip install pytest-django
            
	# Set up Backend
        echo "Setting up the backend..."
        cd backend
        python manage.py makemigrations account
        python manage.py makemigrations payments
        python manage.py makemigrations product
        cd ..

        #Set up Frontend 
        echo "Building frontend..."
        cd frontend
        if ! command -v npm &> /dev/null; then
             echo "npm is not installed. Installing..."
    	     sudo apt install -y nodejs npm
	fi
        npm ci
        npm run build
        cd ..
            
        echo "Build stage completed successfully!"
	'''
      }
    }

    stage ('Test') {
      agent any
      steps {
        sh '''#!/bin/bash
        echo "Starting test stage..."
        cd /home/ubuntu/ecommerce_docker_deployment/
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
          docker build -t <backend image tagged for dockerhub>:latest -f Dockerfile.backend .
          docker push <backend image tagged for dockerhub:latest
        '''
        
        // Build and push frontend
        sh '''
          docker build -t <frontent image tagged for dockerhub>:latest -f Dockerfile.frontend .
          docker push <frontend image tagged for dockerhub>:latest
        '''
      }
    }

    stage('Infrastructure') {
      agent { label 'build-node' }
      steps {
        dir('Terraform') {
          sh '''
            terraform init
            terraform apply -auto-approve \
              -var="dockerhub_username=${DOCKER_CREDS_USR}" \
              -var="dockerhub_password=${DOCKER_CREDS_PSW}"
          '''
        }
      }
    }
  }

  post {
    always {
      agent { label 'build-node' }
      steps {
        sh '''
          docker logout
          docker system prune -f
        '''
      }
    }
  }
}
