///////////
//Buffers//
///////////

(
a= Buffer.readChannel(s, "/Users/eugeniosanchezvergara/Desktop/supercollider/Blanca Varela _ Curriculum vitae.mp3", channels:[0]);

b= Buffer.read(s,"/Users/eugeniosanchezvergara/Desktop/supercollider/Blanca Varela _ Curriculum vitae.mp3")
)


/////////////
//SynthDefs//
/////////////

(

~output= 0;

SynthDef(\tgranular, {
	| freq1= 60, freq2= 65.0, att= 0.1, sus= 2, rel= 1, vel= 1, pos= 0.1, pan= 0, amp= 0.3, out= 0|
	var son, env;
	son = GrainBuf.ar(
		1,
		Impulse.ar({ExpRand(freq1, freq2)}!12),
		LFNoise1.kr(0.3!12).exprange(0.0002, 0.1),
		a,
		vel,
		pos,
		2,
		pan,
		-1,
		512,
	);
	son=Splay.ar(son);

	env= EnvGen.ar(Env.asr(att, sus, rel), 1, doneAction:2);

	son= son*env*amp;

	Out.ar(~output, son);

}).add;



SynthDef(\pops, {
	| tri=10, dur=0.005, amp=0.8, out=0 |
	var son;
	son=GrainBuf.ar(
		2,
		Impulse.ar(tri),
		dur,
		a,
		1,
		LFNoise1.ar(20).range(0,1),
		2,
		0,
		-1,
	);

	son= son*amp;

	Out.ar(~output, son);

}).add;



SynthDef(\sinusondiada, {
	|freq=440, att=0.05, sus= 0.75, rel= 2, gate= 1, amp= 0.5, mod = 100|
	var son, env;
	son= SinOsc.ar( freq +
		SinOsc.kr(freq, SinOsc.kr({Rand(0.2, 0.06)}, 0, {Rand(0.1, 2.0)}), {ExpRand(20, 200)}!6),
		{Rand(0.0,2pi)},
		SinOsc.kr({Rand(1/60, 3/60)}).range(0.2, 0.5));
	son= Splay.ar(son);
	env= EnvGen.ar(Env.asr(att, sus, rel), gate, doneAction:2);
	son= son*env*amp;

	Out.ar(~output, son);
}).add;



SynthDef(\formantes, {|freq 100, freq1, freq2, freq3, freq4, freq5, amp1, amp2, amp3, amp4, amp5, rq1, rq2, rq3, rq4, rq5, amp|
	var son;
	son= BPF.ar(LFSaw.ar(freq, 0, 1), [freq1, freq2, freq3, freq4, freq5], [rq1, rq2, rq3, rq4, rq5], [amp1, amp2, amp3, amp4, amp5]);

	Out.ar(~output, Pan2.ar(Mix.new(son*amp),Rand(-1.0, 1)));

}).add;



)


//////////
//Series//
//////////

~poema= "Digamos que ganaste la carrera y que el premio era otra carrera que no bebiste el vino de la victoria sino tu propia sal que jamás escuchaste vítores sino ladridos de perros y que tu propia sombra fue tu única y desleal competidora"

~poema.formantes
~poema.binario
~poema.ascii


(
~serie1 = [0, 1, -1, 2, -2, 3, -3,   4, -4, 5,    -1, 2, -5, 2, -3, 6, 5,    -6, 2,   7, 2, -7, -7, 6, -7, 2];

~serie2 = [8,  4, -4, 5,    5, -7,    -8, -7, 5, -2, 1, 3, 4,    5, -7, 2,    3, 6, -7, 2,    7, 2, -7, -7, 6, -7, 2];

~serie3 = [4, -4, 5,    -5, 3,    9, 5, 9, 1, -3, 6, 5,     5, -7,     -9, 1, -5, 3,      0, 5,    -6, 2,    -9, 1, 7, 6, 3, -7, 1, 2];

~serie4 = [-3, 1, -5, 3,    6, -4,    -8, -7, 3, -8, 1, 2,    -3, 2, -6];

~serie5 = [4, -4, 5,  10, 2, -2, 2, -3,  5, -3, 7, -4, 7, -10, 2, -3, 6, 5,     -9, 1, 6, 3, -7, 5, -3];

~serie6 = [-3, 1, -5, 3,    -6, 2, 0, -7, 1, 0, -3,     0, 5,    -8, 5, -7, -7, 3, -3];

~serie7 = [8,   4, -4, 5,  6,-4,    -3, 3, -2, 9, -7, 2,    6, -4,    -8, -7, 3, -8, 1, 2,   -3, 3, -2, 9, -7, 2];

~serie8 = [11, -4, 5,   6,-4,  -4, -5, 1, 7, 2];

~serie9 = [8,     0, 5, -3, -6, 5, 2, -6,     7, 3, -2, -8, 5, 6, 1, 0, 3, -7, 2];
)

//////////
//Pbinds//
//////////

(


~textgranular = Pmono(
	\tgranular,
	\dur, Pseq ([8, 4], inf),
	\freq1, Pseq((50.0..64), inf, 3, Pwhite(0.1, 2.5, inf)),
	\freq2, Pseq((75.0..65), inf, 3, Pwhite(0.1, 2.5, inf)),
	\amp, 0.6,
	\pos, 0.1
);



~textgranular2 = Pmono(
	\tgranular,
	\dur, 0.1,
	\freq1, Pseq((50.0..64), inf, 3, Pwhite(0.1, 2.5, inf)),
	\freq2, Pseq((75.0..65), inf, 3, Pwhite(0.1, 2.5, inf)),
	\amp, 0.4,
	\pos, Pseg(Array.rand(10, 0, 1.0), Array.rand(9, 1, 2.0), 'lin', inf),
	\vel, Prand([1, 0.5, 0.75], inf)
);



~pops = Pmono(
	\pops,
	\dur, 0.005,
	\tri, 10,
	\amp, 1.2
);




~pops2 = Pmono(
	\pops,
	\dur, Pexprand (0.005, 0.1),
	\tri, Pslide([5.0, 30, 5], inf, 4, 1),
	\amp, 1.4
);



~seriesseguidas= Pbind(
	\instrument, \sinusondiada,
	\degree, Pseq([
		Pseq(~serie1, 1),
		Pseq(~serie2, 1),
		Pseq(~serie3, 1),
		Pseq(~serie4, 1),
		Pseq(~serie5, 1),
		Pseq(~serie6, 1),
		Pseq(~serie7, 1),
		Pseq(~serie8, 1),
		Pseq(~serie9, 1),
	]
	),
	\scale, Pdup(10, Pseq([Scale.phrygian, Scale.chromatic, Scale.dorian], inf)),
	\dur, Pwrand([1/2, 1/3, 1/6, 1/16, 1/32, Rest(1/4), Rest(1/16)], [0.1, 0.1, 0.2, 0.15, 0.15, 0.15, 0.15], inf)
);


~seriesrandom= Pbind(
	\instrument, \sinusondiada,
	\degree, Pxrand([
		Pseq(~serie1, 1),
		Pseq(~serie2, 1),
		Pseq(~serie3, 1),
		Pseq(~serie4, 1),
		Pseq(~serie5, 1),
		Pseq(~serie6, 1),
		Pseq(~serie7, 1),
		Pseq(~serie8, 1),
		Pseq(~serie9, 1),
	], 9
	),
	\scale, Scale.chromatic,
	\dur, Pwrand([1/2, 1/3, 1/6, 1/16, 1/32, Rest(1/4), Rest(1/16)], [0.1, 0.1, 0.2, 0.15, 0.15, 0.15, 0.15], inf)
);



~codigoquehabla= Pmono(\formantes,
	\dur, 0.1,
	\midinote, Pseq(~poema.ascii-64, 2),

	\freq1, Pseq(~poema.formantesf("soprano")[0],inf),
	\freq2, Pseq(~poema.formantesf("soprano")[1],inf),
	\freq3, Pseq(~poema.formantesf("soprano")[2],inf),
	\freq4, Pseq(~poema.formantesf("soprano")[3],inf),
	\freq5, Pseq(~poema.formantesf("soprano")[4],inf),

	\amp1, Pseq(~poema.formantesa("soprano")[0],inf),
	\amp2, Pseq(~poema.formantesa("soprano")[1],inf),
	\amp3, Pseq(~poema.formantesa("soprano")[2],inf),
	\amp4, Pseq(~poema.formantesa("soprano")[3],inf),
	\amp5, Pseq(~poema.formantesa("soprano")[4],inf),

	\rq1, Pseq(~poema.formantesr("soprano")[0],inf),
	\rq2, Pseq(~poema.formantesr("soprano")[1],inf),
	\rq3, Pseq(~poema.formantesr("soprano")[2],inf),
	\rq4, Pseq(~poema.formantesr("soprano")[3],inf),
	\rq5, Pseq(~poema.formantesr("soprano")[4],inf),

	\amp, Pseq(~poema.binario/2, 1)
);

~codigoquehabla2= Pmono(\formantes,
	\dur, 0.05,
	\midinote, Pseq(~poema.ascii-35, inf),

	\freq1, Pseq(~poema.formantesf("alto")[0],inf),
	\freq2, Pseq(~poema.formantesf("alto")[1],inf),
	\freq3, Pseq(~poema.formantesf("alto")[2],inf),
	\freq4, Pseq(~poema.formantesf("alto")[3],inf),
	\freq5, Pseq(~poema.formantesf("alto")[4],inf),

	\amp1, Pseq(~poema.formantesa("alto")[0],inf),
	\amp2, Pseq(~poema.formantesa("alto")[1],inf),
	\amp3, Pseq(~poema.formantesa("alto")[2],inf),
	\amp4, Pseq(~poema.formantesa("alto")[3],inf),
	\amp5, Pseq(~poema.formantesa("alto")[4],inf),

	\rq1, Pseq(~poema.formantesr("alto")[0],inf),
	\rq2, Pseq(~poema.formantesr("alto")[1],inf),
	\rq3, Pseq(~poema.formantesr("alto")[2],inf),
	\rq4, Pseq(~poema.formantesr("alto")[3],inf),
	\rq5, Pseq(~poema.formantesr("alto")[4],inf),

	\amp, Pseq(~poema.binario/2, 1)
);

~codigoquehabla3= Pmono(\formantes,
	\dur, 1/3,
	\midinote, Pseq(~poema.ascii-48, 1),

	\freq1, Pseq(~poema.formantesf("tenor")[0],inf),
	\freq2, Pseq(~poema.formantesf("tenor")[1],inf),
	\freq3, Pseq(~poema.formantesf("tenor")[2],inf),
	\freq4, Pseq(~poema.formantesf("tenor")[3],inf),
	\freq5, Pseq(~poema.formantesf("tenor")[4],inf),

	\amp1, Pseq(~poema.formantesa("tenor")[0],inf),
	\amp2, Pseq(~poema.formantesa("tenor")[1],inf),
	\amp3, Pseq(~poema.formantesa("tenor")[2],inf),
	\amp4, Pseq(~poema.formantesa("tenor")[3],inf),
	\amp5, Pseq(~poema.formantesa("tenor")[4],inf),

	\rq1, Pseq(~poema.formantesr("tenor")[0],inf),
	\rq2, Pseq(~poema.formantesr("tenor")[1],inf),
	\rq3, Pseq(~poema.formantesr("tenor")[2],inf),
	\rq4, Pseq(~poema.formantesr("tenor")[3],inf),
	\rq5, Pseq(~poema.formantesr("tenor")[4],inf),

	\amp, Pseq(~poema.binario/2, 1)
);


)



//////////
//Rutina//
//////////


(
w= (
r{
	~tex1= ~textgranular.play;
	32.0.wait;
	~pop1= ~pops.play;
	32.wait;
	~seriesseguidas.play;
	32.wait;
	~seriesrandom.play;
	32.wait;
	~tex2= ~textgranular2.play;
	~pop2= ~pops2.play;
	~codigoquehabla.play;
	~codigoquehabla3.play;
	16.wait;
	~cod2= ~codigoquehabla2.play;
	48.wait;
	~cod2.stop;
	~tex2.stop;
	12.wait;
	b.play;
	20.wait;
	~pop1.stop;
	~pop2.stop;
	16.wait;
	~tex1.stop;
	10.wait;
}
)
)


w.play

