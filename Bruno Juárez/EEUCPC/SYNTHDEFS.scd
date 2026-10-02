//////////////////SYNTHDEFS//////////////////////////
SynthDef(\rapeo,{arg in=0, amp=1, bfn=0;
	var sig, rec;
	sig=SoundIn.ar(in);
	rec=RecordBuf.ar(sig, bfn, doneAction:0);
}).add;
SynthDef(\hiphop,{arg buf=0, amp=0.5, rat=1, trg=1;
	var sig, env;
	sig=PlayBuf.ar(1,buf, (BufSampleRate.kr(buf)/s.sampleRate)*rat, trg, loop:1);
	env=EnvGen.kr(Env.linen(0.1, 11.9,4,amp),doneAction:2);
	Out.ar(0, sig!2*env);
}).add;
SynthDef(\metro,{arg buf=0, amp=0.5, rat=1, trg=1, gato;
	var sig;
	sig=PlayBuf.ar(1,buf, (BufSampleRate.kr(buf)/s.sampleRate)*rat, trg, doneAction:2);
	SendTrig.kr(gato, 3);
	Out.ar(0, sig!2*amp);
}).add;
SynthDef(\pulso, {arg mul = 0.5, buf=512,inpt=0, sens=0.4;
	var sig, puls;
	sig =FFT(LocalBuf(buf), SoundIn.ar(inpt, mul));
	puls = Onsets.kr(sig, sens);
	SendTrig.kr(puls, 0, 1);
}).add;
SynthDef(\recorder, { arg in, bfn;
	var si;
	si=SoundIn.ar(in, 1);
	RecordBuf.ar(si, bfn);
}).add;
SynthDef(\granulito,{arg freq, pan, out, bfn, in=0, rt, ini, dgr, ampi, amp;
	var sig, imp, fll, asi;
	sig=SoundIn.ar(in, 1);
	fll=Amplitude.kr(sig);
	imp=Impulse.kr(freq*fll*ampi);
	asi=TGrains.ar(2, imp, bfn, rt, ini, dgr,pan,0.1);
	Out.ar(out, asi*4*amp);
}).add;
SynthDef(\shift, {arg out = 0, fpan, wz=1, amp, pR, pD,tD, cual, frac = 1;
	var in, am, pit, pan, aeme, fqm;
	in= SoundIn.ar(0, 6);
	pit= PitchShift.ar(in, wz, pR, pD, tD, 1);
	fqm=Pitch.kr(in, 440,100, 2000)*frac;
	aeme= in*SinOsc.ar(fqm,0,0.5,0.5);
	pan= PanAz.ar(~bocinas, SelectX.ar(cual, [pit, aeme]), LFNoise0.kr(fpan, 1, 1), amp);
	Out.ar(out, pan);
}).add;
SynthDef(\formantes, {|freq 100, freq1, freq2, freq3, freq4, freq5, amp1, amp2, amp3, amp4, amp5, rq1, rq2, rq3, rq4, rq5, amp|
	var son, env;
	son= BPF.ar(LFSaw.ar(freq, 0, 1), [freq1, freq2, freq3, freq4, freq5], [rq1, rq2, rq3, rq4, rq5], [amp1, amp2, amp3, amp4, amp5]);
	env= EnvGen.kr(Env.perc(0.1, 1, amp, 4),1,doneAction:2);
	Out.ar(32, Pan2.ar(Mix.new(son*env)));
}).add;
///////////////////////////////CHANELS/////////////////////////////////////////////////////////
SynthDef(\voxis, {arg out = 0, fpan=10, wz=1, amp, pR, pD,tD, cual, frac = 1;
	var in, am, pit, pan, aeme, fqm;
	in= SoundIn.ar(0, 1);
	pit= PitchShift.ar(in, wz, pR, pD, XLine.kr(0.01, wz, 60), 1);
	fqm=Pitch.kr(in, 440,100, 2000)*frac;
	aeme= Median.ar(3, in*SinOsc.ar(fqm,0,0.5,0.5));
	pan= PanAz.ar(~bocinas, SelectX.ar(cual, [pit, aeme]), LFNoise0.kr(fpan, 1, 1), amp);
	Out.ar(out, pan);
}).add;
SynthDef(\escucho,{ arg in=0, bfn=0;
	var sig, buf;
	sig=SoundIn.ar(in, 1);
	RecordBuf.ar(sig, bfn, doneAction:0);
}).add;
SynthDef(\reprodusco, {arg out, bfn, pos, vel, trg, ini, mxdt, dt, dct, end=1;
	var sig, del, env, pan, envi;
	envi = EnvGen.kr(Env.perc(0.1, 4.9, 1, 4));
	sig=PlayBuf.ar(1, bfn, (BufSampleRate.kr(bfn)/s.sampleRate)*vel, trg, ini*BufFrames.kr(bfn), 0)*envi;
	del=AllpassC.ar(sig, mxdt, dt, dct, 1);
	pan=PanAz.ar(~bocinas, del, pos, 1);
	env=EnvGen.kr(Env.asr(0.1, 1, 30, 4),end,doneAction:2);
	Out.ar(out, pan*env);
}).add;
SynthDef(\rovoxis,{arg freq=440, out=0, amp=0.5, trg=1, pene=1, temp=60;
	var sig, pan, env;
	sig=SinOsc.ar(freq.round(1), 0,0.25);
	pan=PanAz.ar(2, sig, pene, amp);
	env=EnvGen.kr(Env.linen(1, temp-10, 10), trg, doneAction:2);
	Out.ar(out, pan*env);
}).add;
SynthDef(\detecta, {arg in = 0;
	var inp, ampF;
	inp = SoundIn.ar(in);
	ampF = Amplitude.kr(inp);
	SendTrig.kr(Impulse.kr(5), 2, ampF);
}).add;
SynthDef(\pitchero, {arg in=0, trg;
	var inp, pitch, hasPitch;
	inp=SoundIn.ar(in);
	#pitch, hasPitch=Pitch.kr(inp);
	SendTrig.kr(Impulse.kr(1), 1, pitch);
}).add;

SynthDef(\natura, {arg in=0, out=0, mul=1, trg=0;
	var sig, env, pan;
	sig=SoundIn.ar(in, 6);
	env=EnvGen.kr(Env.asr(1, mul,1),trg, doneAction:2);
	pan=PanAz.ar(2, sig*env);
	Out.ar(out, pan);
}).add;
SynthDef(\chanel,{arg out=40, trg;
	var env, sig;
	sig=In.ar(32, ~bocinas);
	env=EnvGen.kr(Env.adsr(0.1, 0.1, 1, 30, 1), trg, doneAction:2);
	Out.ar(out, sig*env);
}).add;
SynthDef(\chanel1,{arg out=56, trg;
	var env, sig;
	sig=In.ar(48, ~bocinas);
	env=EnvGen.kr(Env.adsr(0.1, 0.1, 1, 30, 1), trg, doneAction:2);
	Out.ar(out, sig*env);
}).add;
SynthDef(\mix,{arg out=0, fue;
	var mix, sig1, sig2;
	sig1=In.ar(40, ~bocinas);
	sig2=In.ar(56, ~bocinas);
	mix= SelectX.ar(fue,[sig1, sig2]);
	Out.ar(out, mix);
}).add;
//////////////////Patrones del mundo///////////////////////////////////////////////////////
~pem = Pmono(\voxis,
	\out, 0,
	\fpan, Pfunc({~fpanv}),
	\wz, 4,
	\amp, -12.dbamp,
	\pR, Pfunc({~pRv}),
	\pD, Pfunc({~cnt}),
	\cual, Pfunc({~cqav}).trace,
	\frac, Pfunc({~fracT})
);