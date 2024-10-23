# Instalación y Verificación de Java y Maven en Sistemas Operativos

Este proyecto contiene dos scripts en **Bash** diseñados para facilitar la instalación y verificación de **Java** y **Maven** en sistemas operativos como **Windows**, **Linux** y **macOS**. Los scripts están preparados para gestionar la instalación de Java y la configuración de variables de entorno en función del sistema operativo, así como para verificar la instalación de Maven.

## Scripts

1. **`instalJava.sh`**: Este script verifica si **Java** está instalado en el sistema, y en caso contrario, redirige al usuario a la página de descarga de Java. Después de la instalación, también configura las variables de entorno necesarias de manera global en **Linux** y **macOS** y en el **registro de Windows**.
   
2. **`instalMVN.sh`**: Este script simplemente verifica si **Maven** está instalado en el sistema.

---

## Instrucciones de Uso

### 1. Dar permisos de ejecución a los scripts

Antes de ejecutar los scripts, es necesario otorgarles permisos de ejecución. Para ello, abre la terminal y navega al directorio donde se encuentran los archivos. Luego, ejecuta el siguiente comando:

```bash
chmod +x instalJava.sh instalMVN.sh
