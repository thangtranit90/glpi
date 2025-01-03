def stage_title(message) {
    echo "\033[1;35m[Stage: ${message}]\033[0m"
}

def step_title(message) {
    echo "\033[1;33m[Step: ${message}]\033[0m"
}

def info(message) {
    echo "\033[34m[Info] ${message}\033[0m"
}

def error(message) {
    echo "\033[31m[Error] ${message}\033[0m"
}

def success(message) {
    echo "\033[32m[Success] ${message}\033[0m"
}
String AWS_REGION="ap-southeast-1"
String AWS_ACCOUNT_ID="767397998121"
pipeline {
    agent any
    parameters {
        booleanParam defaultValue: true,
            description: 'Parameter to know if you want to rebuild the service.',
            name: 'BUILD'
        
        booleanParam defaultValue: true,
            description: 'Parameter to know if you want to deploy the service.',
            name: 'DEPLOY'
    }
    
    environment{
        URL_ECR_NGINX = "767397998121.dkr.ecr.ap-southeast-1.amazonaws.com/glpi-nginx"
        URL_ECR_PHP = "767397998121.dkr.ecr.ap-southeast-1.amazonaws.com/glpi-php"
        TASK_DEFINITION =""
        NEW_TASK_DEFINITION=""
        NEW_TASK_INFO=""
        NEW_REVISION=""
        TASK_FAMILY=""
        GLPI_VERSION = ""
        GLPI_SAML_VERSION = ""        
    }
    stages {
        stage('Load Environment Variables') {
            when {
                anyOf {
                    environment name : 'BUILD', value: 'true'
                }
            }            
            steps {
                stage_title('======== Load enviroment from file========')
                script {
                    def envFile = readFile('.env')
                    envFile.split('\n').each { line ->
                        if (!line.startsWith("#") && line.contains("=")) {
                            def parts = line.split("=")
                            def key = parts[0].trim()
                            def value = parts[1].trim()
                            env[key] = value
                        }
                    }
                }
            }
        }

        stage('Build and Push App Image') {
            when {
                anyOf {
                    environment name : 'BUILD', value: 'true'
                }
            }
            steps {
                    stage_title('======== Build and Push App Image GLPI NGINX========')
                    dir('nginx') {
                        sh '''
                            aws ecr get-login-password --region ${AWS_REGION} | \
                            docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                        '''
                        // Build and push image to ECR
                        step_title('Build and push image to ECR')
                        sh """
                            docker build \
                                --no-cache \
                                -t ${URL_ECR_NGINX}:latest \
                                .
                            docker push ${URL_ECR_NGINX}:latest
                        """
                    }
                    stage_title('======== Build and Push App Image GLPI PHP========')
                    dir('php-fpm') {
                        sh '''
                            aws ecr get-login-password --region ${AWS_REGION} | \
                            docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                        '''

                        // Build and push image to ECR
                        step_title('Build and push image to ECR')
                        sh """
                            docker build \
                                --no-cache \
                                -t ${URL_ECR_PHP}:latest \
                                .
                            docker push ${URL_ECR_PHP}:latest

                        """
                    }
                }
            }
        }
        
        stage('Update task definition and force deploy ecs service') {
            when {
                expression {
                    def action=env.ACTION 
                    return action == 'BuildAndDeploy' || action == 'OnlyDeploy'
                }
            }
            steps {
                sh '''
                    TASK_DEFINITION=$(aws ecs describe-task-definition --task-definition ${TASK_FAMILY} --region "ap-southeast-1")
                    NEW_TASK_DEFINITION=$(echo $TASK_DEFINITION | jq --arg IMAGE "${FULL_IMAGE}" '.taskDefinition | .containerDefinitions[0].image = $IMAGE | del(.taskDefinitionArn) | del(.revision) | del(.status) | del(.requiresAttributes) | del(.compatibilities) |  del(.registeredAt)  | del(.registeredBy)')
                    NEW_TASK_INFO=$(aws ecs register-task-definition --region "ap-southeast-1" --cli-input-json "$NEW_TASK_DEFINITION")
                    NEW_REVISION=$(echo $NEW_TASK_INFO | jq '.taskDefinition.revision')
                    aws ecs update-service --cluster udemy-devops-ecs-cluster --service nodejs-service --task-definition ${TASK_FAMILY}:${NEW_REVISION} --force-new-deployment
                '''
 
            }
        }
    }
    post{
        always{
            info("Cleaning up docker system and project folder")
            sh 'docker system prune -f'
            cleanWs(cleanWhenNotBuilt: false, deleteDirs: true, disableDeferredWipeout: true, notFailBuild: true, patterns: [[pattern: '**/jenkinswrite-*', type: 'EXCLUDE']])
        }
        success{
            success("Pipeline executed successfully")
        }
        failure{
            error("Pipeline execution failed")
        }    
}
