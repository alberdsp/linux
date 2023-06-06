#!/bin/bash

parametro=$1


# Si el parametro es "offwan" bloqueamos el trafico general y habilitamos la red local
if [ "$parametro" = "offwan" ]; then

  # Reseteamos las politicas y las establecemos nuevas
  sudo iptables -F
  sudo iptables -X
  sudo iptables -Z
  sudo iptables -t nat -F
  sudo iptables -t nat -X
  sudo iptables -t nat -Z
  sudo iptables -t mangle -F
  sudo iptables -t mangle -X
  sudo iptables -t mangle -Z
  sudo iptables -P INPUT ACCEPT
  sudo iptables -P FORWARD ACCEPT
  sudo iptables -P OUTPUT ACCEPT

  # Bloquemos trafico general y permitimos solo local

  sudo iptables -A OUTPUT -d 192.168.0.0/24 -j ACCEPT
  sudo iptables -A INPUT -s 192.168.0.0/24 -j ACCEPT
  sudo iptables -A OUTPUT -j DROP
  sudo iptables -A INPUT -j DROP

  echo "Tráfico de internet (WAN) bloqueado, solo se permite tráfico via LAN"
  echo "Fin de la operacion $parametro"
  exit

# Si se pasa el parámetro "offlan", bloqueamos todo el tráfico LAN
elif [ "$parametro" = "offlan" ]; then

  # Reseteamos las politicas y las establecemos nuevas
  sudo iptables -F
  sudo iptables -X
  sudo iptables -Z
  sudo iptables -t nat -F
  sudo iptables -t nat -X
  sudo iptables -t nat -Z
  sudo iptables -t mangle -F
  sudo iptables -t mangle -X
  sudo iptables -t mangle -Z
  sudo iptables -P INPUT ACCEPT
  sudo iptables -P FORWARD ACCEPT
  sudo iptables -P OUTPUT ACCEPT

  # Bloquemos trafico general
  sudo iptables -A OUTPUT -j DROP
  sudo iptables -A INPUT -j DROP

  echo "Fin de la operacion $parametro"
  exit

# Si el parametro es "onlan" habilitamos la red local
elif [ "$parametro" = "onlan" ]; then

  # Reseteamos las politicas y las establecemos nuevas

  sudo iptables -F
  sudo iptables -X
  sudo iptables -Z
  sudo iptables -t nat -F
  sudo iptables -t nat -X
  sudo iptables -t nat -Z
  sudo iptables -t mangle -F
  sudo iptables -t mangle -X
  sudo iptables -t mangle -Z
  sudo iptables -P INPUT ACCEPT
  sudo iptables -P FORWARD ACCEPT
  sudo iptables -P OUTPUT ACCEPT

  # Bloquemos trafico general y permitimos solo local

  sudo iptables -A OUTPUT -d 192.168.0.0/24 -j ACCEPT
  sudo iptables -A INPUT -s 192.168.0.0/24 -j ACCEPT
  sudo iptables -A OUTPUT -j DROP
  sudo iptables -A INPUT -j DROP

  echo "Tráfico de internet (WAN) bloqueado, solo se permite tráfico via LAN"
  echo "Fin de la operacion $parametro"
  exit

# Si se pasa el parámetro "onlanwan", permitimos todo el tráfico
elif [ "$parametro" = "onlanwan" ]; then
  # Reseteo de politicas se permite todo
  sudo iptables -F
  sudo iptables -X
  sudo iptables -Z
  sudo iptables -t nat -F
  sudo iptables -t nat -X
  sudo iptables -t nat -Z
  sudo iptables -t mangle -F
  sudo iptables -t mangle -X
  sudo iptables -t mangle -Z
  sudo iptables -P INPUT ACCEPT
  sudo iptables -P FORWARD ACCEPT
  sudo iptables -P OUTPUT ACCEPT



  echo "Se permite todo el tráfico de internet y lan"
  echo "Fin de la operacion $parametro"
  exit

# Si se pasa el parámetro "moncpu", monitoreamos cpu y guardamos en fichero
elif [ "$parametro" = "moncpu" ]; then

  # Monitoreamos cpu 

  echo "**** Monitoreando cpu ******* "
  sudo mkdir -p /home/vboxuser/Escritorio/monitoreo
  sudo top -b -n 50 >/home/vboxuser/Escritorio/monitoreo/uso_cpu.txt

  echo "Fin de la operacion $parametro"
  exit

# Si se pasa el parámetro "monred", monitoreamos la red y guardamos en fichero
elif [ "$parametro" = "monred" ]; then

  # Monitoreamos red

  echo "**** Monitoreando interfaz de red ******* "
  sudo mkdir -p /home/vboxuser/Escritorio/monitoreo

  sudo vnstat -5 >/home/vboxuser/Escritorio/monitoreo/uso_red.txt

  echo "Fin de la operacion $parametro"
  exit

# Si se pasa el parámetro "copiaingenieria", realizamos copia de seguridad de ingeniaria a simulador

elif [ "$parametro" = "copiaingenieria" ]; then
  
  # Montamos la unidad que apunta a simulador
  sudo mount -t cifs //192.168.0.156/Shared /home/vboxuser/Escritorio/simulador -o username=vboxuser,password=Ubuntu22,rw

  echo "Unidad simulador montada."
   
   
  # Directorio de origen
  rutaOrigen="/home/vboxuser/Escritorio/monitoreo/"

  echo "leo el origen"
  # Directorio de destino
  rutaDestino="/home/vboxuser/Escritorio/simulador"
  echo "leo destino"
  # Nombre del fichero adicionando hora+minuto+dia+mes+año
  nombreFichero="copiaseguridad_$(date +%H%M%d%m%Y).tar.gz"

  # Create the compressed backup in a tar.gz file
  sudo tar -czvf "$rutaDestino/$nombreFichero" -C "$rutaOrigen" .

  echo "El respaldo se ha creado correctamente en: $rutaDestino/$nombreFichero"
  echo "Fin de la operacion $parametro"
  exit
    
  

# Si se pasa el parámetro "copiasimulador", realizamos copia de seguridad de simulador a ingeniería

elif [ "$parametro" = "copiasimulador" ]; then
  
   # Montamos la unidad que apunta a ingeniería  
   sudo mount -t cifs //192.168.0.155/Shared /home/vboxuser/Escritorio/ingenieria -o username=vboxuser,password=Ubuntu22

   echo "Unidad ingenieria montada."
  
  # Directorio de origen
  rutaOrigen="/home/vboxuser/Escritorio/monitoreo/"

  echo "leo el origen"
  # Directorio de destino
  rutaDestino="/home/vboxuser/Escritorio/ingenieria"
  echo "leo destino"
  # Nombre del fichero adicionando hora+minuto+dia+mes+año
  nombreFichero="copiaseguridad_$(date +%H%M%d%m%Y).tar.gz"

  # Creamos copia de seguridad comprimida
  sudo tar -czvf "$rutaDestino/$nombreFichero" -C "$rutaOrigen" .

  echo "El respaldo se ha creado correctamente en: $rutaDestino/$nombreFichero"
  echo "Fin de la operacion $parametro"
  exit
    
 

# Si se pasa el parámetro "descargar" descargamos el fichero de pista

elif [ "$parametro" = "descargar" ]; then

  URL="https://autogestion.metrotel.com.ar/speedtest/archivo100MB.zip"
  rutaDestino="/home/vboxuser/Escritorio/monitoreo/descarga_datos.zip"

  # Descarga el archivo utilizando el comando "wget"
  sudo wget "$URL" -O "$rutaDestino"

  echo "descarga realizada en: $rutaDestino"

  echo "Fin de la operacion $parametro"
  exit

# Si se pasa el parámetro "mail" enviamos el mail con la info
elif [ "$parametro" = "mail" ]; then

  horaFecha=$(date +'%d-%m-%Y')

  # Variable email del remitente
  remite="alberto@sauberofimatica.com"

  # Variable email del destinatario
  destino="alberdsp@gmail.com"

  # Variable email asunto
  asunto="Datos de resultado de las pruebas"

  # Variable email cuerpo
  cuerpo="Adjuntamos la información relevante a las pruebas de hoy $horafecha."

  # Ruta al archivo adjunto
  archivo_adjunto="/home/vboxuser/Escritorio/monitoreo/uso_red.txt"

  # Comando para enviar el correo electrónico con el archivo adjunto
  echo "$cuerpo" | mutt -s "$asunto" -a "$archivo_adjunto" -- "$destino" <<< $(echo -e "From: $remite\n")

  #echo -e "From: $remite\n$cuerpo" | mutt -s "$asunto" -a "$archivo_adjunto" -- "$destino"

  echo "Correo enviado correctamente."

  echo "Fin de la operacion $parametro"
  exit



# Si el parámetro no corresponde con ninguna instrucción

else

  echo "no se reconoce $parametro como un comando válido, por favor revise los comandos válidos:"
  echo "ejecute el script controlpc.sh seguido del parametro sin - ni comillas  "
  echo " ejemplo:     ./controlpc.sh offwan "
  echo "lista de parametros admitidos: "
  echo "-------------------------------"
  echo "parámetro   offwan           ,bloquea el tráfico general y habilita la red local"
  echo "parámetro   offlan           ,eliminamos la regla que permite tráfico LAN "
  echo "parámetro   onlanwan         ,permitimos todo el tráfico lan y wan"
  echo "parámetro   onlan            ,habilitamos solo la red local"
  echo "parámetro   moncpu           ,monitorea la cpu y guarda en fichero"
  echo "parámetro   monred           ,monitorea la lan y guarda en fichero"
  echo "parámetro   descargar        ,realiza la descarga de fichero"
  echo "parámetro   copiasimulador   ,realizamos copia de seguridad de PC simulador"
  echo "parámetro   copiaingeniaria  ,realizamos copia de seguridad de PC simulador"
  echo "parámetro   mail             ,realizamos el envio de mail a los operadores de pista"
  
  

# Fin del scritp

fi


