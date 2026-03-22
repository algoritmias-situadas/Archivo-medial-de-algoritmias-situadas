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


~t.tempo = 105/60;

////////////////// FUNCIONES ////////////////////////
// en caso de que se hayan detenido los grupos y ejecuta la siguiente línea y
// ~inicio.()

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~reverbBus.postln;
( // se puede evaluar y reproducir esta sección
Pdef(\lsystem, Pspawner({
	arg sp;
	var beatInicio = thisThread.clock.beats, beatActual;


	~pbs = ~secuencias.(
		arbol:               [[0]  ],
		raiz: 70, // nota midi
		instrumentos:        [\sampler    ], // esto tiene que ser un arreglo
		buffer:              [~smp        ], // si no se asigna un sample por defecto será nil
		silencios:           [[]          ],
		loop:                [1           ],
		repSecuencia:        [1           ],
		dur:                 [inf         ],
		escala: Scale.lydian,
		pan:                 [0           ],
		attack:              [1           ],
		release:             [1.5         ],
		amp:                 [15.dbamp    ],
		sendLvl:             [0           ],
	);

	Pbindef(\p0).source = ~pbs[0];

	Pbindef(\p0, \group, ~p0Group);

	beatInicio = thisThread.clock.beats;
	beatActual = thisThread.clock.beats - beatInicio;
	beatActual.debug("Beat Actual");

	sp.par(Pfindur(20, Pdef(\perc1)));
	sp.par(Pfindur(20, Pdef(\perc2)));
	sp.par(Pfindur(20, Pbindef(\p0)));

	sp.wait(20);
	~p0Group.set(\gate, 0);


})).play(~t, quant: 1);
)

Pdef(\lsystem).stop




