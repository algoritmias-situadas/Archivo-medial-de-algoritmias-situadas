(
SynthDef(\Lead1,{|freq= 20, intensidad=0.2, attack = 0.01, release=0.4, out=0, pan=0, amp=0.15|
	var son1, son2, sonf, env, salida;
	son1=SinOsc.ar(freq, 0.3, 0.7);
	son2=SinOsc.ar(20, 0, intensidad, 0.6);
	env= EnvGen.kr(Env.perc(attack, release), doneAction:2);
	sonf=Mix(son1*son2*env);
	salida=Pan2.ar(sonf*amp, pan);
	Out.ar(out,salida)
}).add;

SynthDef(\percu,{|freq= 1400, freq2=247, intensidad=0.1, attack = 0.01, release=0.4 out=0,pan=0, nivsend=0, send=0, amp=0.25|
	var son1, son2, sonf, env, salida;
	son1=Saw.ar(freq*SinOsc.kr(10, 0, intensidad), intensidad);
	son2=SinOsc.ar(freq2, 0, intensidad);
	env= EnvGen.kr(Env.perc(attack, release), doneAction:2);
	sonf=Mix(son1*son2*env);
	salida=Pan2.ar(sonf*amp, pan);
	Out.ar(out, salida);
	Out.ar(send, salida*nivsend)
}).add;

SynthDef(\srythm, {|freq=40, out=0, pan =0, intensidad=0.6, attack=0.02, release=0.4, amp=0.4|
	var son1, son2, env, sonf, salida;
	son1 = SinOsc.ar(freq, 0, intensidad);
	son2 = SinOsc.ar([240, 180], 0, intensidad);
	env= EnvGen.kr(Env.perc(attack, release), doneAction:2);
	sonf= Mix(son1*son2*env);
	salida=Pan2.ar(sonf*amp, pan);
	Out.ar(out, salida)
}).add;

SynthDef(\Lead2,{|freq= 440, intensidad=0.1, attack = 0.15, decay=0.3, sus=0.5, release=0.037, gate=1, out=0, pan =0, amp = 0.175|
	var son1, mod1, mod2, mod3, mod4, sonf, env, chorus, chormod, salida;
	mod1=SinOsc.ar(11000, 0, intensidad)*500;
	mod2=Pulse.ar(899, 0.6, intensidad)*600;
	mod3=SinOsc.ar(400, 0, intensidad)*500;
	mod4=LFTri.ar(110, 0, intensidad)*50;
	son1=SinOsc.ar(freq+mod1+mod2+mod3+mod4, 0, intensidad);
	env= EnvGen.kr(Env.adsr(attack, decay, sus, release), gate, doneAction:2);
	sonf=Mix(son1*env);
	chormod=SinOsc.kr(0.1).range(0.001, 0.02);
	chorus = DelayC.ar(sonf, 0.05,chormod);
	salida= Pan2.ar(sonf+(chorus*0.8), pan);
	salida=((salida*6).tanh)*amp;
	Out.ar(out, salida)
}).add;

SynthDef(\arpeg,{|freq= 440, intensidad=0.1, attack = 0.08, release=0.4, out=0, pan = 0, send=0, nivsend=0, amp=0.3|
    var son1, son2, son3, sonf, env, salida, chorus, chormod;
    son1=Saw.ar(freq, intensidad);
    son2=SinOsc.ar(200, 0, 0.05);
	son3=SinOsc.ar(195, 0, 0.05);
    env= EnvGen.kr(Env.perc(attack, release),doneAction:2);
	sonf=(son1+son2+son3)*env;
	chormod=SinOsc.kr(0.2).range(0.001, 0.02);
	chorus = DelayC.ar(sonf, 0.02,chormod);
	salida=Pan2.ar((sonf+(chorus*0.4))*amp, pan);
	Out.ar(out, salida);
	Out.ar(send, salida*nivsend)
}).add;

SynthDef(\Metal,{|freq= 800, intensidad=0.2, attack = 0.01, release=0.2, out=0, pan=0, amp=0.075, send=0, nivsend=0|
	var mod1, son1, son2, son3, son4, sonf, env, salida;
	mod1=SinOsc.ar(909, 0, 0.33)*6000;
	son1=SinOsc.ar(freq+mod1, 0,intensidad);
	son2=SinOsc.ar(200, 0, 0.5, 0.3);
	son3=LFTri.ar(700, 0, 0.7, 0.3);
	son4=SinOsc.ar(80, 0.3, 0.8);
	env= EnvGen.kr(Env.perc(attack, release), doneAction:2);
	sonf=Mix(son1*son2*son3*son4*env);
	salida=Pan2.ar(sonf,pan);
	salida=((salida*13).tanh)*amp;
	Out.ar(out,salida);
	Out.ar(send, salida*nivsend)
}).add;

SynthDef(\Kick,{|freq= 20, intensidad=0.3, attack = 0.01, release=0.4, out=0, pan=0, amp=0.2|
	var son1, son2, sonf, env, salida;
	son1=SinOsc.ar(20, intensidad, 0.7);
	son2=SinOsc.ar(40, 0, 1, 0.6);
	env= EnvGen.kr(Env.perc(attack, release), doneAction:2);
	sonf=Mix(son1*son2*env);
	salida=Pan2.ar(sonf, pan);
	salida=(salida*10).tanh*amp;
	Out.ar(out,salida)
}).add;

SynthDef(\Bass, {|out = 0, freq=80, freq2=8000, intensidad = 0.3, attack = 0.05, decay=0.2, sus=0.7, release=0.6, gate=1, pan = 0, amp=0.45|
	var mod1, son1, son2, sonf, env, salida;
	mod1=SinOsc.ar(freq, 0, intensidad)*300;
	son1=LFTri.ar(freq+mod1,0, intensidad);
	son2=LPF.ar(Saw.ar(freq2, intensidad, 1), 400, 1);
	env=EnvGen.kr(Env.adsr(attack, decay, sus, release), gate, doneAction:2);
	sonf=Mix(son1*son2*env);
	salida=Pan2.ar(sonf*amp, pan);
	Out.ar(out, salida)
}).add;

SynthDef(\tremo, {|out=0, freq= 520, freq2=8 ,intensidad=0.2, attack=0.05, decay=0.3, sus=0.5, release=1, gate=1, pan=0, amp=0.075|
	var lfo1, lfo2,mod1,  son1, son2, env, sonf,chorus, chormod, salida;
	lfo1=Pulse.kr(8).range(freq, 10000);
	mod1=SinOsc.ar(lfo1, 0, SinOsc.kr(55).range(0.1, 0.4));
	son1=SinOsc.ar(freq+(mod1*3000), 0, intensidad);
	son2=SinOsc.ar(freq2, 0, intensidad, 0.6);
	env=EnvGen.kr(Env.adsr(attack, decay, sus, release),gate, doneAction:2);
	lfo2=SinOsc.kr(0.325).range(1.4, 2.7);
	sonf=Mix(son1*son2*env*lfo2);
	chormod=SinOsc.kr(0.6).range(0.001,0.6);
	chorus=DelayC.ar(sonf, 0.06, chormod);
	salida=Pan2.ar(LPF.ar((sonf+chorus*2)*amp, 4500), pan);
	Out.ar(out, salida)
}).add;

SynthDef(\arpchor,{|freq= 440, intensidad=0.1, attack = 0.08, release=0.4, out=0, pan = 0, send=0, nivsend=0, amp=0.15|
    var son1, son2, son3, sonf, env, chorus, chormod, salida;
    son1=Saw.ar(freq, intensidad);
    son2=SinOsc.ar(200, 0, 0.05);
	son3=SinOsc.ar(195, 0, 0.05);
    env= EnvGen.kr(Env.perc(attack, release),doneAction:2);
	sonf=(son1+son2+son3)*env;
	chormod=SinOsc.kr(0.15).range(0.001, 0.025);
	chorus = DelayC.ar(sonf, 0.02, chormod);
	salida=Pan2.ar((sonf+chorus)*amp, pan);
	Out.ar(out, salida);
	Out.ar(send, salida*nivsend)
}).add;

SynthDef(\large, {|freq=440, intensidad=0.2, attack=0.01, decay=0.3, sus=0.3, release= 1.25, gate=1, out=0, pan=0, send=0, nivsend=0, amp=0.3|
	var son1, son2, mod1, sonf, env, salida;
	mod1=SinOsc.ar(768, 0, intensidad)*200;
	son1=SinOsc.ar(freq+mod1, 0, intensidad);
	son2=LFTri.ar(800, 0, intensidad, 1.5);
	env=EnvGen.kr(Env.adsr(attack, decay, sus, release), gate, doneAction:2);
	sonf=Mix(son1*son2*env);
	salida=Pan2.ar(sonf*amp, pan);
	Out.ar(out, salida);
	Out.ar(send, salida*nivsend)
}).add;

SynthDef(\nost, {|out=0, freq=800 ,intensidad=0.3, attack=3, decay=0.3, sus=0.5, release=0.07, gate=1, pan=0, amp=0.8, send=0, nivsend=0|
	var  mod1, son1, son2, env, sonf,chorus, chormod, salida;
	mod1=SinOsc.ar(1000, 0, intensidad)*200;
	son1=LFTri.ar(freq+mod1, 0, intensidad);
	son2=SinOsc.ar(800, 0, intensidad, 1);
	env=EnvGen.kr(Env.adsr(attack, decay, sus, release),gate, doneAction:2);
	sonf=Mix(son1*son2*env);
	chormod=SinOsc.ar(0.16).range(0.001,0.02);
	chorus=DelayC.ar(LPF.ar(sonf,150), 0.2, chormod);
	salida=Pan2.ar((sonf+(chorus*2))*amp, pan);
	Out.ar(out, salida);
	Out.ar(send, salida*nivsend)
}).add;

SynthDef(\chord, {|out=0, freq=300, intensidad=0.2, attack=0.2, decay=0.4, sus=0.4, release=2, gate=1, pan=0, amp=0.8|
	var mod1, mod2, son1, son2, env, sonf, salida;
	mod1 = SinOsc.ar(freq/2, 0, intensidad) * 300;
	mod2 = SinOsc.ar(freq*2, 0, intensidad) * 300;
	son1 = Mix(SinOsc.ar(freq + mod1 + mod2, 0, intensidad));
	son2 = Mix(SinOsc.ar(freq*2, 0, intensidad * 0.5));
	env = EnvGen.kr(Env.adsr(attack, decay, sus, release), gate, doneAction:2);
	sonf = (son1) * env;
	salida = Pan2.ar(sonf * amp, pan);
	Out.ar(out, salida)
}).add;

SynthDef(\const, {|out=0, freq=440, intensidad=0.15, attack=0.01, release=0.25, pan=0, amp=0.1, send=0, nivsend=0|
	var son1, env, sonf, salida;
	son1=Pulse.ar(freq, 0.5, intensidad);
	env=EnvGen.kr(Env.perc(attack, release), doneAction:2);
	sonf=son1*env;
	salida=Pan2.ar(sonf*amp, pan);
	Out.ar(out, salida);
	Out.ar(send, salida*nivsend)
}).add;

SynthDef(\rev, { |in, out = 0, mix = 1, room = 0.7, damp = 0.1|
    var  rev;
	rev = FreeVerb.ar(In.ar(in, 2), mix, room, damp);
	Out.ar(out, rev);
}).add;

SynthDef(\dely, { |in, out = 0, max = 1, time = 0.5, mul = 1|
    var  del;
	del = DelayC.ar(In.ar(in, 2), max, time, mul);
	Out.ar(out, del);
}).add;

~reverbus = Bus.audio(s, 2);
~verb = Synth(\rev,[\in, ~reverbus]);

~delbus = Bus.audio(s, 2);
~lay = Synth(\dely, [\in, ~delbus]);

a = Pbind(\instrument, \srythm,
	\amp, Prand([0.5, 0.6, 0.7], inf),
	\degree,Pseq([-5, -2], inf),
	\octave, 2,
	\dur, Prand([1, 0.25, 0.75], inf),
	\scale, Scale.dorian,
	\pan, Prand([-1,1],inf)
);

b = Pbind(\instrument, \Lead1,
	\amp, Pseq([0.1, 0.3, 0.5, 0.4, 0.4, 0.2, 0.1], inf),
	\root, 0,
	\degree, Pseq([-2, -4, -1, -7, -3, -3, -2, -1], inf),
	\octave, 7,
	\dur, Prand([0.75, 0.5, 0.25],inf),
	\scale, Scale.dorian);

c = Pbind(
	\instrument, \percu,
	\amp, Pseq([0.2, 0.4, 0.3, 0.1], inf),
	\root, 0,
	\degree,-2,
	\octave, 6,
	\pan, -1,
	\dur, Prand([0.5, 0.75],inf),
	\send, ~reverbus,
	\nivsend, 0.1);

d = Pbind(
	\instrument, \Lead2,
	\root, 0,
	\degree, Pseq([1, 1, 0, 1, 2, 1, -3], inf),
	\octave, 5,
	\dur, Prand([0.5, 0.25], inf),
	\sustain, 0.25,
	\scale, Scale.dorian,
	\amp, Pseq([0.2, 0.3, 0.4], inf),
	\pan, Pwhite(-1.0, 1.0, inf));

e = Pbind(
	\instrument, \percu,
	\amp, Prand([0.2, 0.3, 0.1], inf),
	\degree,Pseq([-5, -2], inf),
	\octave, 2,
	\pan, 1,
	\dur, Prand([0.25, 1, 0.5], inf),
	\scale, Scale.dorian,
	\send, ~reverbus,
	\nivsend, 0.1);

f = Pbind(
	\instrument, \arpeg,
	\amp,Prand([0.4, 0.5],inf),
	\degree, Pseq([0,4,2,7,1,6,3],inf),
	\octave, 5,
	\dur, Prand([0.5, 0.25], inf),
	\scale, Scale.dorian,
	\send, ~reverbus,
	\nivsend, 3.5);

g=Pbind(\instrument, \Metal,
	\amp, 0.1,
	\root, 0,
	\degree, Pseq([5, 5, 5, 5, 5, 4],inf),
	\octave, 1,
	\dur, Pseq([0.5, 0.5, 0.5, 0.5, 0.25],inf),
	\send, ~reverbus,
	\nivsend, 0.4);

h=Pbind(\instrument, \Lead1,
	\amp, Pseq([0.1, 0.3, 0.4, 0.4, 0.2, 0.1], inf),
	\root, 0,
	\degree, Pseq([0, -2, 1, -5, -1, -1, 0, 1], inf),
	\octave, 7,
	\dur, Prand([0.75, 0.5, 0.25],inf),
	\scale, Scale.dorian,
	\pan, 1);

i = Pbind(\instrument, \Lead1,
	\amp, Pseq([0.1, 0.3, 0.5, 0.4, 0.4, 0.2, 0.1], inf),
	\root, 0,
	\degree, Pseq([-4, -2, -3, -9, -5, -5, -4, -3], inf),
	\octave, 7,
	\dur, Prand([0.75, 0.5, 0.25],inf),
	\scale, Scale.dorian,
	\pan, -1,);

j = Pbind(\instrument, \Kick,
	\amp, 0.3,
	\root, 0,
	\degree, 0,
	\dur, Pseq([0.5, 0.5, 0.5, 0.5, 0.5, 0.25],inf));

k=Pbind(\instrument, \Bass,
	\amp, Prand([0.4, 0.5, 0.7],inf),
	\root, 0,
	\degree, Prand([0,-1, 4, -3, 1, 3],inf),
	\octave, 3,
	\scale, Scale.dorian,
	\sustain, 0.2,
	\dur, Pseq([0.75, 0.5, 0.5, 0.25, 1, 0.75],inf));

l=Pbind(\instrument, \Bass,
	\amp, Prand([0.4, 0.6],inf),
	\root, 0,
	\degree, Prand([0,-1, 1, -2, -3],inf),
	\octave, 3,
	\scale, Scale.dorian,
	\sustain, 0.1,
	\release, 0.05,
	\dur, Prand([0.25, 0.5],inf));

m=Pmono(\tremo,
	\freq, 261,
	\sustain, 4);

n=Pbind(\instrument, \arpchor,
	\amp, 0.3,
	\degree, Pseq([0,4,2,7,1,6,3],inf),
	\octave, 5,
	\dur, Prand([0.5, 0.25], inf),
	\scale, Scale.dorian,
	\send, ~reverbus,
	\nivsend, 3.5);

o=Pbind(\instrument, \large,
	\amp, 0.3,
	\degree, Prand([-6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6], inf),
	\octave, 6,
	\dur, Pseq([1, 1, 0.75, 1, 0.25, 1 ,1],inf),
	\sustain, 0.25,
	\scale, Scale.dorian,
	\send, ~delbus,
	\nivsend, Pwhite(0.2, 0.75, inf));

p=Pbind(\instrument, \Kick,
	\amp, Prand([0.4, 0.3], inf),
	\degree, 0,
	\dur, Pseq([0.25, 0.25, 0.5, 0.5, 0.75, 0.25, 0.25,0.5],inf));

q=Pbind(\instrument, \nost,
	\degree, Pshuf([2, 2, -1, -1, 4, 4, -3, 1] ,inf),
	\scale, Scale.dorian,
	\octave, 6,
	\amp, 0.4,
	\dur, Pshuf([0.25, 0.25, 0.25, 0.5, 0.5, 0.5, 0.75, 1, 1, 1.25, 1.25], inf),
	\sustain, 0.5,
	\send, ~delbus,
	\nivsend, 1,
	\pan, Prand([-1, -0.5, 0, 0.5, 1],inf));

r = Pbind(\instrument, \chord,
    \degree, Ptuple([Prand([2, 3, -1, 0, 1], inf), Prand([2, 3, 5, 6, 7], inf), Prand([3, 4, 5], inf) ], inf),
    \scale, Scale.dorian,
    \octave, 6,
    \dur, Pseq([2, 2, 2, 1.5, 1.5], inf),
    \sustain, 1);

t=Pbind(\instrument, \const,
	\degree, 4,
	\octave, 6,
	\dur, 0.25,
	\amp, Prand([0.05, 0.15], inf),
	\send, ~reverbus,
	\nivsend, 0.8);
)

Ptpar([0, c.finDur(200), 0, e.finDur(200), 4, a.finDur(198), 12, f.finDur(28), 18, j.finDur(106), 18, k.finDur(22), 24, m.finDur(16), 40, b.finDur(20), 48, h.finDur(16), 52, i.finDur(12), 64, d.finDur(24), 64, l.finDur(48), 70, g.finDur(18), 76, m.finDur(12), 88, Pseq([Pshuf([n.finDur(24), Ppar([h.finDur(24), i.finDur(24)],1), o.finDur(24), q.finDur(24)],1)]), 114, r.finDur(24), 112, k.finDur(28), 136, t.finDur(48), 136, p.finDur(60), 160, g.finDur(36), 160, q.finDur(24)]).play;