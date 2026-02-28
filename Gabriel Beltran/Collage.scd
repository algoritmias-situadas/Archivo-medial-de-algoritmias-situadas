 //carga un archivo de audio//
~buf = Buffer.loadDialog;

///////informacion de Buffer///////

~buf.numChannels; //Cuantos canales tiene//

~buf.duration;    // Segundos que dura el archivo//

//////// Creacion de un SynthDef para reproducir el archivo de audio////////
(
SynthDef(\Collage, { |rate = 1, loop = 1, pos = 0, gate = 1| //definimos un sintetizador basico llamado collage// //sig: señal de audio, env: envolvente//

	var sig, env;                              // rate:velocidad de reproduccion,loop:una sola vez,pos: posicion inicial en frames,gate:controla la envolvente//

	sig = PlayBuf.ar(                          //Reproducir el buffer//
		~buf.numChannels,                      //Usar todos los canales que contengan el archivo//
		~buf.bufnum,                           //referencia interna del buffer//
		rate * BufRateScale.kr(~buf),          //Corrige la velocidad segun el sample rate//
		startPos: pos,                         //Donde comienza//
		loop: loop                             //Repite o no//

	);

	env = EnvGen.ar(                           //Ataque rapido,sostenimiento 50%, relajamiento suave//
		Env.asr(
			attackTime: 0.01,
			sustainLevel: 0.5,
			releaseTime: 0.3

		),
		gate,
		doneAction: 2                          //Silencia el synth cuando termina//

	);

	Out.ar(0, sig * env);                     //Envio del sonido a canal 0 (0=salida principal)//
}).add;                                       //Registra en SynthDef en el servidor//
)
x = Synth(\Collage);                          //Crea una instancia en el synth y empieza a sonar//

x.set(\gate, 0.5);                            //Control de la envolvente//

x.set(\rate, 0.5);                            //Control de reproduccion del buffer//

x.free;                                       //Apagar el synthDef//

///// Repetimos el mismo proceso para poder reproducir el mismo archivo de audio a diferentes velocidades, dejando una de base y la otra para seguir jugando con ella//////


 //carga un archivo de audio//
~buf = Buffer.loadDialog;

///////informacion de Buffer///////

~buf.numChannels; //Cuantos canales tiene//

~buf.duration;    // Segundos que dura el archivo//

//////// Creacion de un SynthDef para reproducir el archivo de audio////////
(
SynthDef(\Collage,{|rate = 1, loop = 1, pos = 0, gate = 1| //definimos un sintetizador basico llamado collage// //sig: señal de audio, env: envolvente//

	var sig, env;                              // rate:velocidad de reproduccion,loop:una sola vez,pos: posicion inicial en frames,gate:controla la envolvente//


	sig = PlayBuf.ar(                          //Reproducir el buffer//
		~buf.numChannels,                      //Usar todos los canales que contengan el archivo//
		~buf.bufnum,                           //referencia interna del buffer//
		rate * BufRateScale.kr(~buf),          //Corrige la velocidad segun el sample rate//
		startPos: pos,                         //Donde comienza//
		loop: loop                             //Repite o no//

	);

	env = EnvGen.ar(                           //Ataque rapido,sostenimiento 50%, relajamiento suave//
		Env.asr(
			attackTime: 0.01,
			sustainLevel: 0.5,
			releaseTime: 0.3

		),
		gate,
		doneAction: 2                          //Silencia el synth cuando termina//

	);

	Out.ar(0, sig * env);                     //Envio del sonido a canal 0 (0=salida principal)//
}).add;                                       //Registra en SynthDef en el servidor//
)
x = Synth(\Collage);                          //Crea una instancia en el synth y empieza a sonar//

x.set(\gate, 0.5);                            //Control de la envolvente//

x.set(\rate, 0.2);                            //Control de reproduccion del buffer////Aqui modificamos la velocidad////

x.free;                                       //Apagar el synthDef//


(
SerialPort.closeAll;                          ////cierra todo los puertos seriales////
~port = SerialPort.new("COM3", 9600);         ////Abre el puerto COM3 a 9600 baudinos/// baudinos: velocidad de comunicacion entre el ARDUINO y Supercollider////
~val = 0;                                     ///Valor numerico final recibido////
~charArray = [];                              ///Buffer temporal de caracteres///
~reader = Routine({                           ///Crea una rutina///
	var ascii;
	loop{
		ascii = ~port.read.asAscii;            ///Lee un byte del puerto y lo convierte a caracter ascii///
		if(ascii.isDecDigit,{
			~charArray =
			~charArray.add(ascii);
		});                                  ///Si el caracter es un digito del 0-9 y lo guarda////

		if(ascii == $a, {                    ///Si llega a la letra a significa fin del numero///
			~val =
			~charArray.collect(_.digit).convertDigits; ///Convierte los caracteres a un numero entero///
			~charArray = [];                           ///Resetea el buffer y postea el valor recibido///
			("VALOR RECIBIDO:" ++
				~val).postln;
		});
		0.001.wait;                              ////Pequeña pausa para no saturar el CPU///
	}
}).play;                                         ///Iniciar routine///
)


(

SynthDef.new(\Saw,{                             ////Un SynthDef que contiene///
	arg cutoff = 1000;                          //// Una frecuencia de corte en 1000Hz///
	var sig;
	sig = Saw.ar([50, 1000]);                   ////Tiene dos osciladores de diente de sierra uno grave 50 y otro agudo 1000///
	sig = RLPF.ar(sig, cutoff.lag(0.02),0.25,0.2);///Aqui el lag aplica un un suavizado temporal a los cambios bruscos que se puedan detectar por parte del LDR////
	Out.ar(0,sig);                               ////salida de audio////
}).add;
)

~synth = Synth(\Saw,[\cutoff,200]);
~synth.set(\cutoff,4000);                       ////Controlamos la frecuencia de corte///
~synth.free;                                    ///Apagamos el synth////

/////Crea synth controlado por LDR/////

~synth = Synth(\Saw,[\cutoff, ~val.linexp(0,1023,80,4000)]);   ///Mapea el valor del LDR 0-1023 a 80Hz-4000Hz con escala exponencial///
(
~control = Routine({                           ///ajusta el cutoff en tiempo real///
	loop{
		~synth.set(\cutoff, ~val.linexp(0,1023,80,4000));
		0.01.wait;
	}

}).play
)
~control.stop;                               ////Pausa el synth///
~synth.free;                                 ////Mata el synth///


(

a = Buffer.read(s,"C:/Users/SEARS/Desktop/anglo/cap1.wav");                 /////Carga de multiples buffers o archivos de audio/////
b = Buffer.read(s,"C:/Users/SEARS/Desktop/anglo/capitulo2.wav");
c = Buffer.read(s,"E:/MUSIC/250102_0007.wav");
d = Buffer.read(s,"E:/MUSIC/goteras.wav");
)

(
SynthDef(\sonar_muestras,{|buf, vel, reve, inicio, amp, durr|
	var son, env;
	son = PlayBuf.ar(2, buf,BufRateScale.kr(buf)*vel*reve, 1,inicio,0);    ////Reproducir buffer en estereo,velocidad variable,invierte el audio si es -1,punto aleatorio
	env = EnvGen.kr(Env.perc(0.01,durr),doneAction:2);                     ////Envolvente percusiva con duracion variable////
	Out.ar(0, son*env*amp)
}).add
)

(
Pbind(\instrument,\sonar_muestras,\dur, Prand([1/5,1/7,1/3,1/2,1]*0.5,inf), ///Duracion ritmicas aleatorias///
	\buf,Prand([a, b, c, d],inf),                                           ///Seleciona un buffer a azar///
	\vel,Pfunc{ ~val.linexp(0, 1023, 0.1, 2)},                              ///La velocidad depende del LDR///
	\inicio, Pwhite(0,Pfunc({|e|e.buf.numFrames}),inf),                    ///Empieza en puntos aleatorios del archivo///
	\durr, Pwhite(1, 4.5, inf),                                            ////
	\amp, 0.3,                                                            ///volumen///
	\reve, Prand([1,-1], inf)                                              ///Reversa aleatorio a veces hacia adelante, aveces hacia atras///
).play
)


r = Buffer.read(s,"E:/MUSIC/primerboom.wav");                                                      ////Carga del archivo de audio o buffer///


(
SynthDef(\sonar_muestras2,{|buf, vel, reve, inicio, amp, rit|
	var son;
	son = PlayBuf.ar(2,buf,                                             ///Reproducir el buffer en estereo///
		BufRateScale.kr(buf)*vel*reve,                                 ////Velocidad variable,invierte el audio si es -1,punto aleatorio////
		Impulse.kr(rit),inicio,1);                      ///genera pulsos periodicos, cada pulso reinicia el PlayBuf, si rit=10,se dispara 10 veces por segundo
	Out.ar(0,son*amp)                                   ///salida de audio principal
}).add
)
(
Pmono(\sonar_muestras2,
	\dur, Pwhite(0.05, 1, inf),
	\buf, r,
	\vel, Pwhite(0.5, 1),
	                             /////Velocidad aleatoria///
	\reve, Prand([1, -1], inf),   ////reversa y reproduccion normal aleatoria///
	\inicio, 0,                 ///Cada evento elige un punto aleatorio del sample///
	\amp, 0.1                   ///Volumen///


).play
)





