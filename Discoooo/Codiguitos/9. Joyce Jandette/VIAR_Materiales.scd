
Buffer.freeAll;
s.options.memSize = 524288;  // 512 MB
s.reboot;
s.makeGui;

(
~altavoces = 2;
~output= 0;

~roomRuta = thisProcess.nowExecutingPath.dirname;

~iterRuta = ~roomRuta ++ "/iasi/";
~iters = PathName(~iterRuta)
.files
.select { |f| f.extension.asString.toLower == "wav" }
.collect { |f| Buffer.read(s, f.fullPath) };

~iasis = ~iters.drop(14).collect(_.bufnum);

~vocesRuta = ~roomRuta ++ "/voces/";
~loadFolder = { |ubi|PathName(ubi)
	.files
	.select { |f| f.extension.asString.toLower == "wav" }
	.collect { |f| Buffer.read(s, f.fullPath) };
};
~bufs_intro = ~loadFolder.(~vocesRuta ++ "1. Intro/");
~bufs_desarrollo = ~loadFolder.(~vocesRuta ++ "2. Desarrollo/");
~bufs_final = ~loadFolder.(~vocesRuta ++ "3. Final/");
~chooseBuf = { |bufArray| bufArray.choose };

// SynthDefs

SynthDef(\iasispace, { |buf, amp 1, rate 1, gate 1, atk 1, rel 4, inicio 0, revers 1 |
	var src, env, bands, amps, pans, sig;
	env = EnvGen.kr(Env.asr(atk, 1, rel), gate, doneAction: 2);
	src = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate * revers, 1, inicio * BufFrames.kr(buf), loop: 1);
	bands = [LPF.ar(src, 200),BPF.ar(src, 500, 0.6),BPF.ar(src, 1200, 0.5),BPF.ar(src, 2800, 0.6),HPF.ar(src, 5000)];
	amps = bands.collect { |b| Amplitude.kr(b, 0.03, 0.2).lag(0.5)};
	pans = [SinOsc.kr(0.005 + amps[0] * 0.01), SinOsc.kr(0.02  + amps[1] * 0.04),
		SinOsc.kr(0.06  + amps[2] * 0.12), LFNoise1.kr(0.25 + amps[3] * 0.6), LFNoise2.kr(0.9  + amps[4] * 2)];
	sig = bands.collect { |b, i| PanAz.ar(~altavoces, b, pans[i], 1 / bands.size)}.sum;
	Out.ar(~output, sig * env * amp);
}).add;

SynthDef(\pulsoBuf, {
	|buf, amp=0.5, atk=0.01, rel=0.8, filtFreq=1000, filterQ=0.5, pan=0, metal=0.27, body=0.2, width=0.25|
	var src, base, bajo, aire, env, metalRes, cRes, sig;
	src = PlayBuf.ar(1, buf, BufRateScale.kr(buf), 1, Rand(0, BufFrames.kr(buf) * 0.95), doneAction: 2);
	base = BPF.ar(src, filtFreq, filterQ) * (1 / filterQ.sqrt);
	bajo = LPF.ar(src, filtFreq * 0.4);
	aire = HPF.ar(src, filtFreq * 3.5);
	cRes = Resonz.ar(base, filtFreq * 0.5, 0.18);
	metalRes = Mix([Resonz.ar(base, filtFreq * 1.5, 0.1), Resonz.ar(base, filtFreq * 2.8, 0.07),
		Resonz.ar(base, filtFreq * 4.2, 0.05)]);
	sig = base + (bajo * 0.3) + (cRes * body) + (metalRes * metal) + (aire * 0.25);
	sig = (sig * 1.4).tanh * 0.6;
	env = EnvGen.kr(Env.perc(atk, rel), doneAction: 2);
	sig = sig * env;
	sig = Limiter.ar(sig, 0.9, 0.007);
	Out.ar(~output, PanAz.ar(~altavoces, sig, pan, width) * amp);
}).add;

SynthDef(\gestos, {
	| buf, amp 0.3, rate 1, rev 1, dens 20, grainDur 0.08, posVel 0.3, panVel 2, atk 0.002, rel 0.05|
	var trig, pos, sig, pan, env, sus;
	trig = Dust.ar(dens);
	pos = LFNoise2.ar(posVel).range(0, BufDur.kr(buf));
	sig = GrainBuf.ar(1, trig, grainDur, buf, rate * rev, pos, interp: 4);
	pan = LFNoise1.kr(panVel).range(0, 1.999);
	sus = dens.linexp(4, 60, 1, 0.08);
	env = EnvGen.kr(Env.linen(atk, sus, rel),doneAction: 2);
	Out.ar(~output, PanAz.ar(~altavoces, sig * env * amp, pan, width: 0.25));
}).add;

SynthDef(\vozTG, {
	|buf, inicio 0, rate 1, loop 0, gate 1, amp 1, atk 1, rel 4, sus 10, pan 0,
	grainDur 0.15, dens=5, posRate=0.15, decay=6, pitchShift=1.0,
	resoMix=0.6, panVel 0.05 |
	var voz, grains, reso, mix, env, tono, trig, bufPos, panPos, freqs, delays;
	voz = PlayBuf.ar(1, buf, rate * pitchShift, startPos: inicio * BufFrames.kr(buf), loop: loop);
	voz = BPF.ar(voz, 1000, 0.8);
	tono = Pitch.kr(voz, 60, 800, 12).lag(0.3) * pitchShift;
	tono = tono.clip(80, 600);
	freqs = tono * [1, 1.5, 2];
	freqs = freqs.clip(120, 1200);
	delays = freqs.reciprocal;
	trig = Impulse.kr(dens);
	bufPos = LFDNoise3.kr(posRate).range(0, BufDur.kr(buf));
	grains = TGrains.ar(1, trig, buf, rate * pitchShift, bufPos, grainDur, 0, 0.5);
	reso = Mix(CombC.ar(grains * 0.6,0.5,delays,decay));
	mix = grains + (reso * resoMix);
	mix = LeakDC.ar(Limiter.ar(mix, 0.8));
	env = EnvGen.kr(Env.linen(atk, sus, rel), gate, doneAction: 2);
	panPos = LFNoise2.kr(panVel).range(0, 1.999);
	Out.ar(~output, PanAz.ar(~altavoces, mix * env * amp, panPos));
}).add;

//PATRONES
// Patron iasi espacializado
Pdef(\iasi,
	Pbind(
		\instrument, \iasispace,
		\buf, Pfunc { ~iasis.choose },
		\rate, Pwrand([1, 0.5, 0.33], [0.5, 0.4, 0.1], inf),
		\revers, Pwrand([1, -1],[0.95, 0.05], inf),
		\inicio, Pwhite(0.0, 0.9),
		\amp, 0.95 * Pfunc { ~ampiasi },
		\rel, 10,
		\atk, 5,
		\dur, Pwhite(5, 20),
		\sustain, Pkey(\dur) * 1.5,
	)
);

//Patron ritmicos
// Gong
~gong_base = Pbind(
	\instrument, \pulsoBuf,
	\buf, Pfunc { ~iters.copyRange(20, 27).choose.bufnum },
	\dur, Pseq([4, 4, 6, 2], inf) * Pfunc { ~tempo },
    \filtFreq, Pwhite(180, 350),
	\filterQ, Pseg(Pseq([0.8, 0.25, 0.4], inf), Pwhite(0.05, 0.2)),
	\rel, Pwhite(2, 3),
	\amp, Pfunc { 0.9 * ~ampritmo },
	\width, Pwhite(0.7, 0.9),
	\pan, Pseg(Pwhite(-0.8, 0.8), Pwhite(12, 24), \sine)
);

// Grave
~graves_base = Pbind(
	\instrument, \pulsoBuf,
	\buf, Pfunc { ~iters.copyRange(15, 25).choose.bufnum },
	\dur, Prand([3, 4, 6], inf) * Pfunc { ~tempo },
	\filtFreq, Pwhite(200, 600),
	\filterQ, 0.3,
    \rel, Pwhite(1, 2),
	\amp, Pfunc { 0.8 * ~ampritmo },
	\width, Pwhite(0.6, 0.8),
	\pan, Pseg(Pwhite(-1.0, 1.0), Pwhite(8, 16), \sine)
);

// Medio
~pulso_base = Pbind(
	\instrument, \pulsoBuf,
	\buf, Pfunc { ~iters.copyRange(10, 20).choose.bufnum },
    \dur, Pwrand([
		Pseq([1, 1, 1], 1),
		Pseq([1.5, 1.5], 1),
		Pseq([0.75, 0.75, 1.5], 1)
    ], [0.5, 0.3, 0.2], inf) * Pfunc { ~tempo },
	\filtFreq, Pwhite(400, 1000),
	\filterQ, 0.4,
	\rel, Pwhite(0.4, 0.8),
	\amp, Pbjorklund2(3, 8) * Pfunc { 0.8 * ~ampritmo },
	\width, Pwhite(0.6, 0.8),
	\pan, Pseg(Pwhite(-0.6, 0.6), Pwhite(1.5, 4), \sine)
);

// Rápido
~rapido_base = Pbind(
	\instrument, \pulsoBuf,
	\buf, Pfunc { ~iters.copyRange(17, 23).choose.bufnum },
	\dur, Pseq([0.5, 0.25, 0.25, 0.5, 0.25, 0.25, 0.5, 0.25, 0.5, 0.25, 0.5], inf) * Pfunc { ~tempo },
    \filtFreq, Pwhite(1000, 2500),
	\filterQ, 0.6,
    \rel, Pwhite(0.1, 0.2),
	\amp, Pbjorklund2(7, 11) * Pfunc { 0.65 * ~ampritmo },
	\width, Pwhite(0.4, 0.6),
	\pan, Pwhite(-0.8, 0.8)
);

// Sincopado
~sincopado_base = Pbind(
	\instrument, \pulsoBuf,
	\buf, Pfunc { ~iters.copyRange(15, 20).choose.bufnum },
	\dur, Pseq([Rest(0.5), 0.5, 0.25, Rest(0.25), 0.5, Rest(0.75), 0.25, 0.5, Rest(0.5)], inf) * Pfunc { ~tempo },
	\filtFreq, Pwhite(600, 1200),
	\filterQ, 0.5,
	\rel, 0.15,
	\amp, Pfunc { 0.55 * ~ampritmo },
	\width, 0.3,
	\pan, Pwhite(-0.7, 0.7)
);

// Euclidiano
~euclidiano_base = Pbind(
	\instrument, \pulsoBuf,
	\buf, Pfunc { ~iters.copyRange(15, 20).choose.bufnum },
	\dur, Pfunc { (1/8) * ~tempo },
	\filtFreq, 800,
	\filterQ, Prand([0.5, 0.9], inf),
	\rel, 0.2,
	\amp, Pbjorklund2(5, 13) * Pfunc { 0.7 * ~ampritmo },
	\width, 0.35,
	\pan, Pseg(Pwhite(-0.7, 0.7), Pwhite(0.8, 2), \sine)
);

// Pentatónico
~penta_base = Pbind(
	\instrument, \pulsoBuf,
	\buf, Pfunc { ~iters.copyRange(15, 25).choose.bufnum },
	\dur, Pseq([0.5, 0.25, Rest(0.25), 0.5, 0.25, 0.25, 0.5, Rest(0.5), 0.25, 0.25, 0.25, 0.25, Rest(1)], inf) * Pfunc { ~tempo },
	\filtFreq, Pseq([880, 1100, 1320, 1760, 1980, 1760, 1320, 1100, 880], inf),
	\filterQ, 0.6,
	\rel, 0.3,
	\amp, Pfunc { 0.5 * ~ampritmo },
	\width, 0.5,
	\pan, Pseg(Pwhite(-0.5, 0.5), Pwhite(2, 5), \sine)
);

// Disperso
~disperso_base = Pbind(
	\instrument, \pulsoBuf,
    \buf, Pfunc { ~iters.copyRange(18, 27).choose.bufnum },
	//\dur, Pbjorklund2(3, 17) * Pwhite(0.3, 0.8) * Pfunc { ~tempo },
	\dur, Pbjorklund2(3, 17).linlin(0, 1, 0.15, 1.0) * Pwhite(0.3, 0.8) * Pfunc { ~tempo },
	\filtFreq, Pwhite(2000, 4000),
	\filterQ, 0.8,
	\rel, Pwhite(0.05, 0.15),
	\amp, Pwhite(0.3, 0.7) * Pfunc { ~ampritmo },
	\width, 0.15,
	\pan, Pwhite(-1, 1)
);

// Secuencia
~secuencia_base = Pbind(
	\instrument, \pulsoBuf,
	\buf, Pfunc { ~iters.copyRange(20, 27).choose.bufnum },
	\dur, Pseq([2, 2, 2, 3, 2, 2, 3, 2, 3, 2, 2, 2, 2, 3, 2, 2], inf) * Pfunc { (1/8) * ~tempo },
	\filtFreq, Pwhite(500, 1200),
    \filterQ, 0.5,
    \rel, 0.25,
    \amp, Pseq([0.4, 0.4, 0.4, 0.8, 0.4, 0.4, 0.8, 0.4, 0.8, 0.4, 0.4, 0.4, 0.4, 0.8, 0.4, 0.4], inf)
	* Pfunc { ~ampritmo },
	\width, 0.4,
    \pan, Pseg(Pseq([-0.5, 0.5], inf), Pseq([4, 4], inf), \sine)
);

// variaciones
Pdef(\gong_normal, ~gong_base);
Pdef(\gong_acentuado,
    Pbindf(~gong_base,
        \amp, Pseq([1.2, 0.5, 0.9, 0.6], inf) * Pfunc { 0.9 * ~ampritmo },
        \filterQ, Pwhite(0.2, 0.4)
    )
);

Pdef(\gong_crescendo,
    Pbindf(~gong_base,
        \amp, Pseries(0.3, 0.15, 8).repeat * Pfunc { 0.9 * ~ampritmo },
        \rel, Pwhite(2.5, 4)
    )
);

// Grave
Pdef(\graves_normal, ~graves_base);
Pdef(\graves_panrapido,
    Pbindf(~graves_base,
        \pan, Pstep(Pwhite(-1,1), Pwhite(0.2,1.0)),
        \filterQ, Pwhite(0.2, 0.6)
    )
);

Pdef(\graves_pulso,
    Pbindf(~graves_base,
        \amp, Pseq([1.0, 0.3, 0.7, 0.3], inf) * Pfunc { 0.8 * ~ampritmo },
        \dur, Pseq([3, 3, 3, 3], inf) * Pfunc { ~tempo }
    )
);

// Pulso
Pdef(\pulso_normal, ~pulso_base);
Pdef(\pulso_intenso,
    Pbindf(~pulso_base,
        \amp, Pbjorklund2(5, 8) * Pfunc { 1.2 * ~ampritmo },
        \filtFreq, Pwhite(300, 800),
        \filterQ, Pwhite(0.3, 0.7)
    )
);

Pdef(\pulso_suave,
    Pbindf(~pulso_base,
        \amp, Pseq([0.3, 0.4, 0.35, 0.3, 0.45, 0.3, 0.4, 0.35], inf) * Pfunc { 0.8 * ~ampritmo },
        \pan, Pwhite(-0.5, 0.5)
    )
);

// Rápido
Pdef(\rapido_normal, ~rapido_base);
Pdef(\rapido_explosivo,
    Pbindf(~rapido_base,
        \amp, Pseq([
            Pbjorklund2(7, 11) * 0.9,
            Pbjorklund2(7, 11) * 0.4,
            Pbjorklund2(7, 11) * 0.7,
            Pbjorklund2(7, 11) * 0.3
        ], inf) * Pfunc { 0.65 * ~ampritmo },
        \filterQ, Pwhite(0.5, 0.9)
    )
);

Pdef(\rapido_brillante,
    Pbindf(~rapido_base,
        \filtFreq, Pwhite(1500, 3500),
        \pan, Pseg(Pwhite(-0.8, 0.8), Pwhite(0.03, 0.12), \sine),
        \rel, Pwhite(0.05, 0.15)
    )
);

// Sincopado
Pdef(\sincopado_normal, ~sincopado_base);
Pdef(\sincopado_marcado,
    Pbindf(~sincopado_base,
        \amp, Pseq([0.8, 0.3, 0.6, 0.3, 0.7, 0.3, 0.5, 0.3, 0.6], inf) * Pfunc { 0.55 * ~ampritmo },
        \filtFreq, Pwhite(500, 1000)
    )
);

// Euclidiano
Pdef(\euclidiano_normal, ~euclidiano_base);
Pdef(\euclidiano_caotico,
    Pbindf(~euclidiano_base,
        \amp, Pbjorklund2(5, 13) * Pwhite(0.4, 1.0) * Pfunc { 0.7 * ~ampritmo },
        \filtFreq, Pwhite(600, 1200),
        \filterQ, Pwhite(0.3, 0.95)
    )
);

// Pentatónico
Pdef(\penta_normal, ~penta_base);
Pdef(\penta_melodico,
    Pbindf(~penta_base,
        \amp, Pseq([0.7, 0.5, 0.6, 0.8, 0.9, 0.8, 0.6, 0.5, 0.7], inf) * Pfunc { 0.5 * ~ampritmo },
        \rel, Pwhite(0.2, 0.5)
    )
);

// Disperso
Pdef(\disperso_normal, ~disperso_base);
Pdef(\disperso_brillante,
    Pbindf(~disperso_base,
        \filtFreq, Pwhite(2500, 5000),
        \amp, Pwhite(0.2, 0.5) * Pfunc { ~ampritmo },
        \pan, Pstep(Pwhite(-1.0, 1.0), Pexprand(0.04, 0.12))
    )
);

// Secuencia
Pdef(\secuencia_normal, ~secuencia_base);
Pdef(\secuencia_acentuado,
    Pbindf(~secuencia_base,
        \amp, Pseq([0.6, 0.3, 0.3, 1.0, 0.6, 0.3, 1.0, 0.3, 1.0, 0.6, 0.3, 0.3, 0.6, 1.0, 0.3, 0.3], inf) * Pfunc { ~ampritmo },  // Acentos en 3s
        \filterQ, Pwhite(0.4, 0.8)
    )
);

// Ppars
// ritmo base
Pdef(\ritmo_base, Ppar([
    Pdef(\gong_normal),
    Pdef(\graves_normal)
]));

// variación 1
Pdef(\ritmo_base_v1, Ppar([
    Pdef(\gong_acentuado),
    Pdef(\graves_panrapido)
]));

// variación 2
Pdef(\ritmo_base_v2, Ppar([
    Pdef(\gong_crescendo),
    Pdef(\graves_pulso)
]));

// ritmo medio
Pdef(\ritmo_medio, Ppar([
    Pdef(\pulso_normal),
    Pdef(\rapido_normal),
    Pdef(\sincopado_normal)
]));

// variación 1
Pdef(\ritmo_medio_v1, Ppar([
    Pdef(\pulso_intenso),
    Pdef(\rapido_explosivo)
]));

// variación 2
Pdef(\ritmo_medio_v2, Ppar([
    Pdef(\pulso_suave),
    Pdef(\rapido_brillante),
    Pdef(\sincopado_marcado)
]));

// ritmo denso
Pdef(\ritmo_denso, Ppar([
    Pdef(\euclidiano_normal),
    Pdef(\penta_normal),
    Pdef(\disperso_normal),
    Pdef(\secuencia_normal)
]));

// variación 1
Pdef(\ritmo_denso_v1, Ppar([
    Pdef(\euclidiano_caotico),
    Pdef(\penta_melodico),
    Pdef(\secuencia_acentuado)
]));

// variación 1
Pdef(\ritmo_denso_v2, Ppar([
	~euclidiano_base,
	Pbindf(~penta_base, \amp, Pseq([0.7,0.5,0.6],inf) * Pfunc { ~ampritmo }),
	Pbindf(~disperso_base, \filtFreq, Pwhite(2500, 5000))
])
);

//Patron gestos vocales
~gestosBase = Pbind(
	\instrument, \gestos,
	\dur, 0.5,
	\grainDur, 0.1,
	\dens, 20,
	\rate, 1,
	\posVel, 0.2,
	\panVel, 2,
	\atk, 0.002,
	\rel, 0.05,
	\amp, 0.5
);

Pdef(\gestos_I,
	Pbind(
		\instrument, \gestos,
		\buf, Pfunc { ~bufs_intro.choose },
		\grainDur, Prand([Pwhite(0.005, 0.03), Pwhite(0.08, 0.2)], inf),
		\dens, Pseg(Pseq([20, 120, 40, 180], inf), Pwhite(4, 10),\exp),
		\dur, Pwrand([Pwhite(0.05, 0.25), 1.25], [0.5, 0.5],inf),
		\rate, Pwhite(0.8, 1.15),
		\posVel, Pwhite(0.05, 0.6),
		\panVel, Pwhite(0.6, 1.8),
		\atk, Pwhite(0.001, 0.006),
		\rel, Pwhite(0.15, 0.6),
		\amp, Pwrand([0, Pwhite(0.15, 0.9)], [0.65, 0.35], inf) * Pfunc { ~ampvoz }
	)
);

Pdef(\gestos_II,
	Pbindf(~gestosBase,
		\buf, Pfunc { ~bufs_desarrollo.choose.bufnum },
		\grainDur, Pwrand([Pwhite(0.4, 0.8), Pwhite(2.1, 3.2)], [0.25, 0.75], inf),
		\dens, Pseg(Pseq([4, 10, 2, 14], inf), Pwhite(5, 12)),
		\dur, Pwrand([0.25, 0.45, 1.1],[0.3, 0.5, 0.2],inf),
		\posVel, Pwhite(0.1, 0.6),
		\panVel, Pwhite(0.2, 0.5),
		\rate, Pwhite(0.92, 1.06),
		\atk, 0.004,
		\rel, Pwhite(0.5, 1.1),
		\amp, Pseg(Pseq([0.4, 0.95, 0.7], inf), Pwhite(6, 14)) * Pfunc { ~ampvoz }
	)
);

Pdef(\gestos_III,
	Pbindf(~gestosBase,
		\buf, Pfunc { ~bufs_final.choose.bufnum },
		\grainDur, Pwrand([Pwhite(0.8, 2.6), Pwhite(5.0, 8.2)], [0.15, 0.85], inf),
		\dens, Pseg(Pseq([1.5, 3, 2, 4], inf), Pwhite(6, 14)),
		\dur, Pwrand([1.2, 2.4, 4.0], [0.4, 0.4, 0.2], inf),
		\posVel, Pwhite(0.01, 0.06),
		\panVel, Pwhite(0.02, 0.18),
		\rate, Pwhite(0.97, 1.03),
		\atk, 0.025,
		\rel, Pwhite(2.0, 5.0),
		\amp, Pseg(Pseq([0.7, 1.0, 0.85], inf), Pwhite(8, 16)) * Pfunc { ~ampvoz }
	)
);

//Patrones reso
// Patrón base
~resoBase = Pbind(
	\instrument, \vozTG,
    \buf, Pfunc { ~iters.copyRange(17, 27).choose.bufnum },
	\loop, 0,
	\bufPos, Pwhite(0.1, 0.9, inf),
	\atk, Pwhite(0.1, 0.8),
	\rel, 6,
	\panVel, Pdup(16, Pwhite(0.03, 0.12))
);

//  simple
Pdef(\reso_base,
	Pbindf(~resoBase,
        \dur, Pseq([8, 6, 10, 8], inf),
		\sus, Pkey(\dur) * 1.5,
		\grainDur, 0.4,
		\dens, 4,
        \posRate, 0.03,
		\resoMix, 0.4,
		\decay, 4,
		\rate, 1,
		\pitchShift, 1.0,
		\panVel, 0.05,
        \amp, Pseq([0.5, 0.4, 0.6, 0.45], inf) * Pfunc { ~ampreso },
	)
);

// medio
Pdef(\reso_medio,
    Pbindf(~resoBase,
		\dur, Prand([4, 6, 3, 8, 5], inf),
		\sus, Pkey(\dur) * Pwhite(1.8, 3.0),
        \grainDur, Prand([0.15, 0.25, 0.4], inf),
		\dens, Pwhite(6, 9),
        \posRate, Prand([0.08, 0.15, 0.3], inf),
		\resoMix, Pwhite(0.5, 0.7),
		\decay, Prand([4, 6, 8], inf),
		\rate, Pwrand([1, 0.5], [0.8, 0.2], inf),
		\pitchShift, Pkey(\rate) * Pwhite(0.998, 1.002),
        \amp, Pbjorklund2(5, 8, inf) * Pfunc { 0.5 * ~ampreso },
		\atk, Pwhite(0.3, 0.8),
        \rel, Pwhite(5, 8),
		\panVel, Pdup(12, Pwhite(0.08, 0.25)),
    )
);

// denso
Pdef(\reso_denso,
	Pbindf(~resoBase,
        \dur, Prand([2, 3, 1.5, 4, 2.5], inf),
		\sus, Pkey(\dur) * Pwhite(2.5, 4.5),
		\grainDur, Pwrand([0.08, 0.15, 0.25], [0.5, 0.3, 0.2], inf),
		\dens, Pwhite(8, 12),
        \posRate, Pwrand([0.15, 0.4, 0.8], [0.3, 0.5, 0.2], inf),
		\resoMix, Pwhite(0.6, 0.85),
        \decay, Pwhite(6, 12),
		\rate, Pwrand([1, 0.5, 2], [0.6, 0.3, 0.1], inf),
		\pitchShift, Pkey(\rate) * Pwrand([
			Pwhite(0.995, 1.005),
			Pwhite(0.98, 1.02)
		], [0.7, 0.3], inf),
        \amp, (Pbjorklund2(7, 11, inf) * Pwhite(0.3, 0.5)) * Pfunc { ~ampreso },
		\atk, Pwhite(0.1, 0.5),
		\rel, Pwhite(4, 7),
		\panVel, Pdup(20, Pwhite(0.15, 0.45)),
	)
);

// grave
Pdef(\reso_grave,
	Pbindf(~resoBase,
		\dur, Pseq([10, 8, 12, 9], inf),
		\sus, Pkey(\dur) * 2,
		\grainDur, Pwhite(0.5, 1.0),
		\dens, Pwhite(3, 5),
		\posRate, 0.02,
		\resoMix, Pwhite(0.7, 0.9),
		\decay, Pwhite(10, 16),
		\rate, Pwrand([0.5, 0.25], [0.8, 0.2], inf),
		\pitchShift, Pkey(\rate) * Pwhite(0.99, 1.01),
		\amp, Pfunc { 0.85 * ~ampreso },
		\atk, Pwhite(1, 2),
		\rel, Pwhite(8, 12),
		\panVel, 0.02,
	)
);

// agudo
Pdef(\reso_agudo,
	Pbindf(~resoBase,
		\dur, Pwhite(2, 5),
		\sus, Pkey(\dur) * Pwhite(1, 2),
		\grainDur, Pwhite(0.05, 0.12),
		\dens, Pwhite(10, 15),
		\posRate, Pwhite(0.3, 0.8),
		\resoMix, Pwhite(0.2, 0.4),
		\decay, Pwhite(2, 4),
		\rate, Pwrand([1, 1.5], [0.7, 0.3], inf),
		\pitchShift, Pkey(\rate) * Pwhite(1.0, 1.05),
		\amp, Pwhite(0.4, 0.6) * Pfunc { ~ampreso },
		\atk, Pwhite(0.05, 0.2),
		\rel, Pwhite(2, 4),
		\panVel, Pdup(8, Pwhite(0.4, 0.9)),
	)
);

//fragmentado
Pdef(\reso_fragmentado,
	Pbindf(~resoBase,
		\dur, Pwrand([
			Pseq([0.5, 0.3, Rest(1), 0.8], 1),
			Pseq([2, Rest(2), 1], 1),
			Pseq([0.2, 0.2, 0.3, Rest(3)], 1)
		], [0.4, 0.3, 0.3], inf),
		\sus, Pkey(\dur) * 0.8,
		\grainDur, Pwrand([0.08, 0.3, 0.8], [0.5, 0.3, 0.2], inf),
		\dens, Pwhite(5, 12),
		\posRate, Pwrand([0.05, 0.5, 1.2], [0.3, 0.5, 0.2], inf),
		\resoMix, Pwhite(0.3, 0.8),
        \decay, Pwhite(3, 10),
		\rate, Pwrand([0.5, 1, 1.5, 0.25], [0.2, 0.3, 0.4, 0.1], inf),
		\pitchShift, Pkey(\rate) * Pwhite(0.97, 1.03),
		\amp,Pseg(Pseq([0.0, 1.0, 0.3, 0.9, 0.05], inf),Pwhite(6, 18), \sin) * Pwhite(0.5, 1.0) * Pfunc { ~ampreso },
		\atk, Pwhite(0.01, 0.3),
		\rel, Pwhite(5, 10),
		\panVel, Pdup(6, Pwhite(0.3, 1.2)),
	)
);

// completo (final)
Pdef(\reso_total,
	Pbindf(~resoBase,
		\dur, Pdup(12, Prand([2, 4, 6, 8, 12], inf)),
		\sus, Pkey(\dur) * Pwhite(1, 4.0),
		\grainDur, Pdup(8, Pseq([0.08, 0.15, 0.4], inf)),
		\posRate, Pdup(8, Pseq([0.03, 0.6, 0.01], inf)),
		\dens, Pdup(8, Pseq([7, 8, 4], inf)),
		\resoMix, Prand([0.4, 0.6, 0.8], inf),
		\bufPos, Pwhite(0.1, 0.9, inf),
		\decay, Prand([2, 4, 8, 6, 12], inf),
		\rate, Pdup(6, Prand([1, 0.5], inf)),
		\pitchShift, Pkey(\rate) * Pwrand([Pwhite(0.998, 1.002, inf), 1], [0.8, 0.2], inf),
		\amp, Pbjorklund2(5, 8, inf, 0) * Pfunc { 0.8 * ~ampreso },
		\rel, Pwhite(4, 8),
		\panVel, Pdup(24, Pwhite(0.08, 0.35))
		//\gate, Pwrand([1, 0], [0.75, 0.25], inf),
	)
);
)



// Para pruebas:
~tempo = 1;
~ampiasi = 2.6;
~ampritmo = 1.8;
~ampvoz = 1.5;
~ampreso = 1;

Pdef(\iasi).play;
Pdef(\iasi).stop;

Pdef(\gestos_I).play;
Pdef(\gestos_II).play;
Pdef(\gestos_III).play;
Pdef(\gestos_I).stop;
Pdef(\gestos_II).stop;
Pdef(\gestos_III).stop;

Pdef(\reso_base).play;
Pdef(\reso_base).stop;
Pdef(\reso_fragmentado).play;
Pdef(\reso_fragmentado).stop;
Pdef(\reso_medio).play;
Pdef(\reso_medio).stop;
Pdef(\reso_denso).play;
Pdef(\reso_denso).stop;
Pdef(\reso_grave).play;
Pdef(\reso_grave).stop;
Pdef(\reso_agudo).play;
Pdef(\reso_agudo).stop;
Pdef(\reso_total).play;
Pdef(\reso_total).stop;

// Solo base
Pdef(\ritmo_base).play;
Pdef(\ritmo_base).stop;
// Base con variaciones
Pdef(\ritmo_base_v1).play;
Pdef(\ritmo_base_v1).stop;
Pdef(\ritmo_base_v2).play;
Pdef(\ritmo_base_v2).stop;
// Medio
Pdef(\ritmo_medio).play;
Pdef(\ritmo_medio).stop;
// Medio variaciones
Pdef(\ritmo_medio_v1).play;
Pdef(\ritmo_medio_v1).stop;
Pdef(\ritmo_medio_v2).play;
Pdef(\ritmo_medio_v2).stop;
// Denso
Pdef(\ritmo_denso).play;
Pdef(\ritmo_denso).stop;
// Denso variaciones
Pdef(\ritmo_denso_v1).play;
Pdef(\ritmo_denso_v1).stop;
Pdef(\ritmo_denso_v2).play;
Pdef(\ritmo_denso_v2).stop;

//Parar todos los Pdefs
Pdef.all.do(_.stop);
//Verificar carpetas de buffers

~bufs_intro.size.postln;
~bufs_desarrollo.size.postln;
~bufs_final.size.postln;
~iters.size.postln;
~iasis.size.postln;
