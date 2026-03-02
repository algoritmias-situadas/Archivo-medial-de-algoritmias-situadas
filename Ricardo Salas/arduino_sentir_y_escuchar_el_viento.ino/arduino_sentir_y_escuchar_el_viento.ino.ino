int entradas[] = { 0, 1, 2 };  // indicar, en una lista, las Entradas Analógicas que serán usadas en la placa Arduino

int numeroDeSensores = sizeof(entradas) / sizeof(entradas[0]);

void setup() {
  Serial.begin(9600);  // se inicia la comunicación serial a 9600 baudios
}

void loop() {

  for (int i = 0; i < numeroDeSensores; i++) {
    Serial.print(analogRead(entradas[i]));  // imprime el valor registrado en las entradas analógicas colocadas en entrada[]

    if (i < numeroDeSensores - 1) {
      Serial.print(" ");  // imprime un silencio para separ el valor del siguiente sensor, menos en el último
    }
  }

  Serial.print('\n');  // marca el fin del loop imprimiendo "10" (nueva línea) en ASCII

  delay(100);  // intervalo de actualización (en ms)
}