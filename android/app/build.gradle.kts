plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.app"
    
    // CORREÇÃO 1: Definir o SDK mais alto (36), conforme exigido pelos plugins.
    compileSdk = 36 
    
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Correção para o erro de Desugaring (Já estava correto, mas mantemos)
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.app"
        minSdk = flutter.minSdkVersion
        
        // CORREÇÃO 2: targetSdk deve ser igual ao compileSdk
        targetSdk = 36 
        
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}