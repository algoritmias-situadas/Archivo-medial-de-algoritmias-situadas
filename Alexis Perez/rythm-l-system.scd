
~patrones = (
    4: [1.5, 1, 1.5],    // Divide el compás en 3 bloques irregulares
    1.5: [0.75, 0.75],   // Tensión rítmica
    0.75: [0.25, 0.5],   // Inversión del pulso
    0.5: [0.25, 0.25],
    1: [0.125, 0.125, 0.75]
);

~patronesDg = (
	3: [0,2,3],
	2: [1,2,3]
);

~patronesPerc1 = (
	\k1: [\k1, \bb, \rt, \rt, \s3, \rt, \rt, \rt],
	\rt: [\rt, \rt, \k1, \rt, \s3, \rt, \k1, \k1],
	\s3: [\rt, \rt, \k1, \bb, \s3, \rt, \k1, \rt],
	\bb: [\bb, \rt, \rt, \k1, \s3, \rt, \rt, \bb],
);

~patronesPerc2 = (
	\hh: [\rt, \hh, \rt, \rt, \rt, \hh, \hh, \rt],
);

~lm = Prewrite(
	3, // inicio
	 // patrones
	~patronesDg,
	2 // niveles
);


~linst1 = Prewrite(
	\k1, // inicio
	~patronesPerc1,
	3 // niveles
);

~linst2 = Prewrite(
	\hh, // inicio
	~patronesPerc2,
	3 // niveles
);


Pdef(\perc1,
    Pbind(
        \dur, 0.25,
        \instrument, ~linst1,
		\sendBus, ~reverbBus,
		\sendLvl, 0.4,
		\scale, Scale.minorPentatonic,
		\degree, Pfunc({ |ev|
			var stream;
			if (ev[\instrument] == \bb) { // Si el instrumento elegido en este paso es \bb...
				stream = ~lm.asStream;
				stream.next; // ... se obtiene el siguiente valor al stream tonal
			} {
				0
			};
		}),
		\group, ~master
	),
);


Pdef(\perc2,
    Pbind(
        \dur, 0.25,
        \instrument, ~linst2,
		\sendBus, ~reverbBus,
		\sendLvl, 0.4,
		\scale, Scale.minorPentatonic,
        \degree, Pfunc({ |ev|
			var stream;
            if (ev[\instrument] == \bb) { // Si el instrumento elegido en este paso es \bb...
                stream = ~lm.asStream;
				stream.next; // ... se obtiene el siguiente valor al stream tonal
			} {
				0
			};
		}),
		\group, ~master
	),
);

