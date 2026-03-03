s.boot;
//hay que cargar estos archivos primero
(
"arboles.scd".loadRelative;
"secuencias arboles.scd".loadRelative;
"sintes.scd".loadRelative;
"sampler.scd".loadRelative;
"inicio.scd".loadRelative
)

////////////////// FUNCIONES ////////////////////////
// en caso de que se hayan detenido los grupos y ejecuta la siguiente línea y
// ~inicio.()

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

( // se puede evaluar y reproducir esta sección
~busCtr0 = Bus.control(s, 1); // bus de control para realizar envolventes como automatizaciones
~busCtr1 = Bus.control(s, 1);

Pdef(\arboles, Pspawner({
	arg sp;
	var niveles=4, nVoces, i = 1, raices = [7, 0], octavas=[4,3], durPbind=4, reps=8, offset=1, dur0, durSeccion, durLoops, raizActual, octavaActual, beatActual, beatInicio, contadorWaits;

	raizActual = raices.wrapAt(i);
	octavaActual = octavas.wrapAt(i);

	dur0 = durPbind * 15;

	~genArbol.(
		nNiveles: 4,
		nodos: ['h','ri'],
		intervalos: [-1, 3, -1, -2, 1]
	);
	~pbs = ~secuencias.(   // \p0           \p1           \p2           \p3           \p4           \p5
		arbol:               [~arbol[0]   , ~arbol[1]   , ~arbol[2]   , ~arbol[2]   , ~arbol[3]   , ~arbol[4]   ],
		raiz: 36, // nota midi
		instrumentos:        [\sampler    , \bell     , \mallet       , \mallet     , \pulse      , \sampler    ],
		buffer:              [~glasspad   , ~glasspad   , ~glasspad   , ~glasspad   , ~glasspad   , ~saw        ],
		silencios:           [[]          , []          , []          , []          , [1,4,7]     , []          ],
		loop:                [1           , 0           , 0           , 0           , 0           , 1           ],
		repSecuencia:        [1           , inf         , inf         , inf         , 1           , 1           ],
		dur:                 [dur0        , durPbind    , durPbind/2  , durPbind/4  , durPbind/8  , durPbind*2  ],
		escala: Scale.lydian,
		pan:                 [0           , 0           , 0           , 0           , 0           , 0           ],
		attack:              [1.5         , 1           , 0.05        , 1           , 0.5         , 3           ],
		release:             [1.5         , 2.5         , 0.8         , 0.8         , 1           , 4.5         ],
		amp:                 [-8.dbamp    , -10.dbamp   , -10.dbamp   , -13.dbamp   , -12.dbamp   , -5.dbamp    ],
		sendLvl:             [0           , 0.3         , 0.3         , 0.3         , 0.3         , 0.3         ]
	);

	nVoces = ~pbs.size;

	nVoces.do { |n| Pbindef("p%".format(n).asSymbol).source = ~pbs[n] };




	/*~busCtr0.set(-20.dbamp);
	~busCtr1.set(0);*/ // Empezar en paneo derecho

	~p0Group.set(\gate, 0);

	Pbindef(\p0,
		\group, ~p0Group, // se usa un grupo para tener más control sobre ellascon las voces con mayor duración
		\legato, 0.96, // por defecto supercollider asigna legato 0.8 lo cual puede ser muy notable en notas largas como estas. Mejor utilizar un legato largo cercano a 1 para prevenir que el sonido se acorte mucho antes de la duracion asignada
		\amp, ~busCtr0.asMap, // con este bus se puede hacer una automatización a lo largo de la pieza
		\pan, ~busCtr1.asMap
	);

	Pbindef(\p1,
		\root, raizActual, \octave, 3
	);


	Pbindef(\p2, \root, raizActual);


	Pbindef(\p3,
		\root, raizActual,
		\octave, 5,
	);

	Pbindef(\p4,\root, raizActual, \octave, 6);


	Pbindef(\p5,
		\group, ~p0Group,
		\root, raizActual,
		\octave, 7,
	);

	//~~~~~~~~~~~~~~~~~~~~~~~~~ EJECUCIÓN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	durSeccion = dur0;
	durLoops = durPbind*2;
	durSeccion.debug("tiempo restante de esta seccion");

	beatInicio = thisThread.clock.beats;
	beatActual = thisThread.clock.beats - beatInicio;
	contadorWaits = 0;
	beatActual.debug("Beat Actual");

	{~envAutomSim.(~busCtr0, [-15.dbamp, -5.dbamp, -20.dbamp], dur0, \sin)}.play;
	{~envAutomSim.(~busCtr1, [0, -0.5, 0.5, 0], dur0, \sin)}.play;

	sp.par(Pfindur(durSeccion, Pbindef(\p0, \root, raices[0])));
	beatActual = thisThread.clock.beats - beatInicio;
	("~~\p0~~ al beat: %").format(beatActual).postln;
	sp.wait(durLoops);
	 contadorWaits = contadorWaits + durLoops;


	durSeccion = durSeccion - durLoops;
	sp.par(Pfindur(durSeccion, Pbindef(\p1, \root, raices[0])));
	beatActual = thisThread.clock.beats - beatInicio;
	("~~\p1~~ al beat: %").format(beatActual).postln;
	sp.wait(durLoops);
	 contadorWaits = contadorWaits + durLoops;


	durSeccion = durSeccion - durLoops;
	sp.par(Pfindur(durSeccion, Pbindef(\p2, \root, raices[0])));
	beatActual = thisThread.clock.beats - beatInicio;
	("~~\p2~~ al beat: %").format(beatActual).postln;
	sp.wait(durLoops);
	 contadorWaits = contadorWaits + durLoops;


	durSeccion = durSeccion - durLoops;
	sp.wait(0.5);
	contadorWaits = contadorWaits + 0.5;


	sp.par(Pfindur(durSeccion - 0.5, Pbindef(\p3, \root, raices[0])));
	beatActual = thisThread.clock.beats - beatInicio; ("~~\p3~~ al beat: %").format(beatActual).postln;


	sp.wait(durPbind - 0.5);
	beatActual = thisThread.clock.beats - beatInicio; contadorWaits = contadorWaits + durPbind - 0.5; beatActual.debug("Beat Actual");

	durSeccion = durSeccion - 1;
	sp.par(Pfindur(durSeccion - 0.5, Pbindef(\p5, \root, raices[0]))).debug("~~\p5~~");
	beatActual = thisThread.clock.beats - beatInicio; ("~~\53~~ al beat: %").format(beatActual).postln;

	4.do{
		sp.par(Pfindur(durSeccion, Pbindef(\p4, \root, raices[0]))).debug("~~\p4~~");
		beatActual = thisThread.clock.beats - beatInicio; ("~~\p4~~ al beat: %").format(beatActual).postln;
		sp.wait(durLoops);
		durSeccion = durSeccion - durLoops;
		durSeccion.debug();
	};


	~p0Group.set(\gate, 0); // asegurarnos que se detenga el sintetizador de \p0
	sp.suspendAll;



	loop {
		var raizActual = raices.wrapAt(i), octavaActual = octavas.wrapAt(i);
		~p0Group.set(\gate, 0);

		Pbindef(\p0,
			\group, ~p0Group, // se usa un grupo para tener más control sobre ellascon las voces con mayor duración
			\root, raizActual,
			\legato, 0.96,
			\amp, ~busCtr0.asMap, // con este bus se puede hacer una automatización a lo largo de la pieza
			\pan, ~busCtr1.asMap
		);

		Pbindef(\p1,
			\root, raizActual, \octave, 3
		);


		Pbindef(\p2, \root, raizActual);


		Pbindef(\p3,
			\root, raizActual,
			\octave, 5,
		);

		Pbindef(\p4,\root, raizActual, \octave, 6);


		Pbindef(\p5,
			\group, ~p0Group,
			\root, raizActual,
			\octave, 7,
		);

        //~~~~~~~~~~~~~~~~~~~~~~~~~ EJECUCIÓN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		"Iniciando bloque - Iteración: % | Raíz: %".format(i, raizActual).postln;
		beatActual.debug("Beat Actual");
		~busCtr0.set(-20.dbamp);
		~busCtr1.set(1); // Empezar en paneo derecho
		{~envAutomSim.(~busCtr0, [-20.dbamp, -5.dbamp, -20.dbamp], dur0, \sin)}.play;
		{~envAutomSim.(~busCtr1, [1, -1, 1, 0], dur0, \sin)}.play;

		sp.par(Pbindef(\p0));
		sp.par(Pbindef(\p1));
		sp.par(Pbindef(\p2));



		sp.wait(0.5);
		sp.par(Pbindef(\p3));

		sp.wait(durPbind - 0.5);

		sp.par(Pbindef(\p5));

        4.do{
			sp.par(Pbindef(\p4));
			sp.wait(durPbind*2);
		};



		//sp.wait(durPbind);
		~p0Group.set(\gate, 0); // asegurarnos que se detenga el sintetizador de \p0
		sp.suspendAll;
        i = i + 1;
	};


	sp.suspendAll;

})).play(~t, quant: 1); // se reproduce al evaluar
)

newArr = (arr.size - 1).collect({ |i|
    arr[i] + (num / arr.size)
});

~envAutomSim = { // envolvente simetrica para automatización
	arg bus, lvls, time, curve;
	var times = (lvls.size - 1).collect({ arg i; lvls[i] + (time / lvls.size)});
	var env = Env( levels: lvls, times: times, curve: curve);
	Out.kr(bus, EnvGen.kr(env, doneAction: 2));
};

~envAutom = { // envolvente simetrica para automatización
	arg bus, lvls, time, curve;
	var env = Env( levels: lvls, times: times, curve: curve);
	Out.kr(bus, EnvGen.kr(env, doneAction: 2));
};

Pdef(\arboles).stop; ~p0Group.set(\gate, 0); // detiene la rutina y el dron




/*
	loop {
		var raizActual = raices.wrapAt(i), octavaActual = octavas.wrapAt(i);
		~p0Group.set(\gate, 0);

		Pbindef(\p0,
			\group, ~p0Group, // se usa un grupo con las nVoces con mayor duración y así tener más control sobre ellas
			\root, raizActual,
			\octave, octavaActual,
			\amp, ~busCtr0.asMap, // con este bus se puede hacer una automatización a lo largo de la pieza
			\pan, ~busCtr1.asMap
		);

		Pbindef(\p1,
			\root, raizActual, \octave, 3
		);


		Pbindef(\p2, \root, raizActual);


		Pbindef(\p3,
			\root, raizActual,
			\octave, 5,
		);

		Pbindef(\p4,\root, raizActual, \octave, 6);


		Pbindef(\p5,
			\group, ~p0Group,
			\root, raizActual,
			\octave, 7,
		);

        //~~~~~~~~~~~~~~~~~~~~~~~~~ EJECUCIÓN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		~busCtr0.set(-30.dbamp);
		~busCtr1.set(1); // Empezar en paneo derecho

		"Iniciando bloque - Iteración: % | Raíz: %".format(i, raizActual).postln;
		{ // envolvente de automatización
			var env = Env(
				levels: [-30.dbamp, -5.dbamp, -20.dbamp],
				times: [dur0 / 2, dur0 / 2],
				curve: \sin
			);
			Out.kr(~busCtr0, EnvGen.kr(env, doneAction: 2));
		}.play;

		{ // envolvente de automatización
			var env = Env(
				levels: [1, -1, 1, 0],
				times: [dur0 / 3, dur0 / 3,  dur0 / 3],
				curve: \sin
			);
			Out.kr(~busCtr1, EnvGen.kr(env, doneAction: 2));
		}.play;

		sp.par(Pbindef(\p0));
		// sp.par(Pbindef(\p1));
		// sp.par(Pbindef(\p2));



		sp.wait(0.5);
		// sp.par(Pbindef(\p3));

		sp.wait(durPbind - 0.5);

		// sp.par(Pbindef(\p5));

        7.do{
			// sp.par(Pbindef(\p4));
			sp.wait(durPbind*2);
		};



		//sp.wait(durPbind);
		~p0Group.set(\gate, 0); // asegurarnos que se detenga el sintetizador de \p0
		sp.suspendAll;
        i = i + 1;
	}
	*/
