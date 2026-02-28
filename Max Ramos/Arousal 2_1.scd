(
SynthDef.new(\loentropico,{|out 0 , index 10, ss 1, ss1 0, amp 0.7 , freq 700, trig 1, dust 1, freqm 6,
	num 1, action 2, atk 0, dur 1, rel 5,
	freqsins 40,
	mix 0.3, room 0.5,
	paneo 0,
	corte 1000 |
	var son, randi, env, sinuss;
	randi= SelectX.kr(ss, [
		SinOsc.kr(freq/2,0,freq,freq),
		LFTri.kr(freq/2,0,freq,freq),
		LFSaw.kr(freq/2,0,freq,freq),
	]);

	son= SelectX.ar(ss1, [
		SinOsc.ar(randi,0,0.2),
		LFTri.ar(randi,0,0.2),
		LFSaw.ar(randi,0,0.2),
	]);

	sinuss= Klang.ar(`[Array.rand(10, 1, 20) * freqsins,0.08!10, Array.rand(10,0.1,2pi)]);

	trig= Dust.ar(dust);
	son = son+sinuss;
	son=  Decay2.ar(trig,0.5, 1, son);
	env = EnvGen.kr(
		Env.perc(atk, rel, 1), doneAction:action);
	son = Mix(son);
	son= Pan2.ar(son, paneo);
	son= LPF.ar(son,corte);
	Out.ar(out, son*env*amp);
}).add;

SynthDef(\rev, {|in, out = 0, mix = 0.3, room = 0.5|
	Out.ar(out, FreeVerb2.ar(In.ar(in,1), In.ar(in+1, 1), Lag.kr(mix, 0.1), Lag.kr(room, 0.2)));
}).add;

SynthDef(\fx, {|in 0, gate 1|
	var sonido, env;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	sonido = In.ar(in,2);
	sonido = sonido + NHHall.ar(sonido, 3, modDepth: 1);
	sonido = BHiShelf.ar(sonido, 3000,1, -10);
	sonido = BLowShelf.ar(sonido, 100, 1, 10);
	sonido = Limiter.ar(sonido);
    XOut.ar(0, env, sonido);
}, [\ir, \ir, 0.1, 0.1, 0]
).add;

SynthDef(\pads,{|freq 400, amp 0.1, dur 1, out 0, freqC 300, ataque 3, legato 1|
		var sonido;
	sonido = Saw.ar(freq * ({LFNoise2.kr(8)} ! 16 * 0.1).midiratio);
	sonido = DelayC.ar(sonido, 0.1,{Rand(0,0.1)}! sonido.size);
	sonido = Splay.ar(sonido);
	sonido = sonido * EnvGen.kr(Env.perc(ataque, dur*legato, 1), doneAction:2);
	sonido = sonido * amp;
	sonido = LPF.ar(sonido, freqC);

	Out.ar(out,sonido);
}).add;


~bus = Bus.audio(s, 2);
~grp = Group(s);
~grpR = Group(~grp, 'addToTail');

Pdef(\rever,
	Pmono(\rev,
		\in, ~bus,
		\dur, Pwhite(1,5.0),
		\room, Pwhite(0.01, 1),
     	\mix, Pwhite(0.0,1,inf),
		\out, 0,
		\group, ~grpR
));

Pdef(\loentropico,
	Pbind(\instrument, \loentropico,
		\scale, Scale.minor,
		\root, 3,
		\degree, Pwhite(0, 10, inf),
		\octave, Prand([4, 5], inf),
		\dur, Pwhite(0.5, 1)*Pfunc({~duras2}),
		//	\dur, 0.1,
		\ss, Pseq((0..2), inf),
		\ss1, Pseq((0..2), inf),
		\dust, Pwhite(10,20),
		\action,2,
		\index,Pwhite(10,2000,inf),
		\mul,0.6,
		\atk, 1*Pfunc({~ataque2}),
		\rel, Pkey(\dur)+Pfunc({~release}),
		\room, 1,
		\freqsins, Pwhite(100,200,inf),
		\paneo, Pwhite(-1.0,1,inf),
		\corte, 10000,
		\freqm, Pwhite(40,500,inf),
		\amp, Pwhite(0.3, 0.75),
		\out, ~bus,
		\group, ~grp
));

f = Pbind(\instrument, \pads,
	\dur, Psubdivide(Pseq([5, 7, 7], inf), Pseq([1, 2, 3], inf))*Pfunc({~duras}),
	\scale, Scale.minor,
	\root, 3,
	\degree, Pwhite(0, 10, inf),
	\octave, Prand([4, 5], inf),
	\out, 0,
	\freqC, Pfunc({~cortte}),
	\freqM, Pfunc({~freqM}),
	\ataque,Pfunc({~ataque}),
	\legato, 3,
);

Pdef(\pads, Pfx(f, \fx));

Pdef(\rever).play;
Pdef(\loentropico).play;
Pdef(\pads).play;
~duras = 1;
~duras2 = 10;
~ataque = 3;
~ataque2 = 1;
~release = 1;
~cortte = 300;
~freqM = 8;


~durasM =  ControlSpec(1, 0.3, \exp, 0.01);
~duras2M = ControlSpec(10, 0.1, \exp, 0.01);
~ataqueM = ControlSpec(3, 0.1, \exp, 0.01);
~ataque2M = ControlSpec(1, 0.1, \exp, 0.01);
~releaseM = ControlSpec(0.01, 1, \exp, 0.01);
~cortteM = ControlSpec(300, 9700, \exp, 0.01);
~freqMM = ControlSpec(8, 100, \exp, 0.01);

w = Window("miVentana", Window.screenBounds);
w.background = Color.black;
k = Knob(w, Rect(Window.screenBounds.width/3, Window.screenBounds.height/5, Window.screenBounds.width/3, (Window.screenBounds.height/5)*3));
k.action = {|v|  v.value.postln;
	~cortte = ~cortteM.map(v.value);
	~freqM = ~freqMM.map(v.value);
	~ataque = ~ataqueM.map(v.value);
	~ataque2 = ~ataque2M.map(v.value);
	~duras = ~durasM.map(v.value);
	~duras2 = ~duras2M.map(v.value);
	~release = ~releaseM.map(v.value);
};
w.front
)
