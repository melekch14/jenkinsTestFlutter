pipeline {
    agent any

    environment {
        FLUTTER_HOME = "C:\\flutter"
        PATH = "${env.FLUTTER_HOME}\\bin;${env.PATH}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Flutter Doctor') {
            steps {
                bat 'flutter doctor'
            }
        }

        stage('Dependencies') {
            steps {
                bat 'flutter pub get'
            }
        }

        stage('App Version') {
            steps {
                script {
                    def versionOutput = bat(
                        script: '@powershell -NoProfile -ExecutionPolicy Bypass -File scripts\\app_version.ps1',
                        returnStdout: true
                    ).trim()

                    def appVersion = [:]
                    versionOutput.readLines().each { line ->
                        if (line.contains('=')) {
                            def parts = line.split('=', 2)
                            appVersion[parts[0]] = parts[1]
                        }
                    }

                    env.APP_VERSION_FULL = appVersion.APP_VERSION_FULL
                    env.APP_VERSION = appVersion.APP_VERSION
                    env.APP_BUILD_NUMBER = appVersion.APP_BUILD_NUMBER
                    env.APP_APK_NAME = "app-release-${env.APP_VERSION_FULL}.apk"

                    currentBuild.displayName = "#${env.BUILD_NUMBER} v${env.APP_VERSION_FULL}"
                    currentBuild.description = "App version: ${env.APP_VERSION_FULL}"
                    echo "Building app version ${env.APP_VERSION_FULL}"
                }
            }
        }
		
		stage('Tests') {
			steps { 
				bat 'flutter test' 
				}
		}

        stage('Build APK') {
            steps {
                bat '''
                    flutter build apk --release --build-name=%APP_VERSION% --build-number=%APP_BUILD_NUMBER%
                    powershell -NoProfile -ExecutionPolicy Bypass -Command "Copy-Item -LiteralPath 'build\\app\\outputs\\flutter-apk\\app-release.apk' -Destination 'build\\app\\outputs\\flutter-apk\\%APP_APK_NAME%' -Force"
                '''
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: "build/app/outputs/flutter-apk/${env.APP_APK_NAME}"
        }
    }
}
