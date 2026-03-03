s.boot;
//hay que cargar estos archivos primero


(
"arboles.scd".loadRelative;
"rythm-l-system.scd".loadRelative;
"secuencias arboles.scd".loadRelative;
"sintes.scd".loadRelative;
"sampler.scd".loadRelative;
"inicio.scd".loadRelative
)


////////////////// FUNCIONES ////////////////////////
// en caso de que se hayan detenido los grupos y ejecuta la siguiente línea y
// ~inicio.()

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

( // se puede evaluar y reproducir esta sección
Pdef(\lsystem, Pspawner({
	arg sp;
	var beatInicio = thisThread.clock.beats;


	~pbs = ~secuencias.(
		arbol:               [[0]  ],
		raiz: 70, // nota midi
		instrumentos:        [\sampler    ], // esto tiene que ser un arreglo
		buffer:              [~smp        ], // si no se asigna un sample por defecto será nil
		silencios:           [[]          ],
		loop:                [0           ],
		repSecuencia:        [1           ],
		durRaiz:             [20          ],
		escala: Scale.lydian,
		pan:                 [0           ],
		attack:              [1           ],
		release:             [1.5         ],
		amp:                 [-2.dbamp    ],
		sendLvl:             [0           ],
	);

	Pbindef(\p0).source = ~pbs[0];

	Pbindef(\p0, \group, ~p0Group);

	sp.par(Pfindur(10, Pdef(\perc1)));
	sp.par(Pfindur(10, Pdef(\perc2)));
	sp.par(Pfindur(10, Pbindef(\p0)));
	~p0Group.set(\gate, 0);

	/*loop {
		var beatsTranscurridos = thisThread.clock.beats - beatInicio;

		postln("Contador Beat: " ++ beatsTranscurridos.round(0.01));

		if (beatsTranscurridos >= 10) {
			// sp.suspendAll;
			sp.suspend(Pbindef(\perc1));
			sp.suspend(Pbindef(\perc2));
			sp.suspend(Pbindef(\p0));
			postln("todo detenido")
		};
		sp.wait(1)
	};*/


})).play(~t, quant: 1);
)

Pdef(\lsystem).stop
