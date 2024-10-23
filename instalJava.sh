#!/bin/bash

# Función para verificar si Java ya está instalado
check_java_installed(){
    if type -p java; then
        echo "Java ya está instalado en el sistema"
        java -version
        return 0
    else
        echo "Java no esta instalado."
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


# verificamos si ya esta instlado
check_java_installed
if [ $? -eq 0 ]; then
    read -p " ¿Quieres reinstalar Java? (y/n): " REINSTALL
    if [ "$REINSTALL" != "y" ]; then
        echo "Finalizando el script, no se instalar java"
        exit 0
    fi
fi

# Solicitar la ruta del instalador de Java si no está instalado o si el usuario desea reinstalar
requestJavaInstallerPath

# Instalador Java usando el instlador proporcionado por el usuario
echo "Instalando Java ..."
"$JAVA_INSTALLER_PATH" /s


# Definir la variable JAVA_HOME y agregarla a las variables de entorno del sistema
echo "Configurando JAVA_HOME..."
JAVA_HOME="/c/Program Files/Java/jdk-11"

# Usar reg.exe para escribir en el registro de Windows las variables de entorno del sistema
echo "Configurando variables de entorno..."

# Agregar JAVA_HOME
reg add "HKCU\Environment" /v JAVA_HOME /t REG_SZ /d "$JAVA_HOME" /f

# Agregar el bin de Java al PATH
reg add "HKCU\Environment" /v Path /t REG_EXPAND_SZ /d "%JAVA_HOME%\\bin" /f

# Actualizar el entorno para que los cambios sean inmediatos
echo "Actualizando las variables de entorno..."
source ~/.bashrc

# Verificar la instalación final
echo "Verificando la instalación de Java..."
java -version

echo "Instalación completada."