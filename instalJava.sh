#!/bin/bash

# Función para verificar si Java ya está instalado
check_java_installed(){
    if type -p java; then
        echo "Java ya está instalado en el sistema"
        java -version
        return 0
    else
        echo "Java no está instalado."
        return 1
    fi
}

# Función para solicitar la ruta del instalador de Java
requestJavaInstallerPath (){
    read -p "Favor de introducir la ruta completa del instalador (ejemplo: /c/Users/tu_usuario/Downloads/jdk-11_windows-x64_bin.exe): " JAVA_INSTALLER_PATH
    if [[ ! -f "$JAVA_INSTALLER_PATH" ]]; then
        echo "El archivo en la ruta especificada no existe."
        read -p "¿Quieres abrir la página de descarga en el navegador? (y/n): " DESCARGA
        if [ "$DESCARGA" == "y" ]; then
            echo "Abriendo la página de descarga de Java en el navegador..."
            # Dependiendo del sistema operativo, se usa el comando adecuado:
            if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                xdg-open "https://www.java.com/es/download/ie_manual.jsp"
            elif [[ "$OSTYPE" == "darwin"* ]]; then
                open "https://www.java.com/es/download/ie_manual.jsp"
            elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
                start "https://www.java.com/es/download/ie_manual.jsp"
            else
                echo "No se puede determinar el sistema operativo. Abre manualmente la página de descarga."
            fi
            exit 0
        else
            echo "No se ha descargado el archivo. Saliendo..."
            exit 1
        fi
    else
        echo "El archivo del instalador existe. Continuando con el proceso..."
    fi
}

# Función para configurar las variables de entorno
configure_environment() {
    echo "Configurando las variables de entorno..."
    if [[ "$OSTYPE" == "linux-gnu"* || "$OSTYPE" == "darwin"* ]]; then
        # Para Linux y macOS
        JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
        echo "export JAVA_HOME=$JAVA_HOME" | sudo tee -a /etc/profile
        echo "export PATH=\$PATH:\$JAVA_HOME/bin" | sudo tee -a /etc/profile
        echo "Actualizando el entorno global para Linux/macOS..."
        source /etc/profile
    elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        # Para Windows
        JAVA_HOME="/c/Program Files/Java/jdk-11"
        echo "Configurando JAVA_HOME para Windows..."
        reg add "HKCU\Environment" /v JAVA_HOME /t REG_SZ /d "$JAVA_HOME" /f
        reg add "HKCU\Environment" /v Path /t REG_EXPAND_SZ /d "%JAVA_HOME%\\bin" /f
        echo "Actualizando el entorno para Windows..."
        source ~/.bashrc
    else
        echo "No se pudo configurar las variables de entorno. Sistema operativo no reconocido."
        exit 1
    fi
}

# Verificar si Java ya está instalado
check_java_installed
if [ $? -eq 0 ]; then
    read -p "¿Quieres reinstalar Java? (y/n): " REINSTALL
    if [ "$REINSTALL" != "y" ]; then
        echo "Finalizando el script, no se instalará Java."
        exit 0
    fi
fi

# Solicitar la ruta del instalador de Java si no está instalado o si el usuario desea reinstalar
requestJavaInstallerPath

# Instalar Java usando el instalador proporcionado por el usuario
echo "Instalando Java..."
"$JAVA_INSTALLER_PATH" /s

# Configurar las variables de entorno según el sistema operativo
configure_environment

# Verificar la instalación final de Java
echo "Verificando la instalación de Java..."
java -version

echo "Instalación completada."
