pipeline {
  agent any

  environment {
    EC2_USER = 'ubuntu'
    SSH_CREDENTIALS_ID = 'jarvis-server'
    REPO_DIR = '/home/ubuntu/jarvis'
    BRANCH = 'main'
  }

  parameters {
    string(name: 'EC2_HOST', defaultValue: '3.0.20.79', description: 'Public IP or hostname of EC2')
  }

  stages {

    stage('Prepare') {
      steps {
        script {
          if (!params.EC2_HOST?.trim()) {
            error "Provide EC2_HOST parameter"
          }
          env.EC2_HOST = params.EC2_HOST
        }
      }
    }

    stage('Update code on EC2') {
      steps {
        sshagent (credentials: [env.SSH_CREDENTIALS_ID]) {
          sh """
          ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} \\
          "cd ${REPO_DIR} && git fetch --all && git reset --hard origin/${BRANCH} || git clone https://github.com/chopadevivek07/Voice-Assistant-Application-on-EC2-Using-Terraform-and-Jenkins.git ${REPO_DIR}"
          """
        }
      }
    }

    stage('Install dependencies') {
      steps {
        sshagent (credentials: [env.SSH_CREDENTIALS_ID]) {
          sh """
          ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} \\
          "cd ${REPO_DIR} && python3 -m venv venv || true && source venv/bin/activate && if [ -f requirements.txt ]; then pip install -r requirements.txt; fi"
          """
        }
      }
    }
    
    stage('Verify') {
      steps {
        sshagent (credentials: [env.SSH_CREDENTIALS_ID]) {
          sh """
          ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} "sudo journalctl -u jarvis.service -n 50 --no-pager"
          """
        }
      }
    }
  }

  post {
    failure {
      echo "Pipeline failed — check build logs"
    }
  }
}
