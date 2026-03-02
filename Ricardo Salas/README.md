Cómo hacer funcionar la instalación:



-------



ARDUINO

Primero, se debe instalar el software “Arduino IDE” (https://www.arduino.cc/en/software/).

Después, abrir el archivo: “sentir\_y\_escuchar\_el\_viento.ino”.



\*En caso de no estar dentro de la carpeta donde Arduino guarda los código, se te preguntará si quieres crear su respectiva carpeta. Se deberá presionar en "Aceptar".

Una vez compilado y cargado el código en la placa Arduino, se puede cerrar el software.



\*\*NOTA: el código se queda cargado en la placa Arduino, por lo que sólo es necesario hacer este paso la primera vez, después bastará solamente con conectar la placa Arduino a la computadora para que empiece a ejecutarse el código.



-------



SUPERCOLLIDER

Primero, se debe instalar el software “SuperCollider” (https://supercollider.github.io/).

Después, abrir el archivo: “sentir\_y\_escuchar\_el\_viento.scd”



Antes de ejecutar todo el código, habrá que especificar qué puerto serie estará leyendo SuperCollider. Esto dependerá de cada situación.



Para hacer esto, primero hay que ejecutar (shift + Enter) la línea de código: SerialPort.devices;

En la consola de SuperCollider aparecerán los puertos seriales disponibles. 

Se tendrá que copiar y pegar (entre comillas) el puerto a utilizar (COM3 en este caso), por ejemplo: ~puertoSerie = "COM3";



Una vez hecho esto, habrá que asegurarse que está seleccionada la interfaz de audio con al menos 3 salidas en el sistema operativo de la computadora a utilizar.

Para que el código funcione, bastará con seleccionar todo el código (Ctrl/Cmd + a) y después ejecutarlo (Ctrl/Cmd + Enter).

