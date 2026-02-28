//Pdefs

//Al principio está esta melodía diseñada para sonar al estilo de las canciones de inicio de Pokemon.

(
~melodia = Pbind(
    \instrument, \synth8bit,
	\scale, Scale.chromatic,
    \degree, Pseq([-3, 1, 4, 9, 11]+12, inf),
    \amp, 0.5,
    \pulseWidth, Pwhite(0.1, 0.9),
    \dur, 0.2,
    \pan, Pwhite(-1.0, 1.0)
)//.play;
);

(
~acordes = Pbind(
	\instrument, \synth8bitchords,
	\scale, Scale.major,
	\degree, Pseq([[0, 2, 4], [4, 1, 6]], inf),
	\dur, 4,
	\root, 2,
	\legato, 0.2,
	\amp, 0.4
)//.play
);

(
~bajo = Pbind(
	\instrument, \synth8bitbass,
	\scale, Scale.major,
	\degree, Pseq([0, 4, 4, 1], inf),
	\dur, 2,
	\root, -22,
	\legato, 0.2,
	\amp, 0.5
)//.play
);

//Después vienen Melodías en Pdefs aleatorias donde todos los valores de frecuencia o grado estan basados en estadisticas de pokemones que forman parte un mi equipo de 6 principal de una partida pasada de pokemon esmeralda, también los legatos estan hechos con la cantidad de pokemones que hay en diferentes generaciones.

(
Pdef(\defensa,  Pbind(
	\instrument, \synth8bit,
	\amp, 0.7,
	\dur, Pwrand([0.25, 0.75], [7, 2].normalizeSum, inf),
	\freq, Pwrand([53, 63, 49, 30, 62, 48, 88, 39, 55, 55, 66, 58], [6, 8,
		7, 8, 7, 8, 9, 7, 7, 4, 7, 7].normalizeSum, inf).midicps/2,
	\legato, 151/100,
))
);
/*Pdef(\defensa).play
Pdef(\defensa).stop*/

(
Pdef(\defensa2,  Pbind(
	\instrument, \synth8bit,
	\amp, 0.8,
	\dur, Pwrand([0.25, 0.75]/2, [2, 6].normalizeSum, inf),
	\scale, Scale.minor,
	\root, 4,
	\degree, Pwrand(([53, 63, 49, 30, 62, 48, 88, 39, 55, 55, 66, 58]*0.1).round, [6, 8,7, 8, 7, 8, 9, 7, 7, 4, 7, 7].normalizeSum, inf),
	\octave, 6,
	\legato, 100/151,
))
);

/*Pdef(\defensa2).play
Pdef(\defensa2).stop*/


(
Pdef(\defensa3,  Pbind(
	\instrument, \synth8bit,
	\amp, 0.8,
	\dur, Pwrand([0.25, 0.75]*2, [2, 6].normalizeSum, inf),
	\scale, Scale.minor,
	\root, 4,
	\degree, Pwrand(([53, 63, 49, 30, 62, 48, 88, 39, 55, 55, 66, 58]*0.1).round, [6, 8,7, 8, 7, 8, 9, 7, 7, 4, 7, 7].normalizeSum, inf),
	\octave, 4,
	\legato, 386/151,
))
);

/*Pdef(\defensa3).play
Pdef(\defensa3).stop*/


(
Pdef(\defensa4,  Pbind(
	\instrument, \synth8bit,
	\amp, 0.7,
	\dur, Pwrand([0.25, 0.75]/2, [2, 6].normalizeSum, inf),
	\scale, Scale.minor,
	\root, 4,
	\degree, Pwrand(([53, 63, 49, 30, 62, 48, 88, 39, 55, 55, 66, 58]*0.1).round, [6, 8,7, 8, 7, 8, 9, 7, 7, 4, 7, 7].normalizeSum, inf),
	\octave, 7,
	\legato, 386/151,
))
);

// Pdef(\defensa4).play
// Pdef(\defensa4).stop

~defensita = Ptpar([0, Pdef(\defensa2), 1, Pdef(\defensa3), 1, Pdef(\defensa4)], 1);
// ~defensita.play

(
Pdef(\ataque,  Pbind(
	\instrument, \synth8bit,
	\amp, 0.7,
	\dur, Pwrand([0.25, 0.75], [7, 2].normalizeSum, inf),
	\freq, Pwrand([51, 45, 54, 33, 52, 47, 95, 27, 77, 75, 49, 58], [6, 8,
		7, 8, 7, 8, 9, 7, 7, 4, 7, 7].normalizeSum, inf).midicps/2,
	\legato, 106/100,
))
);

(
Pdef(\ataque2,  Pbind(
	\instrument, \synth8bit,
	\amp, 0.8,
	\dur, 4,
	\freq, Pwrand([[51, 45, 54], [33, 52, 47], [95, 27, 77], [75, 49, 58]], [7, 6, 4, 8].normalizeSum, inf).midicps/2,
	\legato, 386/100,
))
);

(
Pdef(\ataque3,  Pbind(
	\instrument, \synth8bit,
	\amp, 0.6,
	\dur, 0.5,
	\freq, Pwrand([51, 45, 54, 33, 52, 47, 95, 27, 77, 75, 49, 58], [6, 8,
		7, 8, 7, 8, 9, 7, 7, 4, 7, 7].normalizeSum, inf).midicps,
	\legato, 135/65,
))
);

(
Pdef(\speed,  Pbind(
	\instrument, \synth8bit,
	\amp, 0.8,
	\dur, Pwrand([0.25, 0.75]/2, [2, 6].normalizeSum, inf),
	\scale, Scale.bayati,
	\root, -3,
	\degree, Pwrand(([104, 27, 69, 77, 46, 45, 104, 72, 89, 69, 88, 74]*0.2).round, [6, 8, 7, 8, 7, 8, 9, 7, 7, 4, 7, 7].normalizeSum, inf),
	\octave, 4,
	\legato, 151/386,
))
);

(
Pdef(\speed2,  Pbind(
	\instrument, \synth8bit,
	\amp, 0.8,
	\dur, Pwrand([1, 0.5, 2]/2, [4, 2, 4].normalizeSum, inf),
	\scale, Scale.bayati,
	\root, -3,
	\degree, Pwrand(([104, 27, 69, 77, 46, 45, 104, 72, 89, 69, 88, 74]*0.2).round, [6, 8, 7, 8, 7, 8, 9, 7, 7, 4, 7, 7].normalizeSum, inf),
	\octave, 1,
	\legato, 386/151,
))
);

(
Pdef(\speed3,  Pbind(
	\instrument, \synth8bit,
	\amp, 0.8,
	\dur, Pwrand([4, 2], [4, 2].normalizeSum, inf),
	\scale, Scale.bayati,
	\root, -3,
	\degree, Pwrand([[104, 27, 69], [77, 46, 45], [104, 72, 89], [69, 88, 74]] * 0.2, [6, 8, 7, 8].normalizeSum, inf).round,
	\octave, 2,
	\legato, 386 / 151
))
);

//Después vienen Pbinds utilizando las estadisticas de pokemónes específicos, cada Pdef lleva el nombre del pokémon en el que esta basado, y las probabilidades de cada nota estan hechas con los valores IV's y EV's de ese mimso pokemon.


(
Pdef(\Jolteon,  Pbind(
	\instrument, \synth8bit,
	\db, Pseg([-20, -10, -10, -40], [5, 20, 5]),
	\dur, 0.25,
	\scale, Scale.bartok,
	\root, 4,
	\degree, Pwrand(([104, 51, 53, 95, 88, 106]/9).round, [21, 25, 10, 24, 13, 29].normalizeSum, inf),
	\octave, 5,
	\legato, 3,
))
);

/*Pdef(\Jolteon).play
Pdef(\Jolteon).stop*/


(
Pdef(\Charizard,  Pbind(
	\instrument, \synth8bit,
	\amp, 0.8,
	\dur, Pwrand([0.25, 0.75], [2, 6].normalizeSum, inf),
	\scale, Scale.chinese,
	\root, 4,
	\degree, Pwrand(([89, 54, 49, 77, 55, 69]/8).round, [15, 3, 17, 5, 2, 17].normalizeSum, inf),
	\octave, 4,
	\legato, 3,
))
);

/*Pdef(\Charizard).play
Pdef(\Charizard).stop*/

(
Pdef(\Aron,  Pbind(
	\instrument, \synth8bit,
	\amp, 0.7,
	\dur, Pwrand([0.5, 0.75], [4, 6].normalizeSum, inf),
	\root, 4,
	\degree, Pwrand([72, 45, 63, 27, 39, 27]/8.round, [1, 5, 2, 4, 3, 12/2].normalizeSum, inf).midicps,
	\octave, 2,
	\legato, 386/151,
))
);


(
Pdef(\Kadabra,  Pbind(
	\instrument, \synth8bit,
	\amp, 0.7,
	\dur, Pwrand([0.25, 0.5, 0.75], [2, 6, 4].normalizeSum, inf),
	\freq, Pwrand([69, 33, 30, 75, 55, 77], [5, 19, 18, 10, 6, 19].normalizeSum, inf).midicps,
	\legato, 3,
))
);

/*Pdef(\Kadabra).play
Pdef(\Kadabra).stop*/


(
Pdef(\Bulbasaur,  Pbind(
	\instrument, \synth8bit,
	\amp, 0.7,
	\dur, Pwrand([0.25, 0.75, 0.5], [2, 4, 7].normalizeSum, inf),
	\root, 4,
	\freq, Pwrand([74, 47, 48, 58, 58, 45], [12, 10, 9, 11, 6, 9].normalizeSum, inf).midicps,
	\octave, 3,
	\legato, 151/100,
))
);

/*Pdef(\Bulbasaur).play
Pdef(\Bulbasaur).stop*/


(
Pdef(\Warturtle,  Pbind(
	\instrument, \synth8bit,
	\amp, 0.7,
	\dur, Pwrand([0.25, 0.5, 0.75], [2, 6, 4].normalizeSum, inf),
	\root, 4,
	\freq, Pwrand([88, 52, 62, 49, 66, 46], [6, 13, 13, 13, 4, 9].normalizeSum, inf).midicps,
	\octave, 4,
	\legato, 0.4,
))
);

/*Pdef(\Warturtle).play
Pdef(\Warturtle).stop*/


(
Pdef(\Gyarados,  Pbind(
	\instrument, \synth8bit,
	\amp, 0.7,
	\dur, Pwrand([0.25, 0.75], [2, 6].normalizeSum, inf),
	\freq, Pwrand([118, 111, 60, 48, 80, 70], [18, 22, 20, 4, 17, 25].normalizeSum, inf).midicps/4,
	\legato, 2,
))
);

/*Pdef(\Gyarados).play
Pdef(\Gyarados).stop*/


(
Pdef(\Combusken,  Pbind(
	\instrument, \synth8bit,
	\amp, 0.7,
	\dur, 0.2,
	\freq, Pwrand([55, 49, 32, 36, 31, 27], [5, 7, 10, 13, 3, 8].normalizeSum, inf).midicps*2,
	\legato, 0.2,
))
);

/*Pdef(\Combusken).play
Pdef(\Combusken).stop*/

(
Pdef(\defensaF,  Pbind(
	\instrument, \synth8bit,
	\db, Pseg([-12, -1, -1, -40], [15, 30, 5]),
	\dur, Pwrand([0.25, 0.75], [7, 2].normalizeSum, inf),
	\freq, Pwrand([53, 63, 49, 30, 62, 48, 88, 39, 55, 55, 66, 58], [6, 8,
		7, 8, 7, 8, 9, 7, 7, 4, 7, 7].normalizeSum, inf).midicps/2,
	\legato, 106/100,
));
);

/*Pdef(\defensaF).play
Pdef(\defensaF).stop*/

//Aquí hay un par de ideas sin usar que utilizan un sample.

(
~introchop = Pbind(
    \instrument, \IntroTheme,
    \buf, ~bof,
    \dur, 0.6,
    \amp, Pexprand(0.5, 0.8),
    \rate, Pexprand(0.8, 1.5),
    \pan, Pwhite(-1.0, 1.0),
)
);


(
~sampi = Pmono(
	\buff, \buf, ~bof,
	\amp, 0.7,
	\dur, 10,
	\rate, Pwhite(-1.0, 2.0)
));

//Tambien esta un Pdef que lleva una melodíacombinando el nivel de todos los pokemones que hay en esa partida.

(
Pdef(\nivel, Pbind(
	\instrument, \synth8bit,
	\db, Pseg([-20, -1, -1, -40], [10, 30, 5]),
	\dur, 0.2,
	\freq, Pwrand([37, 29, 29, 31, 33, 28, 15, 10, 8, 6, 15, 20, 6, 12, 12, 13, 12, 14, 15, 14, 5, 7, 7, 18, 10, 14, 5, 35, 25, 21, 28, 25, 30], [71, 68, 59, 77, 78, 140, 99, 58, 121, 116, 109, 77, 75, 76, 106, 66, 128, 68, 119, 97, 134, 78, 102, 118, 90, 90, 93, 106, 76, 89, 91, 85, 106].normalizeSum, inf).midicps*2,
	\legato, 0.3,
))
);

//Y finalmente hice otra melodía pensada para cuando vences al campeón de cada región y salen los créditos del juego al final.

(
~melodiafinal = Pbind(
    \instrument, \synth8bit,
    \scale, Scale.major,
	\degree, Pseq([0, 4, 7, 5, 9, 7, 12, 11, 8, 4], inf),
	\root, 2,
    \amp, 0.6,
    \dur, 0.2,
    \pan, Pwhite(-0.9, 0.9)
));

(
~acordesfinal = Pbind(
    \instrument, \synth8bit,
    \scale, Scale.major,
	\degree, Pseq([[0, 2, 4, 7], [9, 7, 5, 12], [0, 2, 4, 9], [7, 5, 9, 4]], inf),
	\root, 2,
    \amp, 0.6,
    \dur, 4,
    \pan, Pwhite(-0.5, 0.5),
	\legato, 386/100,
));

(
~bajofinal = Pbind(
    \instrument, \synth8bit,
    \scale, Scale.major,
	\degree, Pseq([0, 4, 7, 5, 9, 7], inf),
	\root, 2,
    \amp, 0.6,
    \dur, Pwrand([1, 2], [6, 5].normalizeSum, inf),
    \pan, Pwhite(-0.9, 0.9),
	\octave, 2,
	\legato, 386/151
));

//Esta es una pequeña colección de las melodias dentro del Pfsm

~intro = Ptpar([0, ~melodia.finDur(80), 8, ~acordes.finDur(48), 16, ~bajo.finDur(64)], 1);
//~introplayer = ~intro.play
//~introplayer.stop

~defensita = Ptpar([0, Pdef(\defensa2), 1, Pdef(\defensa3), 1, Pdef(\defensa4)], 1);
//~defensitaplayer = ~defensita.play
//~defensitaplayer.stop

~nivelmelodia = Ptpar([0, Pdef(\nivel).finDur(30)], 1);
//~nivelmelodiaplayer = nivelmelodia.play
//~nivelmelodiaplayer.stop

~velocito = Ptpar([0, Pdef(\speed).finDur(80), 8, Pdef(\speed2).finDur(64), 16, Pdef(\speed3).finDur(48)], 1);
//~velocitoplayer = ~velocito.play
//~velocitoplayer.stop

~final = Ptpar([0, ~melodiafinal.finDur(94), 8, ~acordesfinal.finDur(72), 16, ~bajofinal.finDur(72)], 1):
//~finalplayer = ~final.play
//~finalplayer.stop


~ataquito = Ptpar([0, Pdef(\ataque).finDur(72), 16, Pdef(\ataque2).finDur(64), 8, Pdef(\ataque3).finDur(40)], 1);
//~ataquitoplayer = ~ataquito.play
//~ataquitoplayer.stop

~finalfinal = Ptpar([0, ~acordesfinal.finDur(4)],1),
//finalfinal.play








