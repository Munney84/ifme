pipeline {
    agent any
        stages {
            stage('Init') {
                steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('intTerraform') {
                              sh 'terraform init' 
                            }
         }
    }
   }
            stage('Plan') {
                steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('intTerraform') {
                              sh 'terraform plan -out plan.tfplan -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"' 
                            }
         }
    }
   }
            stage('Apply') {
                steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('intTerraform') {
                              sh 'terraform apply plan.tfplan' 
                            }
         }
    }
   }
             stage('Destroy') {
                 steps {
                 withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
                         string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                             dir('intTerraform') {
                               sh 'terraform destroy -auto-approve -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"'
       }
    }
    }
  }
 }
}
      
