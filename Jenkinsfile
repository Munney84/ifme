pipeline {
    agent any
        stages {
            stage ('Init'){
                steps {
                    sh '''#!/bin/bash
                    python3 -m venv test3
                    source  test3/bin/activate
                    pip install pip --upgrade
                    pip install -r requirements.txt
                    export FLASK_APP=application
             
                    '''
                }
            }
            
            stage ('Test'){
                steps {
                    sh '''#!/bin/bash
                    source test3/bin/activate
                    py.test --verbose --junit-xml  test-reports/results.xml
                    '''
                }
                post {
                    always {
                        junit 'test-reports/results.xml'
                    }
                }
            }

            stage ('Create_Image'){
                agent{label 'docker_agent'}
                steps {
                withCredentials([string(credentialsId: 'DOCKERHUB_UNAME', variable: 'dockerhub_uname'),
                                    string(credentialsId: 'DOCKERHUB_PASSWD', variable: 'dockerhub_passwd')]) {
                    sh ''' #!/bin/bash
                    apt update
                    #grab the dockerfile to create the image and redirect standard output to a file
                    curl https://raw.githubusercontent.com/Munney84/kuralabs_deployment_5/main/dockerfile > dockerfile
                    docker build -t munney84/deployment:dep5 dockerfile
                    
                    '''
                    
                    }
                }
            }
            stage ('Push_to_Docker'){
                agent{label 'docker_agent'}
                steps {
                withCredentials([string(credentialsId: 'DOCKERHUB_UNAME', variable: 'dockerhub_uname'),
                                    string(credentialsId: 'DOCKERHUB_PASSWD', variable: 'dockerhub_passwd')]) {
                    sh '''#!/bin/bash
                    docker login -u ${dockerhub_uname} -p ${dockerhub_passwd}
                    docker push munney84/deployment:dep5
                    docker logout
                    '''
                    
                    }
                }
            }

            stage ('Deploy_to_ECS'){
                agent{label 'terraform'}
                steps {
                withCredentials([string(credentialsId: '', variable: 'dockerhub_uname'),
                                    string(credentialsId: 'DOCKERHUB_PASSWD', variable: 'dockerhub_passwd')]) {
                    
                    
                    }
                }
            }
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
//   }
//  }
// }
  //}
 }
}
      
