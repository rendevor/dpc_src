// This is a dummy Jenkinsfile

//@Library("Libname1@releasever1")_

pipeline {
    agent any

/*
The agent is a quite wide option here. Originally it should not be here pinned to any node. Ideally - none. But sometimes it's impossible due to various circumstances. 
Interesting options for further agents:
Docker in docker, k8s, nomad, and cloud plugins. 
If it's required to use VMs, better to use the swarm plugin (not docker swarm). The jenkins swarm provides the feature to spin up the node and assign a label on it. 
The example below in code. 

*/

    
    
/*
Libraries in various scopes: Global/Product/Project/Application/Purposes.
All libraries' versions should be pinned to a particular release version. Pinning master branch isn't good idea, to avoid impacting various products/teams. 
*/    
    stages {
        stage ("Set version") {
            agent {
                label "linux && wsl2"
            }
            steps {
                script {
                    env.GIT_VERSION = getVersion()
                    env.GIT_VERSION_DOCKER = env.GIT_VERSION.replace('+','__')
                    currentBuild.displayName = env.GIT_VERSION
                }
            }
        }
        stage ("Spinup build env") {
            //agent should be applied for this action. It could be dockerized
            steps {
                echo "Spinupping magic. Custom script/terraform/ansible/whatever steps"
                echo "Agent will be connected to master with name and hash. It should be used via the label assigned on it (my-super-laber-for-this-build)"
                echo "Good idea to connect this host additionally to Prometheus to collect host utilization during the build process"
                echo "If it's required, adding this node to dns/consul with a meaningful name in case to find this node easily in case this host should be alive after usage"
                echo "note: node name could be used as a label"
            }
        }
        stage("Build") {
            /* agent {
                label "my-super-laber-for-this-build" || "some-magic-another-label"
            }
            */
            agent {
                label "linux && wsl2"
            }
            steps {
                echo """
    Build magic is here.
    If it's necessarily better to wrap this step into a docker image via agent/docker option for stage. But docker should be pulled from internal artifactory by SemVer tag.
                """
                sh "echo \$GIT_VERSION_DOCKER > src/dpc-app-current-version.txt"
                sh "docker build -f app.Dockerfile -t dpc-app:latest -t dpc-app:\$GIT_VERSION_DOCKER ."
            }
        }
        stage ("Destroy build host") {
            //agent should be applied for this action. It could be dockerized
            // when ....
            steps {
                echo "this stage could be optional by when a condition or even moved to the end of pipeline."
            }
        }
        stage("Func tests") {
            
            steps {
             //   library "Libname1@releasever1" 
                echo "Test Magic here"
                echo "Publishing results to external DB such as ElasticSearch is good idea"
            }
        }
        stage("Safety and Security") {
            // when 
            steps {
                echo "Extramagic to use license scanning, whitesource, Sonarqube, Synaptic, veracode, Fortify etc. "
                echo "Sometimes it's not necessary to run it daily. Another schedule better to apply."
            }
        }
        stage("Delivery") {
            // Upload artifacts and build info into Artifactory/Nexus/smb/whatever. For scanning also could be used X-Ray Artifactory feature, if this is enabled
            steps {
                echo "Uploading"
            }
        }
        stage("Deploy") {
            steps {
                echo "Risky step and depends on many conditions. Sometimes it could be here, sometimes it should be manually invoked."
            }
        }
    }
    post {
            always {
                echo "done"
            }
        }
}

def getVersion () {
    def ver = sh (script: 'docker run --rm -v "$(pwd):/repo" gittools/gitversion:5.6.6 /repo /output json /showvariable FullSemVer', returnStdout: true)
    echo "Current version is: $ver"
    return ver
}