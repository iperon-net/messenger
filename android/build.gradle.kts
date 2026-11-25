allprojects {
    repositories {
        google()
        mavenCentral()
        // VK ID SDK (third_party/vkid_flutter_sdk): артефакты VK живут в Nexus — старый
        // Artifactory (artifactory-external.vkpartner.ru) их больше не отдаёт. Кроме
        // com.vk.* оттуда приходит tracer (ru.ok.tracer, зависимость tracking-tracer).
        // Фильтр — чтобы репозиторий VK не стал источником чужих библиотек.
        maven {
            url = uri("https://nexus-external.vkteam.ru/repository/maven/")
            content { includeGroupByRegex("(com\\.vk|ru\\.ok\\.tracer)(\\..*)?") }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
