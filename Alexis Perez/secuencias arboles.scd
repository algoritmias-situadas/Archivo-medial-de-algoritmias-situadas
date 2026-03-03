/////////////////////////FUNCIÓN SECUENCIAS////////////////////////////////
//ARGUMENTOS
//1. arbol - la funcion arbol que retorna un arreglo de dos dimensiones
//2. instrumentos - arreglo de los synthdef correspondientes. para samples utiliza \sampler
//3. buffer - aquí se establece el buffer de los guardados en el servidor. por defecto tiene nil en caso de que no se use sampler
//4. baseMidi - nota midi correspondiente al sample. por defecto tiene nil en caso de que no se use sampler
//5. silencios - arreglo de los silencios dependiendo del número en dónde ocurren
//6. raiz - nota midi que corresponde a la nota raíz, la generadora de todo el conjunto
//7. durRaiz - duración total del árbol en segundos
//8. repSecuencia - repeticiones de las secuencias. usar inf para loop
//9. escala - escala
//10. attack - ataque del instrumento
//11. release - release del instrumento
//12. octavaRaiz - octava del arreglo en el primer nivel
//13. amp - amplificador


~secuencias = {
	arg  arbol, instrumentos, buffer=nil, silencios = [], raiz=0, dur = 8, repSecuencia = inf, escala = Scale.majorPentatonic, attack, release, pan = [0], amp= 0.316/*es lo mismo que -10.damp*/, loop=0, sendLvl = 0.3;
	var  pbs, octava, pbNota, nHijos, arrPan, sum, div, mulFreqLFO;

	postln("hola");

	octava = (raiz / 12).floor;
    raiz = raiz % 12;



	/*if (arbol.size > 1) {
        nHijos = arbol[1].asArray.size;
    } {
        nHijos = 1; // Si es un árbol de un solo nivel
    };*/

	mulFreqLFO = 1;

	postln("Duración total: "++dur);

	pbs = Array.newClear(arbol.size);
	for (0, arbol.size -1, { //usar i=1 si no vamos a usar la raiz como Pbind
		arg i;
		var bufSample, bufRaiz, bufActual;

		postln("");
		postln("~~~ Pbind no."+(i+1)+" ~~~");
		postln("");

		bufActual = buffer[i];
		bufActual.debug("buffer");

		if (bufActual == nil, {
			bufRaiz = nil;
			bufSample = nil;
		}, {
			bufRaiz = bufActual[\raiz];
			bufSample = bufActual[\buf];
		});

		//se multiplica el tamaño de la secuencia actual y divide su duracion acorde
		//a las otras secuencias
		/*if (i>0, {
			dur = dur / nHijos;
			octava = octava+1; //aqui se va aumentando cada vez mas la octava
		});

		pbNota = 1 - probSilencio[i]; //la diferencia para el \note en el \type del Pbind

		postln("Prob. silencio nivel "++i++": "++probSilencio[i]);

		//las siguientes líneas son para generar un arreglo para el paneo
		sum = pan[0];
		div = (pan[0] - pan[1]).abs;
		div = div/(arbol[i].size + 1);
		arrPan = Array.newClear(arbol[i].size);
		for (0, arbol[i].size -1, {
			arg j;
			sum = sum + div;
			arrPan[j] = sum;
		});*/

		//postln("Paneo de las notas en nivel "++i++": "++arrPan.round(0.001));

		pbs[i] = Pbind(
			\instrument, instrumentos[i].debug("instrumento"),
			\scale, escala,
			\root, raiz.debug("raiz"),
			\octave, octava.debug("octava") ,
			\degree, Pseq(arbol[i], inf),
			\rate, Pfunc({ |ev|
				var midiActual = ev.use({ ~midinote.value/*.debug("notamidi")*/ });
                // Si midiActual es 48 y baseMidi es 48, el ratio será 1.0 (sin cambio)
				midiActual;
            }),
			\buf, bufSample,
			\baseMidi, bufRaiz,
			\loop, loop[i],
			\type, Pseq((\note ! arbol[i].size).putEach(silencios[i], \rest).debug("silencios: "),inf),
			\dur, dur[i]/*Pfunc({dur/(nHijos**i)})*/, //hace lo mismo que dur = dur / nHijos cada vez que itera
			\repSecuencia, repSecuencia[i],
			\notaCount, Pseries(0, 1, inf),
			\cleanup, Pfunc({ |ev|
                var reps = ev[\repSecuencia] ? inf;
                if (reps != inf) {
                    if (ev[\notaCount] >= (arbol[i].size * reps)) { nil } { 0 };
                } { 0 };
            }),
			\sendBus, ~reverbBus,
			\sendLvl, sendLvl[i],
			\group, ~master,
			\pan, pan[i],
			\amp, amp[i],
			\atk, attack[i],
			\rel, release[i],
			\out, 0
		);
	});
	pbs;
};




postln("secuencias arnoles.scd cargado");