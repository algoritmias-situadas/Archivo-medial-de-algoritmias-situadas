SynthDef(\granulador,{
	| maxDlayTime = 0.2, dlayTime = 0.2, dcyTime = 1, startPos = 0.001, endPos = 2, ttime = 4, dispersion = 2, vel = 10, gdur = 0.1, buf, repVel =1, pos = 0, amp =0.5, t_gate = 1, ventana = -1 , posPan = 0, out = 0, mix = 0.5, room = 0.5, damp = 0.2, disper = 2, modulacion = 0, ampMod = 1, profMod = 1|
	var sig, env, pitch, rate, freq, hasFreq, trig, lfo;

	rate = BufRateScale.kr(buf)* repVel;
	lfo= if(modulacion, SinOsc.ar(ampMod,0, profMod.range(0,0.5), 0.5), 1);
	env = EnvGen.kr(Env([0, 1, 0], [gdur*0.5, gdur*0.5], \lin),t_gate, levelScale: amp, doneAction:2);
	sig = GrainBuf.ar(1, Impulse.ar(vel), gdur, buf, rate, startPos, 2, 0, ventana);
	//#freq, hasFreq= Pitch.kr(sig);
	sig = CombC.ar(sig, maxDlayTime, dlayTime, dcyTime);
	sig = FreeVerb.ar(sig, mix, room, damp);
	//trig = Impulse.kr(100);
//	SendReply.kr(trig, '/pitch', [freq,vel]);
	Out.ar(out, PanAz.ar(~chanOut, Mix(sig* env* lfo), pos, amp,width:disper));
//	Out.ar(out, Pan2.ar(sig* env, pos, amp));

}).add;

//w = Synth(\granulador,[\buf,~fonemas[0].choose,\modulacion,1]);
SynthDef(\player,{
	|rate = 1, buf = 0, start= 0, out = 0, loop = 0, ampMod = 2, profMod = 1, ampModS = 1,ampModE = 20, dur = 3, amp =1,width = 2 modulacion = 0, maxDlayTime = 0, dlayTime = 0, dcyTime= 0,mix = 0, room= 0, damp = 0, pos = 0, gate = 1, rel =2, atk =0.1|
		var input, lfo, sig, env;
	env = EnvGen.kr(Env.asr(atk,amp,rel),gate,doneAction:2);
	lfo= if(modulacion,SinOsc.ar(Line.ar(ampModS,ampModE,dur),0,profMod.range(0,0.5),0.5),1);
		input = PlayBuf.ar(2,buf,BufRateScale.kr(buf)*rate, 1, start, loop, doneAction:2);
		sig = CombC.ar(input, maxDlayTime, dlayTime, dcyTime);
	sig = FreeVerb.ar(sig, mix, room, damp);

	Out.ar(out, PanAz.ar(~chanOut, sig * amp* lfo* env, pos,width:width));
	///Out.ar(out, SplayAz.ar(~chanOut, sig * amp* lfo* env, pos,width:width));

}).add;


SynthDef(\fm,{
	|bus = 0, freq = 440, mRatio = 1, carRatio =1, amp =0.3,atk = 0.01,rel = 3 index = 1, iscale = 5, catk= 4, cRel =(-4)|
	var car, mod, env, indexEnv;
	indexEnv = EnvGen.kr(Env.new([index,index * iscale,index],[atk,rel],catk,cRel));
	env = EnvGen.kr(Env.perc(atk,rel,curve:[catk,cRel]),doneAction:2);
	mod = SinOsc.ar(freq * mRatio,mul:freq * mRatio * indexEnv);
	car = SinOsc.ar(freq * carRatio + mod) *env * amp;
	Out.ar(bus,car);
}).add;




//a =Synth(\fm,[\freq,2000.rand])



SynthDef(\hall, {
	|f1, f2, f3, f4, fund = 106, amp = 0.25, atk= 0.01, sus =1 , rel = 0.4, curv = -4, t_gate = 1 rq = 0.1, voiced = 1, fa1 = 0.025, fa2 = 0.025, out = 0, vibvel = 2, velvib = 2, profvib= 1, dur = 2|
var source, vowel, env, formantesamp,consonantes, vibrato, vocales;

	consonantes = [f1,f2];
	vocales = [f3,f4];
	formantesamp = [fa1,fa2];

	vibrato = SinOsc.ar(velvib ,0,profvib);
	source= if(voiced,Saw.ar(fund+ vibrato),WhiteNoise.ar(0.2)); //ruido
	vowel =Normalizer.ar(BPF.ar(source, Line.kr(consonantes,vocales,dur),rq, formantesamp)* amp);
//	env = EnvGen.kr(Env.asr(atk,amp,rel,curv),t_gate, doneAction:2);
//	vowel = vowel* env;

 Out.ar(out,vowel.dup)
}).add;

//a = Synth(\vocoque,[\bus,~bus]);

SynthDef(\playerB,{
	|rate = 1, buf = 0, start= 0, out = 0, loop = 0, ampMod = 2, profMod = 1, ampModS = 1,ampModE = 20, dur = 3, amp =1,width = 2 modulacion = 0, maxDlayTime = 0, dlayTime = 0, dcyTime= 0,mix = 0, room= 0, damp = 0, rot = 1, gate = 1, rel =2, atk =0.1|
		var input, lfo, sig, env;
	env = EnvGen.kr(Env.asr(atk,amp,rel),gate,doneAction:2);
	lfo= if(modulacion,SinOsc.ar(Line.ar(ampModS,ampModE,dur),0,profMod.range(0,0.5),0.5),1);
	input = PlayBuf.ar(2,buf,BufRateScale.kr(buf)*rate, 1, start, loop, doneAction:2);
	sig = CombC.ar(input, maxDlayTime, dlayTime, dcyTime);
	sig = FreeVerb.ar(sig, mix, room, damp);

	Out.ar(out, PanAz.ar(~chanOut, Mix(input) * amp* lfo* env, SinOsc.ar(rot).range(0,2),width:width));
	///Out.ar(out, SplayAz.ar(~chanOut, sig * amp* lfo* env, pos,width:width));

}).add;