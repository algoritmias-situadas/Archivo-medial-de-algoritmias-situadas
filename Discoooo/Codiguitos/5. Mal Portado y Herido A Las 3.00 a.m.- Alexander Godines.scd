

EFEEEEEEEEEECTOoOoOUUSSSS y respectivos BUSESSS

Nota: Se incluirán monitores de los efectos en la sección de Pbinds pa
no andar regresando hasta acá cada q pare la cosa esta

(
~mainBus = Bus.audio(s, 8);
~reverbBus = Bus.audio(s, 8);
~delayBus = Bus.audio(s, 8);

); ///--------SOLO EJECUTAR UNA VEZ PRROOOOO

s.options.numOutputBusChannels = 8;


(
SynthDef(\busToOutputs, {
	|inBus, outOffset = 0 |
    Out.ar(0, In.ar(inBus, 8));
}).add;

~monitor = Synth(\busToOutputs, [\inBus, ~mainBus]);

//Rebervsin
SynthDef(\reverbReturn, {
    |inBus, out=0, mix=0.8, room=3, damp=0.5|
    var sig, rev;
    sig = In.ar(inBus, 8);
    rev = FreeVerb.ar(sig, mix, room, damp);

    Out.ar(out, rev);
}).add;

//Monitor
~reverb = Synth(\reverbReturn, [
    \inBus, ~reverbBus,
    \mix, 1,
	\room, 3,
	\out, ~mainBus,
]).addToTailMsg;

//Dileiii
SynthDef(\delayReturn8, {
	|inBus, outBus, delayTime=0.25, feedback=0.4, mix=0.35|
	var in, delayed, sig;

	in = In.ar(inBus, 8);
	delayed = CombC.ar(in, 1, delayTime * Array.fill(8, { Rand(0.8, 1.2) }), feedback);

	sig = XFade2.ar(in, delayed, mix.linlin(0,1,-1,1));
	Out.ar(outBus, sig);
}).add;


//Monitor
~delayFX = Synth(\delayReturn8, [
	\inBus, ~delayBus,
	\outBus, ~mainBus,
	\delayTime, 0.1,
	\feedback, 12,
	\mix, 0.8
]).addToTailMsg;

);


----------------------------------------------------------------
----------------------------------------------------------------

SINTEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEES

(
//Los del principio

//SubbasssssssSSsSs
SynthDef(\subBass, {  | freq=60, amp=0.3, gate=1, atk=0.02, rel=1.5, cur = -4,  lpf=120, pan=0 |

    var env, sig, sine, saw;

    env = EnvGen.kr(Env.asr(atk, 1, rel, cur), gate, doneAction: 2);
    sine = SinOsc.ar(freq);
    saw  = Saw.ar(freq) * 0.2;
    sig = sine + saw;
    sig = LPF.ar(sig, lpf);
    sig = sig * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;


SynthDef(\padCuerdas, {
    |freq=440, amp=0.3, gate=1, atk=2, rel=4, pan=0, filtStart=400, filtEnd=6000, filtTime=10, send = 0.4|

    var sig, env, filtEnv, osc, detune, lfo;
   detune = [0.99, 1, 1.01];
    osc = Mix([Saw.ar(freq * detune), Pulse.ar(freq * detune, 0.4) * 0.5]);
    lfo = SinOsc.kr(0.08).range(0.8, 1.2);
    osc = osc * lfo;
    env = EnvGen.kr(Env.asr(atk, 1, rel, curve: -4), gate, doneAction: 2);
    filtEnv = EnvGen.kr(Env([filtStart, filtEnd], [filtTime], curve: 4));

    sig = LPF.ar(osc, filtEnv);
    sig = sig * env * amp;
    sig = Pan2.ar(sig, pan);

    Out.ar(~reverbBus, sig * send);
    Out.ar(0, sig);
}).add;


 SynthDef(\drone, {
        | out,freq, dur, amp, pan, width |
        var env = EnvGen.kr(Env.new([0, 1, 1, 0], [1.0, dur, 3.0]), doneAction:Done.freeSelf);
        var sig = Array.fill(20, {
            var multiplier = [
                0.99, 1, 1.01,
                1.99, 2, 2.01,
                3.99, 4, 4.01].choose;
            var ampmult = multiplier.reciprocal;
            RLPF.ar(
                in: LFSaw.ar(
                    freq:LFNoise1.kr(0.5.rrand(1.0)).range(freq*(1-width), freq*(1+width))*multiplier,
                    iphase:0.0.rrand(2pi)),
                rq: LFNoise1.kr(0.5).range(0.1,0.6),
                mul:LFNoise0.kr(2.0).range(16.reciprocal, ampmult));
        });
        var finalsig = Splay.ar(env*sig);
        var finalsig_panned = Balance2.ar(
            finalsig[0],
            finalsig[1],
            pan*SinOsc.kr(LFNoise1.kr(1).range(0.05,0.2)));
        Out.ar(out, amp*finalsig_panned);
},
    metadata: (
        credit: "Stefaan Himpe",
        category: \pad,
        tags: [\pitched]
    )).add;


SynthDef(\lead, {
        | out, freq, dur, amp = 0.7, pan, wobblelow=0.6, wobblehigh=1.0 |
        var atk = 0.5;
        var env = EnvGen.kr(Env([0, 1, 1, 0], [atk, dur-atk, 10]), doneAction:Done.freeSelf);
        var freqenv = EnvGen.kr(Env([0.7, 1, 1], [0.3, dur]), doneAction:Done.none);
        var sharpness = freq.cpsmidi.linlin(0,127,1,15);
        var wobble = SinOsc.kr(6).range(wobblelow, wobblehigh);
        var sig = RLPF.ar(
            in: LFSaw.ar(freqenv*freq*LFNoise1.kr(1.0).range(0.995,1.005)),
            freq:freq*sharpness,
            rq:LFNoise1.kr(3).range(0.2,0.5),
            mul:wobble);
        var panned_sig;
        var n = 10;
        n.do({ sig = AllpassN.ar(sig, 0.050, [Rand(0, 0.05), Rand(0, 0.05)], 1) });
        panned_sig = Pan2.ar(sig/n, pan);
        Out.ar(out, amp*env*panned_sig);
    },
    metadata: (
        credit: "Stefaan Himpe",
        category: \pad,
        tags: [\pitched]
    )).add;


//Campanitas parte mayors
SynthDef(\bell0, {|freq=1, t60=1, pitchy=1, amp=0.25, gate=1, pan = 0, mix = 0.4, send = 0, send2 = 0, chan =0, outBus, reverbBus |
	var sig, exciter, delay, wet, pos;
	exciter = Impulse.ar(0);
	exciter = WhiteNoise.ar() * EnvGen.ar(Env.perc(0.001, 0.05), gate) * 0.25;
	sig = Klank.ar(
		`[
			[1, 2, 2.803, 3.871, 5.074, 7.81, 10.948, 14.421],   // freqs
			[1, 0.044, 0.891, 0.0891, 0.794, 0.1, 0.281, 0.079], // amplitudes
			[1, 0.205, 1, 0.196, 0.339, 0.047, 0.058, 0.047]*t60     // ring times
		],
		exciter,
		freqscale:freq*pitchy);
	sig = sig*amp;
	sig = Mix(sig);
	//sig = PanAz.ar(8,sig, pos);

	Out.ar(outBus + chan, sig);
	pos = (chan / 7) * 2 - 1;
	wet = PanAz.ar(8, sig, chan / 7 * 2 - 1);

	Out.ar(reverbBus, PanAz.ar(8, sig, pos) * send);
	Out.ar(~delayBus, PanAz.ar(8, sig, pos) * send2);

	 DetectSilence.ar(sig, 0.001, 0.5, doneAction:2);
	//Out.ar(~delayBus, sig * send2);
	//Out.ar(out, sig);
}).add;


//ESTE ES EL HECHO MIERDA
SynthDef(\bell, {
	|freq=440, t60=1, pitchy=1, amp=0.2, pan=0, mix=0.25, delayTime=0.4, wet=0.3, chan =0, outBus, reverbBus, send = 0.2|
	var sig, exciter, delay, env;
	env = EnvGen.ar(Env.perc(0.001, t60), doneAction: 2);
	exciter = WhiteNoise.ar(0.2) * env;
	sig = Klank.ar(
		`[
			[1, 2, 2.803, 3.871, 5.074],
			[1, 0.3, 0.2, 0.15, 0.1],
			[2, 1.5, 1.2, 1, 0.8]],
		exciter,
		freqscale: freq * pitchy);
	delay = CombC.ar(sig, 1, delayTime, delayTime * 5);
	sig = XFade2.ar(sig, delay, wet.linlin(0, 1, -1, 1));
	sig = sig * amp;
	sig = FreeVerb.ar(sig, mix, 0.6, 0.4);
	sig = Mix(sig);

	Out.ar(outBus + chan, sig);
	wet = PanAz.ar(8, sig, chan / 7 * 2 - 1);
	Out.ar(reverbBus, wet * send);
	// sig = PanAz.ar(8, sig, pan, width: 1);
}).add;

//PAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD
SynthDef(\padColchon, {
	|freq=440, amp=0.3, pan=0, tempo=1, startBeat=2, peakBeat=7|
	var sig, env, atkTime, relTime;

	atkTime = (peakBeat - startBeat) / tempo;
	relTime = 0.01;
	env = EnvGen.ar(Env([0, 1, 0], [atkTime, relTime], curve: [4, -8]), doneAction: 2);

	sig = SinOsc.ar(freq);
	sig = sig + (SinOsc.ar(freq * 2, 0, 0.15))+ (SinOsc.ar(freq * 0.5, 0, 0.1));
	sig = LPF.ar(sig, 1200);
	sig = sig * env * amp;
	//sig = Pan2.ar(sig, pan);
	//Out.ar(0, sig);
	//sig = PanAz.ar(8, sig, 0, width: 2);
	sig = DelayC.ar(
    PanAz.ar(8, sig, 0, width: 2),
    0.02,
    Array.fill(8, { Rand(0.001, 0.015) })
);


	Out.ar(~reverbBus, sig * 0.2);
	Out.ar(~mainBus, sig * 0.5);
}).add;

//Pajarracos
SynthDef(\pajaros, {
	|buf=0, rate=1, start=0, amp=0.2, pan=0, atk=0.01, rel=2, send = 0.5|
	var sig, env;
	sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, startPos: start, doneAction: 0);
	env = EnvGen.ar(Env.perc(atk, rel, curve: -4), doneAction: 2);
	sig = sig * env * amp;
	sig = Mix([sig]);
	//sig = Pan2.ar(sig, pan);
	//sig = PanAz.ar(8, sig, pan, width: 1);
	//Out.ar(~reverbBus, sig * send);
	//Out.ar(0, sig);
	sig = PanAz.ar(8, sig, 0, width: 2);
	Out.ar(~reverbBus, sig * 0.6);
	Out.ar(~mainBus, sig * 0.5);
}).add;

~pajaritosuwu = Buffer.read(s, "C:/Users/danie/OneDrive/Desktop/Sonid0s/bird-singing-sound-effect-free-sound-effects.mp3");


);

------------------------------------------------------------------------------
------------------------------------------------------------------------------
VARIABLES uwu

(
t = TempoClock(55/60);
t.permanent = true;

//Intro uwu
~alturasIntro = [-2, -1, -3, -4];

// TEMAAAA
~alturasTema = [0, 1, 6, 5, 7, 9, 8, 7, 7];
~dursTema =     [8, 8, 6, 2, 8, 8, 8, 8, 8];

~alturasContra = [-2, -1, -3, -4, -3, 3, 2, -3];
~dursContra = [8];

~durTemaTotal = ~dursTema.sum;
~filtTimeSec = ~durTemaTotal / t.tempo;

//Parte Mayosita acá wonita
~dursMayor = [4];
r = Rest(~dursMayor);

~alturasCantusMayor = [5, r, 5, r, 4, r, 1, r, 3, r];
~alturasContraMayor = [-1b, r, -4, r, 2b, r, -1b, r, -2, r];

~acordesMayor = [[-1b, 3, 8, 12], [-4, 5, 10, 12], [2b, 6b, 9b, 11], [-1b,1, 8], [-2, 3, 7, 10]];

~alturasSopranoMayor = [12,14,15,15,14];
);


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

Los mentados pibainds

(
//INTROOOoooooooooooooooooooooooooooOOOOOO
~contraIntro = Pbind(
	\type, \midi,
	\midiout, ~midiOut,
	\chan, ~chan,

	\scale, Scale.major,
	\root, 5,
	\octave, 4,
	\degree, Pseq(~alturasIntro,2),
	\dur, Pseq(~dursContra,inf),
	\amp, 0.5,
	\legato, 0.8,
	\pan, Pwhite(-1,1,inf),
);

~subContraIntro = Pbind(
	\instrument, \subBass,
	\atk, 2,
	\rel, 6,
	\cur, 0.5,
	\lpf, Pwhite(400,880),

	\scale, Scale.major,
	\root, 5,
	\octave, 3,
	\degree, Pseq(~alturasIntro,2),
	\dur, Pseq(~dursContra,inf),
	\amp, 0.3,
	\legato, 1.2,
	\pan, 0,
);


//TEMAAAAAAaAAAAAAAAAAAaaaaaaaaaaaaaaaaaA
~cantus = Pbind(
	\instrument, \padCuerdas,
	\scale, Scale.major,
	\root, 5,
	\octave, 5,
	\degree, Pseq(~alturasTema ++ (~alturasTema + 7)),
	\dur, Pseq(~dursTema,inf),
	\amp, 0.09,
	\legato, 0.8,
	\pan, Pwhite(-1,1,inf),

	 \atk, 4,
    \rel, 3,
    \legato, 1.2,

    \filtStart, 300,
    \filtEnd, 15000,
    \filtTime, ~filtTimeSec,

    \pan, Pwhite(-0.5, 0.5)
);

~contra = Pbind(
	\instrument, \padCuerdas,
	\scale, Scale.major,
	\root, 5,
	\octave, 3,
	\degree, Pseq(~alturasContra ++ (~alturasContra + 7)),
	\dur, Pseq(~dursContra,inf),
	\amp, 0.04,
	\legato, 0.8,
	\pan, Pwhite(-1,1,inf)
);

~subContra = Pbind(
	\instrument, \subBass,
	\atk, 1.5,
	\rel, 5,
	\cur, 0.5,
	\lpf, Pwhite(100,400),

	\scale, Scale.major,
	\root, 5,
	\octave, 3,
	\degree, Pseq(~alturasContra),
	\dur, Pseq(~dursContra,inf),
	\amp, 0.4,
	\legato, 1.2,
	\pan, 0,
);

~cantusLead = Pbind(
	\instrument, \lead,
	\scale, Scale.major,
	\root, 5,
	\octave, 5,
	\degree, Pseq((~alturasTema + 7)),
	\dur, Pseq(~dursTema,inf),
	\amp, 0.6,
	\legato, 0.8,
	\pan, Pwhite(-1,1,inf),

	 \atk, 4,
    \rel, 3,
    \legato, 1.2,
    \pan, Pwhite(-0.5, 0.5)
);

~contraLead = Pbind(
	\instrument, \drone,
	\scale, Scale.major,
	\root, 5,
	\octave, 3,
	\degree, Pseq(~alturasContra),
	\dur, Pseq(~dursContra,inf),
	\amp, 0.7,
	\legato, 0.8,
	\pan, 0,
);


~desmadre  = Pbind(\instrument, \sonar_muestras,
	\dur, Prand([1/5, 1/7,2, 4, 1/3, 1/2, 1]*0.1, inf),
	\buf, Prand([a,b,c,d], inf),
	\vel, Pwhite(0.1, 2, inf),
	\inicio, Pwhite(0, Pfunc({|e| e.buf.numFrames}), inf),
	\durr, Pwhite(1, 4.5, inf),
	\amp, Pwhite(0.01,0.15),
	\reve, Prand([1, -1], inf),
	\pan, Pwhite(-1,1),
);


//Parte Mayosita uwu

//Vuelta 1


~cantusMayor= Pbind(
\instrument, \bell0,
	\t60, 9,
	\pitchy, 1,

	\scale, Scale.major,
	\root, 5,
	\octave, 5,
	\degree, Pseq(~alturasCantusMayor, inf),
	\dur, Pseq(~dursMayor, inf),
	\amp, 0.015,
	\legato, 1.5,

	 \outBus, ~mainBus,
    \reverbBus, ~reverbBus,
    \chan, Pxrand((0..7), inf),
    \send, 1,
);
//~cantusMayor.stop;

~contraMayor= Pbind(
\instrument, \bell0,
	\t60, 9,
	\pitchy, 1,

	\scale, Scale.major,
	\root, 5,
	\octave, 5,
	\degree, Pseq(~alturasContraMayor, inf),
	\dur, Pseq(~dursMayor, inf),
	\amp, 0.015,
	\legato, 1.5,

	 \outBus, ~mainBus,
    \reverbBus, ~reverbBus,

    \chan, Pxrand((0..7), inf),
    \send, 1,
);


~cantusMayorDIS= Pbind(
\instrument, \bell,
	\t60, 7,
	\pitchy, 1,

	\scale, Scale.major,
	\root, 5,
	\octave, 4,
	\degree, Pseq(~alturasCantusMayor, inf),
	\dur, Pseq(~dursMayor, inf),
	\amp, 0.01,
	\legato, 1.5,

	 \outBus, ~mainBus,
    \reverbBus, ~reverbBus,

    \chan, Pxrand((0..7), inf),
    \send, 0.1,
);



~contraMayorDIS= Pbind(
\instrument, \bell,
	\t60, 7,
	\pitchy, 1,

	\scale, Scale.major,
	\root, 5,
	\octave, 3,
	\degree, Pseq(~alturasContraMayor, inf),
	\dur, Pseq(~dursMayor, inf),
	\amp, 0.01,
	\legato, 1.5,

	\outBus, ~mainBus,
    \reverbBus, ~reverbBus,

    \chan, Pxrand((0..7), inf),
    \send, 0.1,
);



~padMayor = Pbind(
	\instrument, \padColchon,
	\tempo, t.tempo,
	\startBeat, 2,
	\peakBeat, 10,
	\amp, 0.6,
	\degree, Pseq(~acordesMayor, inf),
	\dur, 8,
	\root, 5,
	\octave, 3,
);



//Segunda vuelta Mayorsito

~pajaritos = Pbind(
	\instrument, \pajaros,

	\buf, ~pajaritosuwu,
	\dur, Prand([0.05, 0.07, 0.09, 0.12], inf),
	\start, Pwhite(0, Pfunc { |e| e.buf.numFrames - 4410 }),
	\rate, Pwhite(-1, 1.8),
	\pan, Pwhite(-1, 1),
	\amp, 0.1,
	\legato, 2.6,
	\pan, -1,
	\out, Pwhite(~reverbBus.index,~reverbBus.index+7)
);


//A esa rutina

~cantusMayor2= Pbind(
\instrument, \bell0,
	\t60, 7,
	\pitchy, 1,

	\scale, Scale.major,
	\root, 5,
	\octave, 5,
	\degree, Pseq(~alturasCantusMayor, inf ).collect { |x| if (x.isRest) { x } { x + 7 } },
	\dur, Pseq(~dursMayor, inf),
	\amp, 0.01,
	\legato, 1.5,

	 \outBus, ~mainBus,
    \reverbBus, ~reverbBus,

    \chan, Pxrand((0..7), inf),
    \send, 1,
	\send2, 1
);

//Vuelta 3 Mayorsito

~cantusMayor3= Pbind(
\instrument, \bell0,
	\t60, 4,
	\pitchy, 1,

	\scale, Scale.major,
	\root, 5,
	\octave, 5,
	\degree, Pseq(~alturasSopranoMayor, inf),
	\dur, 8,
	\amp, 0.01,
	\legato, 1.5,

	\outBus, ~mainBus,
    \reverbBus, ~reverbBus,
    \chan, Pxrand((0..7), inf),
    \send, 1,
	\send2,1,
);

~subContraMayor = Pbind(
	\instrument, \subBass,
	\atk, 1.5,
	\rel, 4,
	\cur, 0.5,
	\lpf, Pwhite(100,400),

	\scale, Scale.major,
	\root, 5,
	\octave, 3,
	\degree, Pseq(~alturasContraMayor, inf),
	\dur, 4,
	\amp, 0.4,
	\legato, 1.2,
	\pan, 0,
);

)

------------------------------------------------------------------------------

T H E   A C TU A L   P I E C E
//diria el buen ema


Pequeño indice: y notas:

- Ptpar() cuenta en BEATS

Dur tema 128
Vuelta 64

Dur mayor por vuelta 40
3 vueltas -- 120

---------------------------------
    A continuación, toditita
---------------------------------

t = TempoClock(50/60)
-----------------------------------------------------------
Por secciones pa su uso práctico en vivo
-----------------------------------------------------------

//////////////////////////////////////////

- TEMA UNO  ---- Inicia en el 64
(
~temaaAa = Ptpar([

	0, ~cantus.finDur(128),
	0, ~contra.finDur(128),

	//0, ~desmadre.finDur(128),
	64,  ~subContra.finDur(64),
	64, ~cantusLead.finDur(64),
	64, ~contraLead.finDur(64),

]).play(t);
)
~temaaAa.stop;


///////////////////////////////////////////////////////////////


 -- Tema Mayor  --- Parece que inicia en el 128
//Dur por vuelta -- 40 beats
(
~temaMayoor = Ptpar([


	0, ~cantusMayor.finDur(40),
	0, ~contraMayor.finDur(40),
	0, ~cantusMayorDIS.finDur(40),
	0, ~contraMayorDIS.finDur(40),
	0,~padMayor.finDur(40),


	40, ~cantusMayor2.finDur(5),

]).play(t);
)

Parte Livecoding;

~pajaritos.play(t);

~cantusMayor2.play(t);
~cantusMayor3.play(t);

~cantusMayor.play(t);
~contraMayor.play(t);
~cantusMayorDIS.play(t);
~contraMayorDIS.play(t);

~subContraMayor.play(t);
~padMayor.play(t);


/////////////////////

~pajaritos.stop;

~cantusMayor2.stop;
~cantusMayor3.stop;

~cantusMayor.stop;
~contraMayor.stop;
~cantusMayorDIS.stop;
~contraMayorDIS.stop;

~subContraMayor.stop;
~padMayor.stop;









