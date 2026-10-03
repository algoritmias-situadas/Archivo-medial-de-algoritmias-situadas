
///////////////////////////////////////PBINDS///MIDIS/////DIRECTORIOS////////////////////////////////

//ESTOS DIRECTORIOS SE COMPONEN POR UN PBIND MIDI PRINCIPAL Y 3 PBINDF`S QUE ACEN ALUCION A LOS PATRAMETROS PRINCIPALES DEL PBIND ORIGINAL.

//LO IMPORTANTE DENTRO DE ESTOS SON SU MIDIOUT, SU DEGREE, SU DUR Y SU CHAN. EL MIDIOUT ESTA CONECTADO AL BUS MIDI ASIGNADO A ABLETON Y CHAN ESPICIFICA EL CANAL AL CUAL SE ASIGNA. EL DEGREE COMO EL DUR TOMA LOS MATERIALES DEFINIDOS EN EL ARCHIVO SCD MATERIALES.

//

////////DIRECTORIO//PBINDS///DRUMS///BUS 1
(

~sDrum1 =Pbind(\type, \midi,
	\midiout, ~midiOut,
	\octave, 3,
	\degree, Pseq(~groove1, inf),//~strG[0],
	\dur, ~strD[0],
	\chan, 0,
	\amp, Pseq([0.65, 0.25, 0.25, 0.5, 0.5, 1.0, 0.25, 0.40], inf),
	\rel, 4,
);

~sDrum2 =Pbindf(~sDrum1,
	\degree, Pseq(~groove2, inf),
	\dur, Pseq([~strD[3]],inf),
	\chan, 1,
);

~sDrum3 =Pbindf(~sDrum1,
	\degree, Pseq(~groove3, inf),
	\dur, Pseq([0.25], inf),
	\chan, 2,
);


~sDrum4 =Pbindf(~sDrum1,
	\degree, Pseq(~groove4, inf),
	\dur, Pseq([~strD[3]],inf),
	\chan, 3,
);


//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\DIRIRECTORIO\\DE\\PBINDS\\MIDIS\\\\PRIMER\\SAMPLE\\\BUS\\2\\\\\\\\\\


~instru1a = Pbind(
    \type, \midi,
	\octave,Pseq(~voicing1a,inf),
	\root, [6],
	\degree, Pseq(~prog1a,inf),//~strA[0],
    \scale, Scale.minor,
    \midiout, ~midiOut2,
    \chan, 0,
	\rel, 1,
    \dur, ~strD[0],
    \amp, Pseq([0.65, 0.4, 0.3, 0.25], inf),
	\pan,Pwhite(-1.0, 1),
);

~instru2a = Pbindf(~instru1a,
    \octave, Pseq(~voicing1b,inf),
	\degree, Pseq(~prog2a, inf),
    \scale, Scale.minor,
    \chan, 1,
	\rel, 1,
    \dur, ~strD[1],
    \amp, Pseq([0.65, 0.45, 0.25, 0.125], inf),
	\pan, Pwhite(-1.0, 1.0),
);

~instru3a = Pbindf(~instru1a,
    \octave, Pseq(~voicing1c,inf),
	\degree, Pseq(~prog3a, inf),
    \scale, Scale.minor,
    \chan, 2,
	\rel, 1,
    \dur, ~strD[2],
    \amp, Pseq([0.8, 0.5, 0.8, 0.65], inf),
	\pan, Pwhite(-1.0, 1),
);

~instru4a = Pbindf(~instru1a,
    \octave, Pseq(~voicing1,inf),
	\degree, Pseq(~prog4a, inf),
    \scale, Scale.minor,
    \chan, 3,
	\rel, 1,
    \dur, ~strD[3],
    \amp, Pseq([0.6, 0.5, 0.45, 0.65], inf),
	\pan, Pwhite(-1.0, 1.0),
);


//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\DIRIRECTORIO\\DE\\PBINDS\\MIDIS\\SEGUNDO\\SAMPLE\\\\\\\BUS\\3\\



~instru1b = Pbind(
    \type, \midi,
    \octave, Pseq(~voicing2a,inf),
	\root, [6],
	\degree, Pseq(~prog1b, inf),
    \scale, Scale.minor,
    \midiout, ~midiOut3,
    \chan, 0,
	\rel, 4,
    \dur, ~strD[1],
	\amp, Pseq( [Pwhite(0.0, 0.65)], inf),
	\pan, Pwhite(1, -1.0),
);

~instru2b = Pbindf(~instru1b,
    \octave, Pseq(~voicing2b,inf),
	\degree, Pseq(~prog2b, inf),
    \scale, Scale.minor,
    \chan, 1,
	\rel, 4,
    \dur, ~strD[2],
    \amp, Pseq([0.8, 0.5, 0.8, 0.65], inf),
	\pan, Pwhite(1, -1.0),
);

~instru3b = Pbindf(~instru1b,
	\octave, Pseq(~voicing2c,inf),
	\degree,Pseq(~prog3b, inf) ,
    \scale, Scale.minor,
    \chan, 2,
	\rel, 4,
    \dur, ~strD[3],
    \amp, Pseq( [Pwhite(0.0, 0.65)], inf),
	\pan, Pwhite(1, -1.0),
);

~instru4b = Pbindf(~instru1b,
	\octave, Pseq(~voicing2,inf),
	\degree, Pseq(~prog4b, inf),
    \scale, Scale.minor,
    \chan, 3,
	\rel, 4,
    \dur, ~strD[0],
    \amp, Pseq( [Pwhite(0.45, 0.65)], inf),
	\pan, Pwhite(1, -1.0),
);


//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\DIRIRECTORIO\\DE\\PBINDS\\MIDIS\\TERCER\SAMPLE\\BUS\\4\\\\\\\\


~instru1c = Pbind(
    \type, \midi,
    \octave, Pseq(~voicing3a,inf),
	\root, [6],
	\degree, Pseq(~prog1c, inf),
    \scale, Scale.minor,
    \midiout, ~midiOut4,
    \chan, 0,
	\rel, 4,
    \dur, ~strD[2],
    \amp, Pseq( [Pwhite(0.25, 0.5)], inf),
	\pan, Pwhite(1, -1.0)
);

~instru2c = Pbindf(~instru1c,
    \octave, Pseq(~voicing3b,inf),
	\degree, Pseq(~prog2c, inf),
    \scale, Scale.minor,
    \chan, 1,
	\rel, 4,
    \dur,~strD[3],
    \amp, Pseq( [Pwhite(0.125, 0.55)], inf),
	\pan, Pwhite(1, -1.0)
);



~instru3c = Pbindf(~instru1c,
	\octave, Pseq(~voicing3c,inf),
	\degree, Pseq(~prog3c, inf),
    \scale, Scale.minor,
    \chan, 2,
	\rel, 4,
    \dur, ~strD[0],
    \amp, Pseq( [Pwhite(0.45, 0.55)], inf),
	\pan, Pwhite(1, -1.0)
);


~instru4c = Pbindf(~instru1c,
	\octave, Pseq(~voicing3,inf),
	\degree, Pseq(~prog4c,inf),
    \scale, Scale.minor,
    \chan, 3,
	\rel, 4,
    \dur, ~strD[1],
    \amp, Pseq( [Pwhite(0.0, 0.65)], inf),
	\pan, Pwhite(1, -1.0)
);


///\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\DIRIRECTORIO\\DE\\PBINDS\\MIDIS\\CUARTO SAMPLE\\\\BUS//5//////////



~instru1d = Pbind(
    \type, \midi,
	\root, [6],
	\octave, Pseq(~voicing4a,inf),
	\degree, Pseq(~prog1,inf),
    \scale, Scale.minor,
    \midiout, ~midiOut5,
    \chan, 0,
	\rel, 4,
    \dur, ~strD[3],
    \amp, Pseq( [Pwhite(0.25, 0.65)], inf),
	\pan, Pwhite(1, -1.0),
);

~instru2d = Pbindf(~instru1d,
    \octave, Pseq(~voicing4b,inf),
	\degree, Pseq(~prog2,inf),
    \scale, Scale.minor,
    \chan, 1,
	\rel, 4,
    \dur, ~strD[0],
    \amp, Pseq( [Pwhite(0.4, 0.65)], inf),
	\pan, Pwhite(1, -1.0),
);

~instru3d = Pbindf(~instru1d,
	\octave, Pseq(~voicing4c,inf),
	\degree, Pseq(~prog3,inf),
    \scale, Scale.minor,
    \chan, 2,
	\rel, 4,
    \dur, ~strD[1],
    \amp, Pseq([Pwhite(0.3, 0.6)], inf),
	\pan, Pwhite(1, -1.0),
);

~instru4d = Pbindf(~instru1d,
	\octave, Pseq(~voicing4,inf),
	\degree, Pseq(~prog4,inf),
    \scale, Scale.minor,
    \chan, 3,
	\rel, 4,
    \dur, ~strD[2],
    \amp, Pseq( [Pwhite(0.39, 0.55)], inf),
	\pan, Pwhite(1, -1.0),
);


//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\DIRIRECTORIO\\DE\\PBINDS\\MIDIS\\\\GESTOS\\\BUS//6\\\\\\\\\


~ges1 = Pbind(
    \type, \midi,
	\root, [6],
	\octave, Prand([~voicing1a, ~voicing2a, ~voicing3a, ~voicing4a],inf),
	\degree, Prand(~todas1, inf),
    \scale, Scale.minor,
    \midiout, ~midiOut6,
    \chan, 0,
	\rel, 4,
    \dur, ~strD[3],
    \amp, Pseq( [Pwhite(0.1, 0.2)], inf),
	\pan, Pwhite(1, -1.0)
);

~ges2 = Pbindf(~ges1,
    \octave, Prand([~voicing1b, ~voicing2b, ~voicing3b, ~voicing4b],inf),
	\degree, Prand(~todas2,inf),
    \scale, Scale.minor,
    \chan, 1,
	\rel, 4,
    \dur, ~strD[2],
    \amp, Pseq([0.8, 0.5, 0.8, 0.65], inf),
	\pan, Pwhite(1, -1.0)

);

~ges3 = Pbindf(~ges1,
	\octave, Prand([~voicing1c, ~voicing2c, ~voicing3c, ~voicing4c],inf),
	\degree, Prand(~todas3,inf),
    \scale, Scale.minor,
    \chan, 2,
	\rel, 4,
    \dur, ~strD[1],
    \amp, Pseq( [Pwhite(0.0, 0.2)], inf),
	\pan, Pwhite(1, -1.0)
);

~ges4 = Pbindf(~ges1,
	\octave, Prand([~voicing1, ~voicing2, ~voicing3, ~voicing4].flatten,inf),
	\degree, Prand(~todas.flatten,inf),
    \scale, Scale.minor,
    \chan, 3,
	\rel, 4,
    \dur, ~strD[0],
    \amp, Pseq( [Pwhite(0.2, 0.3)], inf),
	\pan, Pwhite(1, -1.0)
);
)


