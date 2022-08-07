pipeline{
  agent { node{ label'master' }}
  options {
    // Limit build history with buildDiscarder option:
    // daysToKeepStr: history is only kept up to this many days.
    // numToKeepStr: only this many build logs are kept.
    // artifactDaysToKeepStr: artifacts are only kept up to this many days.
    // artifactNumToKeepStr: only this many builds have their artifacts kept.
    buildDiscarder(logRotator(numToKeepStr: "1"))
    // Enable timestamps in build log console
    timestamps()
    // Maximum time to run the whole pipeline before canceling it
    timeout(time: 10, unit: 'HOURS')
    // Use Jenkins ANSI Color Plugin for log console
    ansiColor('xterm')
    // Limit build concurrency to 1 per branch
    disableConcurrentBuilds()
  }
  stages
  {
    stage('Build 32 bit image') {
      agent {
          docker {
              image 'xsangle/ci-yocto:focal'
              args ' --user root '
              // args '-v /var/jenkins_home/workspace/ant-http:/var/jenkins_home/workspace/ant-http'
              reuseNode true
          }
      }
      steps {
        sh '''#!/bin/bash
        printenv
        source ./env.sh
        diya -c 32
        diya -b 32
       '''
      }
    }
    stage('Build 64 bit image') {
      agent {
          docker {
              image 'xsangle/ci-yocto:focal'
              args ' --user root '
              // args '-v /var/jenkins_home/workspace/ant-http:/var/jenkins_home/workspace/ant-http'
              reuseNode true
          }
      }
      steps {
        sh '''#!/bin/bash
        printenv
        source ./env.sh
        diya -c 64
        diya -b 64
       '''
      }
    }
    stage('Archive') {
      steps {
        script {
          archiveArtifacts artifacts: '64/tmp/diya.image,32/tmp/diya.image,fonts/', fingerprint: true
        }
      }
    }
  }
}
