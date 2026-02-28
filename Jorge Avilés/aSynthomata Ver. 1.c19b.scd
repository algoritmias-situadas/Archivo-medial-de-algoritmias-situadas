
/*
Título: aSynthomata Ver. 1.c19b
Compositor: Jorge Avilés

Cada reproducción genera pequeñas variaciones en el resultado final. Por eso se indica el nombre de la versión en el archivo de audio agregando al título (después de la b) los últimos dígitos del archivo generado por collider al hacer la grabación

Este codigo puede compartirse y reutilizarse sin problemas
*/


//Limpieza previa

(
s.freeAll;
s.freeAllBuffers;
)



//////FX y Setups////

(

//Efectos

SynthDef(\dist, {
	|in=0 fmix=0.3 |
	var sig, amp;
	amp=LFNoise1.kr(fmix).range(0.1,0.7);
	sig=In.ar(in,2);
	sig=CrossoverDistortion.ar(sig,LFNoise1.kr(fmix).range(0.05,0.15));
	Out.ar(0,sig*amp);
}).add;


///Buses, y grupos///


~srcGrp = Group.new; //Para las fuentes de audio
~fxGrp= Group.after(~srcGrp);
~distbus=Bus.audio(s,2);
~plus=Array.rand(50,0,81);
//~zeros=Array.zeroFill(5);
~zeros = [0, 0, 0, 0, 0];
~long=Scale.pelog.size;
~dis=Synth(\dist, [\in, ~distbus, \fmix, 10], ~fxGrp);

//Buffers del waveshaper

(
~tfBuf=Buffer.alloc(s,2048);
~tf=Signal.newClear(1025).waveFill({
	|x old i|
	sin(x);
}, -pi/2,pi/2);

~tf=~tf.waveFill({
	|x old i|
	old*((cos(x*0.08)/4)+0.3);
},0,50pi).normalize;
//~tf.plot;
~tfBuf.loadCollection(~tf.asWavetableNoWrap);
);

)



////////Synths///////////////

(

SynthDef(\Karplux, {|midiPitch= 69 art = 1 delay = 1.5, decay = 3 amp=0.8 pan=0.0 bus=0 res=8|
	var burstEnv, att = 0, dec = 0.01, legalPitches;
	var out, delayTime;
	delayTime = [midiPitch, midiPitch + 12].midicps.reciprocal;
	burstEnv = EnvGen.kr(Env.perc(att, dec));
	out = PinkNoise.ar([burstEnv, burstEnv]); //Noise burst
	out = CombL.ar(out, delayTime, delayTime,
		art, add: out); //Echo chamber
	out = RLPF.ar(out, LFNoise1.kr(2, 2000, 2100), 0.1); //Filter
	out=Decimator.ar(out,44100,res);
	out = CombL.ar(out, 4.0, delay, decay, 0.5);
	out=LeakDC.ar(out);
	DetectSilence.ar(out*amp,0.0001, doneAction:2);
	out=PanAz.ar(2,out,pan,width: 5,orientation: 0);
	Out.ar(bus, out*amp);
}).add;

SynthDef(\shaper, {
	|buf=0 freq=250 amp=0.3 out=0 atk=1 sus=0 rel=5 cmax=1|
	var sig, input, curve, env;
	env= EnvGen.kr(Env.linen(atk,sus,rel,1,[-1,0,1]), doneAction:2);
	curve=LFNoise1.kr(0.5!8).bipolar(cmax);
	input=LFTri.ar({freq*Rand(-0.1,0.1).midiratio}!8);
	input=input.lincurve(-1,1-1,1,curve);
	sig=Shaper.ar(buf,input);
	sig=sig*amp*env;
	sig=Splay.ar(sig);
	sig=LeakDC.ar(sig);
	Out.ar(out,sig);
}
).add;

(
SynthDef(
	\suno, {
		|freq=220 atk=0.005 rls=0.3 amp=0.6 pan=0 frk=800 dcy=0.6 mix=0 rm=0 dist=0|
		var sig, env;
		sig=SinOsc.ar(freq+LFTri.ar(frk, mul:200));
		sig=CrossoverDistortion.ar(sig,dist, mul: amp);
		sig=FreeVerb.ar(sig,mix,rm,amp);
		env=EnvGen.kr(Env.new([0,1,0],[atk,rls],[1,-1]),doneAction:2);
		sig=Pan2.ar(sig, pan, amp);
		sig=sig*env*amp;
		Out.ar(0,sig);
	}
).add
);

(
SynthDef.new(\detsaw, {
	arg freq=40, amp = 0.5;
	var temp, suma, env;
	suma=0;
	env = EnvGen.kr(
		Env.perc(0.01, 5, 1, -2),
		doneAction:2
	);
	10.do{
		temp= VarSaw.ar(
			(freq*{Rand(0.99,1,02)}!2),
			{Rand(0.0,1.0)}!2,
			{ExpRand(0.005, 0.05)}!2
		);
		suma = suma+temp;
	};
	//suma=Ringz.ar(suma,(0.5*freq-2*freq.reciprocal), 0.3,0.5);
	suma=CombL.ar(suma,0.5,0.47,0.5);
	suma = suma * 0.05 * env;
	Out.ar(0, suma * amp);
}).add
)

)




///////Pbinds///////////////

(

//Primera sección

~pat1=Pbind(
	\instrument, \shaper,
	\buf, ~tfBuf,
	\degree, Pseq([
		Pseq([[ 20, 21, 12, 4, 9, 13], [ 3,5,10,-3,-5,-10], [-22, -24, -21, 3, -16, 16, -20, 10], [ 6, -10, -10, -2, -10]], 2),
		Pseq([[3, 33, 18, 13, 27, 21], [-24, 16, -31, -1, -9, 6, -19], [34, -7, 16], [ -33, -10, -28, -24, 6, -3], [3, 5, 10]], 1),
		Pseq([[1, 27, 69, 70, 43, -39], [-3, 69, 6, 9, 39, 49], [45, -27, -55, -1, 21, -46, 12, 0, 49, -40, 36,], [-54, 12, -36, 33, -58], [46, 64, 36, 16]], 1),
		Pseq([[15, -52, 48, -41, -44], [ -25, 6, 25, 45],  [6, 53, -14], [3,5,10], [15, 30, 58, 58]], 1),
		Pseq([[-9, 45, -54, 6], [-87, 24, 36, -15, 21,], [46, 47, 40, 31, 9], [ 0, -22, 66, -88], [0, 1, 3, 7, 8]], 2),
		Pxrand([0, 1, 3, 7, 8],5)],1),
	\scale, Pseq([
			Pseq([Scale.chromatic24],10),
			Prand([Scale.diminished,Scale.diminished2],5),
			Prand([Scale.ahirbhairav, Scale.aeolian, Scale.hijaz],5),
			Pseq([Scale.hexAeolian],5),
			Pseq([Scale.pelog],15)],1),
	\root, Pseq([3,5,10],inf),
	\cmax, Pwhite(0.5,2,inf),
	\amp, Pwhite(0.15,0.35, inf),
	\octave, Pseq([5,3,5,4],inf),
	\dur, Pwhite(1,7,inf),
    \legato, Pwhite(0.1, 1.5),
	\strum, Pwhite(0.0, 1.5)
);

~pat2 = Pbind(\instrument, \Karplux,
	\midiPitch, Pseq(~plus,2),
	\root, Pseq([3,5,10],inf),
	\art, Pwhite(0.5,8,inf),
	\amp, Pseq([Pwhite(0.35,0.55, ~plus.size),Pwhite(0.05,0.1,~plus.size)],1),
	\pan, Pwhite(0.00,2.00,inf),
	\dur, Pwhite(0.3,0.7,inf),
	\res, Prand([8,16],inf),
	\delay, Pwhite(1.0,2.0,inf),
	\legato, Pwhite(0.1, 1.5),
	\bus, ~distbus
);

~i1 = Pbindf(~pat2,
	\dur, Pwhite(0.10,0.50,inf),
	\amp,Pwhite(0.05,0.15,inf),
	\res, 32,
	\root, 3,
	\bus, 0);

~i2=Pbindf(~i1,
	\amp, Pwhite(0.11,0.17),
	\res, 16,
	\bus, ~distbus);


///seccion 2

~bain1=Pbind(
			\instrument, \detsaw,
			\dur, Pwrand([1/16, 7/5, 2/4,1/8, 9/8,2/7,1/3],[1/16, 2/16, 2/4,1/8, 5/16,2/7,2/3].normalizeSum,inf),
			\stretch, Pseq([Pseq([((60/120)*3)],5*~long),
				Pseq([((60/100)*3)],5*~long),
				Pseq([((60/60)*3)],10*~long),
				Pseq([((60/30)*3)],~long)], 1),
			\freq, Pseq(
				[Pxrand((Scale.pelog.degrees+69).midicps, 5*~long),
					Pxrand((Scale.pelog.degrees+57).midicps, 5*~long),
					Pxrand((Scale.pelog.degrees+33).midicps, 10*~long),
					Pxrand((Scale.pelog.degrees+21).midicps, ~long)], 1),
			\amp, Pwhite(0.35, 0.75, inf)
);

~bain2=Pbind(
			\instrument, \suno,
			//\dur, Pxrand([1/16, 7/5, 2/4,1/8, 9/8,2/7,1/3, 1/3, 1/3],inf),
			\dur, Pwhite(1/32,17/16, inf),
			\stretch, ((60/120)*3),
			\freq, Pseq(
				[Pxrand(~zeros, 5*~long),
					Pxrand((Scale.pelog.degrees+57).midicps, 30*~long),
					], 1),
			\amp,Pseq(
				[Pxrand(~zeros, 5*~long), Pwhite(0.4, 0.9, inf)], inf),
			//\frk, Pwhite(500,900),
			\pan, Pwhite(-1,1,inf),
			\dist, Pseq(
				[Pxrand(~zeros, 20*~long),Pwhite(0.6,0.9,inf)],inf),
			\mix, Pwrand([0.1,0.2,0.7,0.4],[100,35,80,35].normalizeSum, inf),
			\rm, Pwhite(0.6,0.9,inf)
);

~bain3=Pbind(
	\instrument, \suno,
	\dur, Pwhite(0.001,0.69,inf),
	\freq,  Pseq(
		[Pxrand(~zeros, 26*~long),Pexprand(700,2000, inf)], 1),
	\atk, Pwhite(0.01,3.0,inf),
	\rls, Pwhite(0.7,5.0,inf),
	\amp, Pseq(
		[Pxrand(~zeros, 26*~long),Pexprand(0.3, 0.6, 45*~long),Pseq([0.9],20*~long)],1),
	\pan, Pwhite(-0.9,0.9, inf),
	\dcy, Pwhite(0.10,0.65, inf),
	\frk, Pexprand(40,500, inf),
	\dist, Pseq(
				[Pxrand(~zeros, 46*~long),Pwhite(0.6,0.9,inf)],inf),
	\mix, Pseq(
				[Pxrand(~zeros, 50*~long),Pwhite(0.6,0.7,inf)],inf),
	\rm, Pseq(
				[Pxrand(~zeros, 47*~long),Pwhite(0.6,0.9,inf)],inf)
);

)

//Secuenciación Final

(
~sec1=Ptpar([0, ~i1.finDur(15),15,~i2.finDur(15,0.1),31, ~pat1,31,~pat2],1);
~sec2=Ppar([~bain1, ~bain2, ~bain3],1);

~rola=Pseq([~sec1, ~sec2],1);

~rola.play
)
