(
// Variables de inicio
/* */
~flag = false;
~ending = false;

~inmutaIsPlaying = false;
~mutaIsPlaying = false;
~atmosPlaying  = false;
~sectionEnd = false;

~wait_seccion = false;
~wait_parte = false;
~wait_atmos = false;

/* Monitoreo de micrófono encendido y cambio de los valores de frecuencia y amplitud. */
~revIsOn = false;
~freq_var = 800;
~amp_var = 1.05;

/* AQUÍ se ajusta la sensibilidad del medidor de amplitud */
~umbralInicio = 0.009; /* Este es el número con el que empieza a correr la pieza. Recomiendo no moverlos. */
~umbralActivacion = 0.008; /* Este es el umbral para que se activen los eventos a partir de los micrófonos de contacto. Yo recomiendo 0.09, pero si parece poco sensible se puede bajar a 0.06 o 0.04. */

~seccion = 0;
~track = 0;

~bofs_limit = 0;
~contador_global = 0; /*  */
~contador_seccional = 0;
~contador_partal = 0;
~contador_atmos = 0;
~contador_seccion  = 1; /* Esta variable sirve para que el programa sepa que sección de la obra se está reproduciendo. Para que suene debe tener declarado el valor 1.*/
~contador_partes = 0;
~contador_tracks = 0;
~tiempo_total = 1616; // 27:00

/* Secciones inmutables */
~dUR_CIUDAD = 146; // 01, 2:25
~dUR_ORIGEN = 209; // 02, 3:28
~dUR_SENDAS = 155; // 03,  2:34
~dUR_SALA = 169; // 05, 2:48
~dUR_ERROR = 175; // 11, 2:54
~dUR_FUEGO = 166; // 12, 2:45
~dUR_MEMORIAS = 164; // 16, 2:43

/* Secciones loopeables */
~dUR_ECOS = 135; // 04, 2:15
~dUR_TIEMPO = 150; // 06, 1:30
~dUR_TESTIGOS = 120; // 07, 1:20
~dUR_INMUEBLES = 180; // 08, 2:00
~dUR_FUTURO = 90; // 09, 0:31
~dUR_VIOLENCIA = 60; // 10, 0:17
~dUR_SUSURROS = 120; // 13, 0:19
~dUR_BELLAVISTA = 180; // 14, 0:47
~dUR_NARRATIVA = 200; // 15, 1:23

/*
Duración de las secciones.

Se determina la duración de las secciones con una estructura switcher que evalúa el valor de la variable ~contador_seccion. Para evaluar usar ".value".
*/

~seccion_dur = {
	switch (~contador_seccion,
		1, {~dUR_CIUDAD},
		2, {~dUR_ORIGEN},
		3, {~dUR_SENDAS},
		4, {~dUR_ECOS},
		5, {~dUR_SALA},
		6, {~dUR_TIEMPO},
		7, {~dUR_TESTIGOS},
		8, {~dUR_INMUEBLES},
		9, {~dUR_FUTURO},
		10, {~dUR_VIOLENCIA},
		11, {~dUR_ERROR},
		12, {~dUR_FUEGO},
		13, {~dUR_SUSURROS},
		14, {~dUR_BELLAVISTA},
		15, {~dUR_NARRATIVA},
		16, {~dUR_MEMORIAS},
		17, {0}
	);
};

/*
Duración de los partes de las secciones.

Se determina la duración de las partes de las secciones con una estructura switcher que evalúa el valor de la variable ~contador_seccion.

Escribí el cero para las secciones que son inmutables.
*/

~seccion_par_dur = {
	switch (~contador_seccion,
		1, {0},
		2, {0},
		3, {0},
		4, {[6, 8, 3, 7.5, 4.5, 4.5, 7, 4, 9, 5.5, 5.5, 5.5, 5.5, 21]},
		5, {0},
		6, {[7, 4, 3, 5, 5, 9, 6, 7]},
		7, {[2, 3, 4, 7, 7, 11]},
		8, {[4, 3, 3, 9, 4, 2, 5, 3, 2, 6, 3, 7, 2, 6]},
		9, {[3, 2, 4, 4, 2, 3, 8, 4, 10]},
		10, {[10, 6, 11, 7, 12]},
		11, {0},
		12, {0},
		13, {[3, 6, 30, 7, 4, 3, 5, 4, 16]},
		14, {[3, 2, 4, 8, 11, 8, 18]},
		15, {[2, 2, 7, 2, 10, 12, 2, 10, 8, 3, 5, 4, 2, 9, 2, 3, 2, 2, 9, 2, 6]},
		16, {0},
	);

};

/*
Inmutabilidad.

Se determina si el clip es de la categoría mutable o inmutable. Para evaluar usar ".value".
*/

~seccion_inmuta = {
	switch (~contador_seccion,
		1, {true},
		2, {true},
		3, {true},
		4, {false},
		5, {true},
		6, {false},
		7, {false},
		8, {false},
		9, {false},
		10, {false},
		11, {true},
		12, {true},
		13, {false},
		14, {false},
		15, {false},
		16, {true},
	);
};

/*
Nombre de las secciones.

Se determina el nombre de las secciones con una estructura switcher que evalúa el valor de la variable ~contador_seccion. Para evaluar usar ".value".
*/
~seccion_name = {
	switch (~contador_seccion,
		1, {"1. La ciudad que respira el tiempo"},
		2, {"2. El Origen"},
		3, {"3. Las Sendas olvidadas: Comunicación y transporte"},
		4, {"4. Ecos en las paredes"},
		5, {"5. La sala de la última espera"},
		6, {"6. El tiempo"},
		7, {"7. Los testigos de piedra"},
		8, {"8. Los inmuebles como tecnologías de memoria colectiva"},
		9, {"9. El futuro: Sociedad en Ruinas - 9 audios"},
		10, {"10. Violencia y Economía"},
		11, {"11. Error y Esperanza"},
		12, {"12. Fuego, Escombors y Fantasmas"},
		13, {"13. Susurros del Olvido"},
		14, {"14. Bellavista y Jauja"},
		15, {"15. Narrativas del presente"},
		16, {"16. Memorias Liminales"},
	);
};

/*
Buffer con el que inicia la sección.

Aquí se determina el buffer en el que inicia cada una de las secciones. Esto se realiza con una estructura switcher que evalúa el valor de la variable ~contador_seccion.
*/
~bofs_seccion = {
	switch (~contador_seccion,
		1, {0},
		2, {1},
		3, {2},
		4, {3},
		5, {18},
		6, {19},
		7, {28},
		8, {35},
		9, {50},
		10, {60},
		11, {66},
		12, {67},
		13, {68},
		14, {78},
		15, {86},
		16, {108},
	);
};

/*
Audios de las secciones.

Aquí se determina la cantidad de buffer de cada una de las secciones. Esto se realiza con una estructura switcher que evalúa el valor de la variable ~contador_seccion.
*/
~audios_seccion = {
	switch (~contador_seccion,
		1, {1},
		2, {1},
		3, {1},
		4, {15},
		5, {1},
		6, {9},
		7, {7},
		8, {15},
		9, {10},
		10, {6},
		11, {1},
		12, {1},
		13, {10},
		14, {8},
		15, {22},
		16, {1},
	);
};

// ~bofs_seccion + ~audios_seccion

/* Buses */
s.newBusAllocators;
~soundBus = Bus.audio(s, 2);
~reverbBus = Bus.audio(s, 2);
~delayBus = Bus.audio(s, 2);
~reverbdelayBus = Bus.audio(s, 2);

/* Grupos */
~sourceGrp = Group.new;
~reverbGrp = Group.new(~sourceGrp, \addAfter);
~delayGrp = Group.new(~reverbGrp, \addAfter);
~reverbDelayGrp = Group.new(~delayGrp, \addAfter);

// Micro Contacto
/* Este SynthDef se encarga de controlar la entrada de la señal de cada uno de los micrófonos.*/

SynthDef(\micro,{arg in=0 /*Este es la señal para el Hidrofono*/, out=0;
	var sig;
	sig = SoundIn.ar(in);
	Out.ar(out, sig);
}).add;

// Stereo
/*Este SynthDef permite reproducir los audios almacenados en la variable ~nom */
SynthDef(\playBufFinal, {arg rate = 1, amp = 1, buffer, startPos = 0, attack = 0, sustain = 1, release = 0, ffreq = 1000, rq = 0.1, pan = 0, delay = 0.3, decay = 1, timeatk= 0.01, timesus = 20, timerel = 0.01, gate = 1, out=0;
	var snd, env;
	env = EnvGen.kr(
		Env([attack, sustain, 1, release], [timeatk, timesus, 0.1, timerel], curve: \lin),
		gate,
		doneAction: 2);
	snd = PlayBuf.ar(
		numChannels: 2,
		bufnum: buffer,
		rate: rate,
		startPos: startPos.linlin(0, 1, 0, BufFrames.kr(buffer)),
		doneAction: 2;
	);
	snd = snd * env;
	// snd = BPF.ar(snd, ffreq, rq);
	// snd = CombC.ar(snd, maxdelaytime: 2, delaytime: delay, decaytime: decay);
	snd = Balance2.ar(snd[0],snd[1], pan);
	Out.ar(out, snd);
}).add;

// Reverb mono
SynthDef(\reverb,
	{
		arg in=55, out=0, mix=0.9, room = 0.9, damp= 0.7;
		var sig, rev;
		sig = In.ar(in);
		rev = FreeVerb.ar(sig,mix,room,damp,1.0);
		Out.ar(out, rev.dup);
	}
).add;

// Reverb stereo
SynthDef(\reverb_stereo,
	{
		arg in=55, out=0, mix=0.7, room = 0.9, damp= 0.7;
		var sig, rev;
		sig = In.ar(in, 2);
		rev = FreeVerb2.ar(sig[0], sig[1],mix,room,damp,1.0);
		Out.ar(out, rev.dup);
	}
).add;

// Delay

SynthDef(\delay,
	{
		arg in= 1, delayTime = 3, feedback= 0.8, out = 0, pan = 0;
		var sig, dly, dly2, dly3, mix1, mix2, snd;
		sig = In.ar(in);
		dly = DelayN.ar(sig,delayTime,delayTime);
		dly2 = DelayN.ar(dly,delayTime - 2,delayTime-2);
		dly3 = DelayN.ar(dly2,delayTime-2.5,delayTime-2.5);
		mix1 = Mix.new([sig, dly2]);
		mix2 = Mix.new([dly, dly3]);
		Out.ar(out, [mix1, mix2]);
	}
).add;

// Detector de Amplitud en el Tiempo
SynthDef(\detectorAmp,
	{
		arg in_1 = 0, in_2 = 1, in_3 = 3, in_4 = 4;
		var input_1, input_2, input_3, input_4, input_sum, ampF;
		input_1 =  SoundIn.ar(in_1);
		input_2 =  SoundIn.ar(in_2);
		input_3 =  SoundIn.ar(in_3);
		input_4 =  SoundIn.ar(in_4);
		input_sum = Mix.new([input_1, input_2, input_3, input_4]);
		ampF = Amplitude.kr(input_sum);
		SendTrig.kr(Impulse.kr(5), 2, ampF);
}).add;

)