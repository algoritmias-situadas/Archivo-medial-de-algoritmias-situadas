//sins
(



SynthDef(\Wind, { |freq = 440, amp=1, out=0|
	var sign;
	sign = SinOsc.ar(LFNoise2.kr(SinOsc.kr(0.3,0,0.2,Saw.kr(0.6,0.6,Lag.kr(freq, 1))), freq/2, freq),0,1);
    Out.ar(out,Pan2.ar(sign, 0, amp));
}).add;



SynthDef(\yaw, { |freq = 440, amp, attk = 1, release = 1, dur, ritm, out=0, pan = 0, db = -12|
    var son, env, env2;
	son = Saw.ar([freq,freq*3.2])+SinOsc.ar([freq/2],0,SinOsc.kr(ritm,0,1,2.5),0.2);
    son =  Mix(son);
    env2 = EnvGen.kr(Env.perc(attk,release),doneAction:2);
    Out.ar(out,Pan2.ar(son*0.4*env2,pan,amp));
}).add;



SynthDef(\brrr, { |freq = 440, amp=0.5, attk = 1, release = 1, ritm = 1, dur = 1, strum = 0.0, out=0, pan = 0|
    var son, env2, partials;
    partials = [SinOsc.ar(freq),SinOsc.ar(freq*2),SinOsc.ar(freq*4),Pulse.ar(freq/2, SinOsc.kr(ritm,0,0.5,0.5).clip(0.01,0.99), 0.2)];
    partials = Array.fill(partials.size, { |i|DelayN.ar(partials[i], 0.1, i * strum)});
    son = Mix.new(partials);
    env2 = EnvGen.kr(Env.perc(attk, release), doneAction: 2);
    Out.ar(out, Pan2.ar(son * 0.2 * env2 * amp, pan));
}).add;



SynthDef(\bells, { |out = 0, prob = 0.66, freq = 440, amp=0.5, dur|
    var trig;
    trig = SinOsc.ar(freq,0,0.5)+Saw.ar(freq/0.33,SinOsc.kr(1,0.5,0.2));
    Out.ar(out,Mix.fill(3, { Ringz.ar(CoinGate.ar(prob, trig*0.66), #[1, 1.5]*Rand(100, 900), dur)}))
}).add;



SynthDef(\wupwup, { |freq=440, amp=1, out=1, dur|
	SinOsc.ar(LFNoise1.ar(freq, freq*2, freq*3),0, amp)
}).add;



SynthDef(\dentist, { |out=0, freq=443, amp=1, pan=0, gate=1|
	var sign, env0;
	sign = Pulse.ar(freq, SinOsc.kr(0.5, 1, 0.1, 0.5), amp)+ SinOsc.ar(freq * 2, 0, SinOsc.kr(1, 0, 0, 0.5));
    env0 = EnvGen.kr(Env.adsr(1, 0.5, 0.6, 1), gate, doneAction: 2);
    Out.ar(out, Pan2.ar(sign * env0, pan, amp));
}).add;



SynthDef(\highat, { |out=0, amp=0.1, freq=4000, pan=0, trig=1, mix=0.3|
    var env, sign, rev;
    env = EnvGen.kr(Env.perc(0.01, 0.2), Changed.kr(trig));
    sign = HPF.ar(WhiteNoise.ar, freq) * env;
	rev = FreeVerb.ar(sign,mix,0.6,0.3);
    Out.ar(out, Pan2.ar(rev, pan, amp));
}).add;



SynthDef(\kicker, { |out=0, amp=0.8, freq=80, trig=1, attk=0.001, decay=0.25, drive=1.0, revMix=0.2, revRoom=0.5, revDamp=0.3, pan=0|
    var envAmp, envFreq, sig, sub, rev;
    envAmp = EnvGen.kr(Env.perc(attk, decay), trig, doneAction: 2);
    envFreq = EnvGen.kr(Env([freq*2, freq], [0.03], 'exp'), trig);
    sig = SinOsc.ar(envFreq) * envAmp;
    sub = SinOsc.ar(freq*0.5) * envAmp * 0.4;
    sig = ((sig + sub) * drive).tanh;
    rev = FreeVerb.ar(sig, revMix, revRoom, revDamp);
    Out.ar(out, Pan2.ar(rev, pan, amp));
}).add;



SynthDef(\snarer, {
    |out=0, amp=0.6, tone=180, noise=0.7, decay=0.25, drive=1.5, revMix=0.25, revRoom=0.5, revDamp=0.3, pan=0, strum=0.0, click=0.1, sub=0.3|
    var envNoise, envTone, noiseSig, toneSig, clickSig, subSig, sig, rev, partials;
    envNoise = EnvGen.kr(Env.perc(0.001, decay), doneAction:2);
    envTone  = EnvGen.kr(Env.perc(0.001, decay*0.6), doneAction:2);
    clickSig = EnvGen.kr(Env.perc(0.001, click), doneAction:2);
    noiseSig = WhiteNoise.ar * envNoise;
    noiseSig = BPF.ar(noiseSig, 3000, 0.6);
    toneSig = SinOsc.ar(tone) * envTone;
    clickSig = WhiteNoise.ar * clickSig * 0.5;
    subSig = SinOsc.ar(tone*0.5) * envTone * sub;
    partials = [noiseSig * noise, toneSig * (1 - noise), clickSig, subSig];
    partials = partials.collect { |s, i| DelayN.ar(s, 0.05, i * max(strum, 0)) };
    sig = Mix.new(partials);
    sig = (sig * drive).tanh;
    rev = FreeVerb.ar(sig, revMix, revRoom, revDamp);
    Out.ar(out, Pan2.ar(rev, pan, amp));
}).add;


)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Pbinds
(



a = Pbind (\instrument, \brrr,
	\freq, Pwhite(55.0,1500,inf),
	\strum, Prand ([0,0.01,0.05],inf),
	\dur, Psubdivide(Prand(#[1,5,1,1,1,2,2,0,2,2,0,1,3,3,4,4,0],inf), Pseq(#[1,2,3,2,1,0.5],inf)),
	\legato, Pwhite(0.2,1,inf),
	\ritm, Pseq([1,20,3],inf),
	\pan, Prand([-1,1],inf),
	\attk, Pwhite(0.1,1,inf),
	\release,Pwhite(0,2,inf),
	\db, Prand([-15, -12, -inf], inf),
	\out, 0,
);

b = Pmono(\Wind,
	\pan, Pwhite(-1, 1.0),
	\freq, Pdup(1, Pseq([Pwhite(100.0,400),Pwhite(225.0,800),Pwhite(885.0,1200)],inf)),
	\degree, Pwhite(-6, 7, inf),
	\amp, Pwhite(0.025,0.10,inf),
	\dur, Pwhite(2, 10,inf),
	\out, 0,
);

c = Pmono (\bells,
	\amp, 1,
	\prob, 0.66,
	\freq, Pwhite( 20.22,66,inf),
	\dur, Pwhite(0, 5, inf),
	\out, 0,
);

d = Pbind (\instrument, \wupwup,
	\freq, Pwhite(442, 2153,inf),
	\amp, Prand([0.3,1,0.5],inf),
	\pan, Prand([-0.2,1],inf),
	\dur, Pwhite(4, 10, inf),
	\out, 0,
);

f = Pbind (\instrument, \yaw,
	\freq, Pwhite(84, 888,inf),
	\db, Prand([-18, -15, -12, -inf], inf),
	\legato, Pwhite(0.2,1,inf),
	\dur, Psubdivide(Prand(#[1,5,0,1,0,2,2,1,3,4],inf), Pseq(#[1,2,3,2,1,0.5],inf)),
	\ritm, Pseq([1,20,3,6],inf),
	\attk, Pwhite(0.01,0.1,inf),
	\release,Pwhite(1,5,inf),
	\out, 0,
);

g = Pbind (\instrument, \dentist,
	\freq, Pseq([[82, 94, 200], [46, 58, 100], [54, 87,300]],inf),
	\amp, Pseq([0.3,0.5],inf),
	\pan, Prand([-1,1],inf),
	\dur, Pwhite(2, 10, inf),
	\out, 0,
);

h = Pmono(\highat,
	\trig, Pseq([0,1],inf),
	\freq, Pwhite(900,1200,inf),
	\amp, Pseq([0.3,0.5],inf),
	\mix, Prand([0.3,0.5],inf),
	\pan, Prand([-1,1],inf),
	\dur, Pwhite(0.25,2,inf),
);

o = Pmono(\highat,
	\trig, Pseq([0,1],inf),
	\freq, Pwhite(1000,1500,inf),
	\amp, Pseq([0.3,0.5],inf),
	\mix, Prand([0.3,0.5],inf),
	\pan, Prand([-1,1],inf),
	\dur, Pwhite(0.25,2,inf),
);

k = Pbind(
    \instrument, \kicker,
    \trig, 1,
    \freq, Pexprand(50, 100, inf),
    \amp, Pfunc({ |ev|
     var f = ev[\freq];
     0.25 + ((100 - f)/50).clip(0,0.8)}),
    \attk, Pfunc({ |ev|
        var f = ev[\freq];
    0.001 + ((100 - f)/200)}),
    \decay, Pfunc({ |ev|
        var f = ev[\freq];
    0.2 + ((f-50)/200)}),
    \drive, Pfunc({ |ev|ev[\amp].linlin(0.25, 0.8, 1, 2)}),
    \revMix, Pwhite(0.2, 0.35, inf),
    \revRoom, Pwhite(0.4, 0.6, inf),
    \revDamp, Pwhite(0.2, 0.5, inf),
    \pan, Pseq([-0.5,0,0.5,0], inf),
    \dur, Pwhite(0.25, 0.8, inf),
);

l = Pbind(\instrument, \snarer,
    \freq, 150,
    \amp, 0.7,
    \noise, 0.6,
    \drive, Pxrand([1,1.5,2], inf),
    \strum, Pxrand([0, 0.02, 0.05], inf),
    \click, Pxrand([0.05, 0.1, 0.2], inf),
    \sub, 0.4,
    \revMix, 0.3,
	\pan, Prand([-1,1],inf),
    \revRoom, 0.5,
    \revDamp, 0.2,
    \dur, Pwhite(0.25,1,inf),
);

)

//Tempo y reproduccion//

t = TempoClock(80/60).permanent = true;

(
e = Ptpar ([0, b.finDur(60), 12, a.finDur(104), 170, g.finDur(47)]);
d = Ptpar ([0, d.finDur(116), 120, c.finDur(97), 120, f.finDur(66)]);
i = Ptpar ([0, h.finDur(60), 0, k.finDur(186), 0, l.finDur(60)]);
m = Ptpar ([120, l.finDur(56), 200, k.finDur(40), 140, o.finDur(46)]);
)

edim
w = Ppar([e, d, i, m]).play(t);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////