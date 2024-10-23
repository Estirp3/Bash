#!/bin/bash

# Función para verificar si Java ya está instalado
check_java_installed(){
    if type -p mvn; then
        echo "Maven ya está instalado en el sistema"
        mvn --v
        return 0
    else
        echo "maven no esta instalado."
        return 1
    fi
}


check_java_installed