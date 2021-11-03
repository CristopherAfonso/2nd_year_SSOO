#!/bin/bash
# Cristopher Manuel Afonso Mora - alu0101402031
# sysinfo - Un script que informa del estado del sistema

##### Constantes
TITLE="Información del sistema para $HOSTNAME"
RIGHT_NOW=$(date +"%x %r%Z")
TIME_STAMP="Actualizada el $RIGHT_NOW por $USER"

HELP="--help"
filename=~/sysinfo.txt


##### Estilos
TEXT_BOLD=$(tput bold)
TEXT_GREEN=$(tput setaf 2)
TEXT_RESET=$(tput sgr0)

##### Funciones
system_info() # El comando uname -a muestra toda la información del sistema
{
  echo -e "Función drive_space:"
  echo "${TEXT_ULINE}Versión del sistema${TEXT_RESET}"
  uname -a
}

show_uptime() # Muestra la salida del comando uptime
{
  echo -e "\nFunción show_uptime:"
  echo "${TEXT_ULINE}Tiempo de encendido del sistema${TEXT_RESET}"
  uptime
}

drive_space() # Actividad 1: Implementar la función drive_space
{
  echo -e "\nFunción drive_space: (Actividad 1)"
  echo -e "${TEXT_ULINE}Espacio ocupado en las Particiones/Discos duros del sistema:${TEXT_RESET}\n"
  df -a
}

home_space() # Actividad 2: Implementar la función home_space
{
  echo -e "\nFunción home_space: (Actividad 2)"
  echo "Usado   Directorio"
  if [ "$USER" == "root" ]; then
    du -s /home/*/ | sort -r
  else
    du -s /home/$USER
  fi
}

write_page() 
{
  cat << _EOF_
  $TEXT_BOLD$TITLE$TEXT_RESET
  $TEXT_GREEN$TIME_STAMP$TEXT_RESET

  $(system_info)
  $(show_uptime)
  $(drive_space)
  $(home_space)

_EOF_
}


main_message()
{
  echo "Modo de uso: $0 [-f filename] [-i] [-h]"
  echo "Pruebe '$0 $HELP' para más información"
}

error_message()
{
  echo "Este programa no permite más de 1 parámetros pasado a la vez"
  echo "(excepto el -f que acepta un segundo paramétro a su derecha)"
  echo "Pruebe '$0 $HELP' para más información"
}

error_file() 
{
  echo "Para usar la opción -f hace falta un nombre válido de archivo"
  echo "Pruebe '$0 $HELP' para más información"
}

error_parameter()
{
  echo "Warning! el paramétro pasado a la función no es válido"
  echo "Pruebe '$0 $HELP' para más información"
}

usage() # Función que explica el modo de uso del programa
{
  echo "Modo de uso: $0 [-f filename] [-i] [-h]"
}

interactive_interface() # Funcion de Actividad 4
{
  while [ true ]; do
    echo -e "Elija entre estas tres opciones:"
    echo "Opción 1: Solo mostrar el informe por pantalla y cerrar el programa"
    echo "Opción 2: Solo guardar el informe con el nombre elegido y cerrar el programa"
    echo "Opción 3: Cerrar el programa ahora mismo sin hacer nada" # Metí esta opción porque quise
    echo "Introduzca 1, 2 ó 3 para realizar su elección, cualquier otra opción será rechazada"
    read selection
    echo -e "\n"
    case $selection in 
      1 )
        write_page
        break
        ;;
      2 )
        echo "Introduzca el nombre del archivo[~/sysinfo.txt]:"
        read filename
        echo ""
        if [ "$filename" == "" ]; then
          filename=~/sysinfo.txt
        fi
        if [ -f "$filename" ]; then
          while [ true ]; do
            echo "El archivo de destino existe. ¿Sobreescribir? (S/N)"
            read selection
            echo ""
            case $selection in
              S | s )
                write_page > $filename
                break
                ;;
              N | n )
                echo "No se ha efectuado ninguna tarea"
                echo "Fin del programa"
                break
                ;;
              * )
                echo -e "Por favor, eliga una opción válida\n"
            esac
          done
        else 
          write_page > $filename
        fi
        break
        ;;
      3 )
        echo "Fin del programa"
        break
        ;;
      * )
        echo -e "Opción inválida, intentelo de nuevo\n"
    esac
  done
}

##### Programa principal
# Filtros iniciales para que el programa no se cuelgue
if [ $# -eq 0 ]; then 
  main_message
  exit 0
fi

if [ $# -gt 2 ]; then
  error_message
  exit 1
fi

# Actividad 3: Opción -f
if [ "$2" == "" ]; then 
  if [ "$1" == "-f" ]; then
    write_page > $filename
    exit 0
  elif [ "$1" == "--file" ]; then
    write_page > $filename
    exit 0
  fi
else
  if [ "$1" == "-f" ]; then
    filename=$2
    write_page > $filename
    exit 0
  elif [ "$1" == "--file" ]; then
    filename=$2
    write_page > $filename
    exit 0
  else 
    error_parameter # Si $2 != "" y $1 no es ni -f ni --file, hay un error
    exit 1
  fi
fi

# Actividad 3: Opción -h
if [ "$1" == "$HELP" ]; then
  usage
  exit 0
elif [ "$1" == "-h" ]; then
  usage 
  exit 0
fi

# Actividad 4: Opción -i
if [ "$1" == "--interactive" ]; then
  interactive_interface
  exit 0
elif [ "$1" == "-i" ]; then
  interactive_interface
  exit 0
fi

error_parameter # Si solo hay un parámetro pero no es ni -i ni -h ni -f, hay un error
exit 1

