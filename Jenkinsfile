pipeline {
    agent any

    environment {
        AZURE_SUBSCRIPTION_ID='0fd4cead-96dd-4544-af2b-c27c3bf1b7e9'
        AZURE_TENANT_ID='89dc1d2c-a8dd-4803-b8ef-1c8963b09b20'
        CONTAINER_REGISTRY='devacr83'
        RESOURCE_GROUP='dev-acr-rg'
        REPO="python-repo"
        IMAGE_NAME="django-app"
        TAG="latest"
    }

    stages {
        stage('Login to Azure account') {
                            
            
            steps {
                               echo "Login to Azure cloud"
                withCredentials([usernamePassword(credentialsId: 'azure-cred', passwordVariable: 'AZURE_CLIENT_SECRET', usernameVariable: 'AZURE_CLIENT_ID')]) {
                          /*sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'*/ 
                            sh 'az login --tenant -t $AZURE_TENANT_ID'
                            sh 'az account set -s $AZURE_SUBSCRIPTION_ID'
                               echo "Finish Login to Azure cloud"
                            
                        }
                             
            }
        }
        
        stage('Login to container registry') {
                             
                             
            steps {
                             echo "Login to Container registry"
                withCredentials([usernamePassword(credentialsId: 'azure-cred', passwordVariable: 'AZURE_CLIENT_SECRET', usernameVariable: 'AZURE_CLIENT_ID')]) 
                       {
                            
                            sh 'az acr login --name $CONTAINER_REGISTRY --resource-group $RESOURCE_GROUP'
                             echo "Finish Login to Container registry"
                        }
                              
            }
        }
        
        stage('Build Image') {
                               
            steps {
                              echo "Start Image building"
                withCredentials([/*usernamePassword*/azureServicePrincipal(credentialsId:'Azure-credentials', passwordVariable: 'AZURE_CLIENT_SECRET', usernameVariable: 'AZURE_CLIENT_ID')]) {
                            
                            sh 'az acr build --image $REPO/$IMAGE_NAME:$TAG --registry $CONTAINER_REGISTRY --resource-group dev-acr-rg --file Dockerfile .' 
                              echo "Finish Image building"
                        }
            }
                               
        }
        
       stage('Container Deployment'){
                              
             steps {
                              echo "Start kubernetes deployment"
                           script{
                                kubernetesDeploy(
                                             configs: 'k8s.yaml',
                                             kubeconfigId: 'k8s-2',
                                             enableConfigSubstitution: false
                          )
                   }
                              echo "Finish kubernetes deployment"
              }
       }
   
    }
}