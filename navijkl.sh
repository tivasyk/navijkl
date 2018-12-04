#!/bin/bash
#-------------------------------------------------------------------------------
# Скрипт для налаштування навігації клавішами Capslock+IJKL
# Використання: ./navijkl.sh
# ----- >8 ------
# tivasyk <tivasyk@gmail.com> (2018)
#-------------------------------------------------------------------------------
CAPS_CONF="capslock.xmodmap"
IJKL_CONF="ijkl.xkbcomp"
LOAD_CONF="${CAPS_CONF} ${IJKL_CONF}"

# loadconfig завантажує один файл конфігурації за допомогою xmodmap чи xkbcomp,
# залежно від розширення файлу
loadconfig () {
    if [[ -e $1 ]] ; then
        FILE_CONF=$1
        case ${FILE_CONF##*.} in 
        "xmodmap")
            echo -n "Loading ${FILE_CONF} with xmodmap... "
            xmodmap ${FILE_CONF} && echo "OK" || echo "Error!"
            ;;
        "xkbcomp")
            echo -n "Loading ${FILE_CONF} with xkbcomp... "
            xkbcomp -w 0 ${FILE_CONF} $DISPLAY && echo "OK" || echo "Error!"
            ;;
        *)
            echo "Unrecognized configuration file: ${FILE_CONF}"
            ;;
        esac
    else
        echo "Config ${CAPS_CONF} is missing!"
    fi
}

#-------------------------------------------------------------------------------
# цей фрагмент запозичено зі stackoverflos: https://stackoverflow.com/a/246128/6123418
# він визначає батьківську теку скрипта, навіть якщо доводиться "розкрутити"
# ланцюжок символьних посилань
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"

# проста запускалка скриптів, перелічених у $LOAD_CONFIG
for FILE in ${LOAD_CONF} ; do
    loadconfig "${DIR}/${FILE}"
done
