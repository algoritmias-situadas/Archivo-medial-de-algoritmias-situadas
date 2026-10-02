//Nota: en caso de utilizar un equipo de computo con windows o linux, deberas de alguna manera instalar algun programa que te permita crear algun puerto midi que conecte Supercollider con ableton live



(
MIDIClient.init;
//m = MIDIOut.newByName

~midiOut = MIDIOut.newByName("Driver IAC", "Bus 1");
//~midiOut = MIDIOut.newByName("Driver IAC", "Bus 2");
~midiOut.latency = 0;


t = TempoClock(60/90);

// directorio de duraciones para ptpars
~durac = 60/90 * 4; // duracion compas 6.0
~durA = ~durac * 8;
~durB = ~durac * 32;
~durC = ~durac * 2;
~durD = ~durac * 6;
~durE = ~durac * 28;
~durF = ~durac * 16;
//ritmos

SynthDef(\Gestosr, {|buf, start = 0, rate = 1, loop = 0, pan = 0, dur,
	out = 0, amp = 0.5, atk = 0.1, rel = 0.5, cur =1, gate = 1, mix = 0.56, room = 0.9|
	var env, sig, paneo;
	sig = PlayBuf.ar(2, buf, rate * BufRateScale.kr(buf), 1.0, start, loop)[0];
	env = EnvGen.kr(Env.asr(atk, 1, rel , cur), gate, doneAction: 2);
	paneo = Line.kr(pan, pan.neg, dur);
	sig = FreeVerb2.ar(sig, sig, mix, room);
	Out.ar(out, Pan2.ar(sig * env, paneo, amp));
}).add;


(
~path = "/Users/omaravisac/Desktop/R.A.2/";
~nombres = [
	"atmos.wav",
	"bell.wav",
	"drumloopindustrial.wav",
	"footstep.wav",
	"micraindrops.wav",
	"walkman.wav",
	"washingmachine.wav",

	"estegisaurus.mp3",
	"guitarra01.mp3",
	"guitarra1.wav",
	"gramofono.mp3",

	"escalaCpiano.wav",
	"somberchords.wav",
	"violinefects.wav",

	"estabanmuertos.aif",
	"hjsdep.aif",
	"luchadiscurso.aif",
	"viastren1.aif",
	"dlucha.aif"
];

~bofs = ~nombres.collect{|x| Buffer.read(s, ~path ++ x)};
);


~bf0 = ~bofs[0..6];
~bf1 = ~bofs[7..10];
~bf2 = ~bofs[11..13];
~bf3 = ~bofs[14..19];

(
~ges1 = Pbind(\instrument, \Gestosr,
	\buf, Prand(~bf0, inf),
	\start, Pfunc{arg e; rrand(0, e.buf.numFrames)},
	\dur, Pwhite(0.1, 0.9),
	\atk, Pwhite(0.001, 0.125),
	\rel, Pwhite(0.01, 2),
	\cur, Pwhite(-2.0, 2),
	\pan, Pwhite(-1.0, 1),
	\rate, Pwhite(-5, 3.0),
	\loop, 1,
	\amp, Prand([0.5,0.7,0.6,0.8,0.9,1.0,1.1,1.2],inf),
);
);
(
~ges2 = Pbindf(~ges1,
	\buf, Prand(~bf1, inf),
	\start, Pfunc{arg e; rrand(0, e.buf.numFrames)},
	\dur, Pwhite(0.1, 0.7),
	\atk, Pwhite(0.001, 0.125),
	\rel, Pwhite(0.01, 0.5),
	\cur, Pwhite(-2.0, 2),
	\pan, Pwhite(-1.0, 1),
	\rate, Pwhite(-5, 3.0),
	\amp, 0.9,
	\loop, 1
);
//~ges2.
(
~ges3 = Pbindf(~ges1,
	\buf, Pdup(Pwhite(50,100),Prand(~bf2, inf)),
	\start, Pfunc{arg e; rrand(0, e.buf.numFrames)},
	\dur, Pwhite(0.1, 0.2),
	\atk, Pwhite(0.001, 0.125),
	\rel, Pwhite(0.01, 0.9),
	\cur, Pwhite(-2.0, 2),
	\pan, Pwhite(-0.5, 0.5),
	\rate, Pwhite(-5, 3.0),
	\amp, Prand([0.5,0.7,0.6,0.8,0.9,1.0,1.1,1.2],inf),
	\loop, 1
);

(
~sam1 = Pbindf(~ges1,
	\buf, Prand(~bf3, inf),
	\start, 0.01,
	\dur, 50,
	\atk, Pwhite(0.001, 0.125),
	\rel, 2,
	\cur, Pwhite(-2.0, 2),
	\pan, Pwhite(-1.0, 1),
	\rate, Pwhite(0.7, 1.1),
	\loop, 1,
	\amp, 1
);
);
(
~sm1 = Pbind(\type, \midi,
	//\midicmd,
	//\noteOn,
	\midiout, ~midiOut,
	\chan, [4],
	\midiNote, 64,
//    \octave, 5,
    //\velocity, 127,
    \dur, 200,
	\amp, 0.5,


);
)
)
);


//h = Ptpar([0.0, ~ges1.finDur(~durA), 6.0, ~ges2.finDur(~durE), 12.0, ~ges3.finDur(~durE), 18.0, ~sam1.finDur(~durE), 12.0 , ~sm1.finDur(~durB)]);
h = Ptpar([0.0, ~ges1.finDur(~durE), 6.0, ~ges2.finDur(~durE), 12.0, ~ges3.finDur(~durE), 18.0, ~sam1.finDur(~durE), 12.0 , ~sm1.finDur(~durB)]);




//-----------------------------------------parte B--------------------------------------------
//Scale.directory

~rit1 = Pseq([[0, 4b], [0, 4b], 4b, 0]);
~rit2 = Pseq([[2, 4b], [0, 4b], 4b, [0, 4b]]);
~rit3 = Pseq([[0, 4b], 4b, 6b, 0]);
~rit4 = Pseq([[2, 6b], [0, 4b], 4b, [1, 6b]]);


(
~walkm = Pbind(
    \type, \midi,
    \octave, 4,
    \degree, Pseq([0, 4, 2, 3], inf),
    \scale, Scale.minor,
    \midiout, ~midiOut,  // Asegúrate de que ~midiOut esté correctamente configurado
    \chan, 0,
	\rel, 4,
    \dur, Pseq([3, 1, 2, 2], inf),  // Duraciones de las notas
    \amp, Pseq([0.8, 0.5, 0.8, 0.65], inf),  // Amplitudes de las notas

);
);

(
~sm2 = Pbind(\type, \midi,

	\scale, Scale.minor,
	\degree, Pseq([0, 1, 2, 3, 4, 5, 6] ++ Pshuf([0, 2, 4], inf), inf).trace, //~prog1,
	\midiout, ~midiOut,
	\chan, 1,
	\db, Pwhite(-18, -6),
	\dur, Pseq([0.5, 0.25, 0.75, 0.5, 0.5, 1.0, 0.25], inf),
	//Psubdivide(Prand([2,3,5], inf), Prand([2,4,8], inf)),
	\rel, 4,
	\pan, Pwhite(-1.0, 1),

);
);

(
~sDrum = Pbind(\type, \midi,
	\midiout, ~midiOut,
	\octave, 3,
	\degree,Pseq([~rit1, ~rit2, ~rit3, ~rit4]//++Pshuf([Prand([[0, 4b],[2, 4b],[1, 4b]],inf),Prand([[2, 6b],4b, [0,4b]],inf)], inf)
		,inf).trace,
	\dur,Pseq([Pseq([0.125],32)
		//[0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25
	], inf),
	\amp, Pseq([0.65, 0.25, 0.25, 0.5, 0.5, 1.0, 0.25, 0.40], inf),
	\chan, 3,
	\rel, 4,

);
);

(
~ges2 = Pbindf(~ges1,
	\buf, Prand(~bf1, inf),
	\start, Pfunc{arg e; rrand(0, e.buf.numFrames)},
	\dur, Pseq([0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25], inf),
	\atk, Pwhite(0.001, 0.125),
	\rel, Pwhite(0.01, 1.5),
	\cur, Pwhite(-2.0, 2),
	\pan, Pwhite(-1.0, 1),
	\rate, Pwhite(-5, -1),
	\amp, Pseq([0.25, 0.125, 0.125, 0.25, 0.25, 0.4, 0.125, 0.17], inf),
	\loop, 1
);
);
//o = Ptpar([~durC,~sm2.finDur(~durB), 0.0 ,~walkm.finDur(~durA), ~durD, ~sDrum.finDur(~durB), ~durD, ~ges2.finDur(~durB)])
o = Ptpar([~durC,~sm2.finDur(~durB), 0.0 ,~walkm.finDur(~durA), ~durD, ~sDrum.finDur(~durB), ~durD, ~ges2.finDur(~durB)])
)



//~ges2.play(t)
// ~sDrum.stop

//b.stop





//o.play(t)
//o.free(t).





////original///
(
r{ //t = TempoClock(90/60);

	h.play(t);
	"empecè".postln;
	~durE.wait;
	~midiOut.allNotesOff(4);
	"empecè o".postln;
	o.play(t);
	~durA.wait;
	h.play(t);
	~durE.wait;
	~midiOut.allNotesOff(4);
	"va de nuez o".postln;
	o.play(t);
	~durA.wait;
	h.play(t);
	~durB.wait;
	~midiOut.allNotesOff(4);
}.play(t);
)

///corto/ otra version en vivo
(
r{ //t = TempoClock(90/60);

	h.play(t);
	"empecè".postln;
	~durE.wait;
	~midiOut.allNotesOff(4);
	"empecè o".postln;
	o.play(t);
	~durF.wait;
	h.play(t);
	~durE.wait;
	~midiOut.allNotesOff(4);
}.play(t);
)






~midiOut.allNotesOff(0)

)


h.play