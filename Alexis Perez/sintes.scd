SynthDef(\sampler, {
    arg out = 0, buf = 0, baseMidi = 0, rate = 1, start = 0, atk=0.01, dec=0.3, sus=1, rel=1, gate=1,amp= -14.dbamp, sendLvl = 0, sendBus, pan=0, loop=0;

    var rateMod, frames, sig, env, lfo;
    var sig1Shot, sigLoop, phase1, phase2, win1, win2;

    rateMod = (rate - baseMidi).midiratio * BufRateScale.ir(buf);
    frames = BufFrames.ir(buf);

    sig1Shot = PlayBuf.ar(2, buf, rateMod, startPos: start, loop: loop);

    phase1 = Phasor.ar(0, rateMod, 0, frames);
    phase2 = (phase1 + (frames / 2)).wrap(0, frames);

    win1 = (phase1 / frames * 2pi).cos.neg.range(0, 1).sqrt;
    win2 = (phase2 / frames * 2pi).cos.neg.range(0, 1).sqrt;

    sigLoop = (BufRd.ar(2, buf, phase1) * win1) + (BufRd.ar(2, buf, phase2) * win2);


    sig = Select.ar(loop, [sig1Shot, sigLoop]); // Si loop es 0, elige sig1Shot. Si loop es 1, elige sigLoop.

    sig = LeakDC.ar(sig);
    lfo = SinOsc.kr(Rand(0.1, 0.2), -pi/2).range(800, 3000);
	sig = LPF.ar(sig, lfo, 0.5);

    env = EnvGen.kr(Env.adsr(atk, dec, sus, rel), gate, doneAction: 2);

	sig = Balance2.ar(sig[0], sig[1], pan, env * amp); // esto aplica el paneo correctamente

    Out.ar(out, sig);
    Out.ar(sendBus, sig * sendLvl);
}).add;


SynthDef(\rt, { // sintetizador de silencio
	var sig = 0, env = EnvGen.kr(Env.perc(0.01, 0.01), doneAction: 2);
	Out.ar(0, sig * env);
}).add;

SynthDef(\bb, {
    arg out=0, freq=440, amp=0.5, pan=0, rel=0.15, sendBus, sendLvl = 0.8;
    var env, pitchEnv, sig;

    env = EnvGen.kr(Env.perc(0.01, rel), doneAction: 2);
    //pitchEnv = EnvGen.kr(Env.perc(0.001, 0.05)) * 200;
    sig = SinOsc.ar(freq) + SinOsc.ar(freq+7) + SinOsc.ar(freq-7);
    sig = Pan2.ar(sig * env, pan);

	Out.ar(out, sig * amp);

    Out.ar(sendBus, sig * sendLvl);

}).add;


SynthDef(\sawLead, {
    arg out=0, freq=440, amp=0.5, pan=0, atk=0.1, rel=0.8,
        gate=1, sendBus, sendLvl=0.8,
        detuneHz = 0.1; // Desafinación fija en Hercios (no en ratio)

    var sig, env, chorus;

    env = EnvGen.kr(Env.adsr(atk, 0.3, 0.7, rel), gate, doneAction: 2);

    sig = [
        Saw.ar(freq + detuneHz),
        Saw.ar(freq - detuneHz),
    ];

    chorus = DelayC.ar(sig, 0.05, [0.012, 0.015]);
    sig = sig + (chorus * 0.4);

    sig = LPF.ar(sig, 8200);
    sig = (sig * 1.4).tanh; // La saturación aporta armónicos cálidos


    sig = Balance2.ar(sig[0], sig[1], pan);
    sig = sig * env * amp;

    Out.ar(out, sig);
    Out.ar(sendBus, sig * sendLvl);
}).add;



SynthDef(\s3, {
	arg out = 0, pan=0, amp = -3.dbamp, sendLvl = 0, sendBus;
	var sig;
	sig = SinOsc.ar(Env([1000, 210, 0], [0.005, 0.05, 0.4], [-2, -0.5]).ar, pi/2);
	sig = sig * Env.perc(0.005, 0.15, curve: -12).ar(Done.freeSelf);
	sig = sig + (BRF.ar(WhiteNoise.ar, 500, 0.5, 0.2) * Env.perc(0.02, 0.2, curve: -12).ar * -20.dbamp);
	sig = sig * amp;
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
    Out.ar(sendBus, sig * sendLvl);
}).add;



SynthDef(\k1, {
	arg out = 0, pan=0, amp = -2.dbamp, sendLvl = 0, sendBus;
	var sig;
	sig = SinOsc.ar(Env([1000, 50, 10], [0.005, 0.2, 0.2], [-2, -0.5]).ar, pi/2);
	sig = sig * Env.perc(0.005, 0.4, curve: -12).ar(Done.freeSelf);
	sig = HPF.ar(sig, 48, 1);
	sig = sig * amp;
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
    Out.ar(sendBus, sig * sendLvl);
}).add;





SynthDef(\hh, {
	arg out = 0, amp = -12.dbamp, sendLvl = 0, sendBus;
	var sig;
	sig = WhiteNoise.ar;
	sig = sig * EnvGen.kr(Env.perc(0.005, 0.2, curve: -12), doneAction: 2);
	sig = HPF.ar(sig, 1000, 0.5);
	sig = sig * amp;
	//sig = FreeVerb.ar(sig, mix: 0.8, room: 0.05, damp: 0.33);
	//sig = GVerb.ar(sig, 20, 1, 0.33, drylevel: 0);
	sig = Pan2.ar(sig, \pan.kr(0));
	Out.ar(out, sig);
    Out.ar(sendBus, sig * sendLvl);
}).add;





SynthDef(\mallet, {
    arg freq=440, amp=0.3, gate=1, out=0, pan=0, sendLvl = 0;
    var sig, env, click;

    click = PinkNoise.ar() * EnvGen.ar(Env.perc(0.001, 0.01));

    sig = SinOsc.ar(freq);
    sig = sig + (SinOsc.ar(freq * 2) * 0.1);

    env = EnvGen.kr(Env.perc(0.005, 1.2), gate, doneAction: 2);

    sig = (sig + click) * env;
    sig = LPF.ar(sig, 2500);

    Out.ar(out, Pan2.ar(sig * amp, pan));
}).add;


SynthDef(\bell, {
    arg freq=440, amp=0.2, atk=0.05, rel=2.5, gate=1, out=0, sendBus, sendLvl=0.6;
    var sig, env, mod;

    env = EnvGen.kr(Env.adsr(atk, 0.4, 0.1, ), gate, doneAction: 2);

    mod = SinOsc.ar(freq * 2, 0, freq * 0.8 * EnvGen.kr(Env.perc(0.01, 0.5)));

    sig = SinOsc.ar(freq + mod, 0, amp);
    sig = sig * env;

    // Salida estéreo con ligero paneo aleatorio
    sig = Pan2.ar(sig, LFNoise1.kr(0.2).range(-0.3, 0.3));

    Out.ar(out, sig);
    Out.ar(sendBus, sig * sendLvl);
}).add;

SynthDef(\pulse, {
    arg freq=440, amp=0.15, gate=1, out=0, sendBus, sendLvl=0.8;
    var sig, env;

    env = EnvGen.kr(Env.perc(0.01, 1.2), gate, doneAction: 2);

	sig = SinOsc.ar(freq, 0, amp);

    sig = sig * env;

    Out.ar(out, Pan2.ar(sig, 0));
    Out.ar(sendBus, Pan2.ar(sig * sendLvl, 0));
}).add;


SynthDef(\chorus, {
	arg inBus, out=0, sendLvl;
	var sig, chorusL, chorusR;

	sig = In.ar(inBus, 2);

	chorusL = DelayC.ar(sig[0], maxdelaytime: 0.02, delaytime: SinOsc.kr(0.3).range(0.003, 0.008));
	chorusR = DelayC.ar(sig[1], maxdelaytime: 0.02, delaytime: SinOsc.kr(0.31).range(0.003, 0.008));

	sig = (sig + [chorusL + chorusR]);

	sig = Pan2.ar(sig, \pan.kr(0));

	Out.ar(out, sig * sendLvl)

}).add;

SynthDef(\reverb, {
        arg inBus, out = 0, mix = 0.5;
        var input = In.ar(inBus, 2);
        var effect = FreeVerb.ar(input, mix, 0.8, 0.2);

        Out.ar(out, effect);
    }).add;


postln("sintes.scd cargado");