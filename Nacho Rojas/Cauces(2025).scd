/*
CAUCES
PIEZA INTERACTIVA
*/

//Ajustes del servidor para el funcionamiento apropiado de los procesos (ejecutar antes de bootear el servidor)



/////////////////
////SECCIÓN 1////
/////////////////


//SINTETIZADOR: Este SynthDef define los parámetros del sintetizador que responderá a la guitarra por medio de un detector de ataques.
(
SynthDef(\sinteA,
	{
	arg freq = 440, amp = 0.5, decay = -10, coef = 0.3, out =0, periodo = 1, pan = 0;
		var sig, env= Env([0,1,0.3,0],[0.01,1,4]);
		sig = Saw.ar(freq);
		sig=RLPF.ar(sig,LFDNoise1.kr(3,500,800),0.9,);
		sig=FreeVerb.ar(sig,0.5,0.9,0.7);
		env=EnvGen.kr(env,doneAction:2);

	Out.ar(out, Pan2.ar(sig*env,SinOsc.kr(9), amp));

}).add;
)


//DETECTOR DE ATAQUES: Este SynthDef recibe la señal de la guitarra para activar la respuesta del sintetizador.
(
SynthDef(\ataques, {|in = 0, umbral = 0.5, relax = 1.6, min = 16|
    var inp, onsets, chain, amp, freq, hasFreq;

	inp = SoundIn.ar(0);
    # freq, hasFreq = Tartini.kr(inp,0.93,512,0,1024);
    chain =  FFT(LocalBuf(1024), inp);
    onsets = Onsets.kr(chain, umbral, \rcomplex, relax, 0.1, min);
    SendTrig.kr(onsets, 0, freq);

}).add;
)


//RUTINA 1: Este bloque de código establece las notas que deberá tocar el sintetizador, el tempo y la rutina que mantiene al detector de ataques en funcionamiento.
(
~notasA= [2,4,6,7,11,12] + 81;

t=TempoClock(80/60);

OSCdef(\detectPatt, {arg msg, time, addr, port;
var evitar, escala;
  {  1.do{
		0.5.wait;
		Synth(\sinteA, [\freq,~notasA.choose.midicps])
	}}.fork;
},\tr,s.addr);

~at = Synth(\ataques, [ \umbral, 0.4]);
)

//Liberación de la rutina
~at.free


// GUITARRA: Este SynthDef recibe la señal de la guitarra y la envía hacia la salida de audio con reverberación.
(
SynthDef(\guitarra, {
	arg amp=1.5, gate=1, select=0 ;
	var input=0, input2, sig, env;

	input = SoundIn.ar(0,amp);
	input=FreeVerb.ar(input,0.3,0.6);
	input2=input.wrap*0.2;
	sig=SelectX.ar(select, [input, input2]);
	env=EnvGen.ar(Env.asr(0.1, 1), gate);
	Out.ar([0,1], input*env)

}).add;
)
c=Synth(\guitarra)
//La variable Select modula el Dry/Wet de la reverberación.
c.set(\select,0.2)


//PERCUSIÓN LIMPIA: Este SynthDef recibe la señal de las percusiones y la envía a la salida con reverberación y paneo.
(
SynthDef(\perc, {
	arg amp=0.5, gate=1 ;
	var input, env;
	input = SoundIn.ar(1,amp);
	input=FreeVerb.ar(input,0.3,0.6);
	env=EnvGen.ar(Env.asr(0.1, 1), gate);
	Out.ar(0, Pan2.ar(input*env, LFDNoise1.ar(1/3, 1, 0)))
}).add;
)

d=Synth(\perc)


//PERCUSIÓN PROCESADA: Este SynthDef procesa la señal de la percusión por medio de un granulador, pitchshift, delay y paneo. Algunos prámetros del proceso de granulación y delay son modulados con MouseX y MouseY.
(
SynthDef(\gran,
	{
		arg gate=1, prat=1, pdisp=1, tdisp=0.2, dectime=2, amp=0.8, velPan=0.5;
		var signal, env, salida, mezcla;
		signal = GrainIn.ar(2, LFPulse.kr(220), MouseX.kr(0.9,0.1),SoundIn.ar(1),LFTri.kr(1),-1);
		signal= CombC.ar(signal, 1, MouseY.kr(0.05, 0.5), MouseX.kr(0.1,15),1);
		signal=PitchShift.ar(signal,0.5,prat,pdisp,tdisp,amp);
		mezcla=Mix(signal);
		env= EnvGen.ar(Env.asr(1,1,1), gate);
		salida= Out.ar(0, Pan2.ar(mezcla*env, LFDNoise1.ar(velPan, 1, 0)));
	}
).add;
)

b=Synth(\gran)
//Modulación de parámetros del pitchshift, delay y paneo.
b.set(\prat,3);
b.set(\pdisp,0);
b.set(\tdisp,0.5);
b.set(\dectime,3);
b.set(\velPan,0.3);

b.release


////////////////////////
////FIN DE SECCIÓN 1////
////////////////////////


/////////////////
////SECCIÓN 2////
/////////////////


//SynthDef de intetizador KPS con entrada de guitarra como señal de excitación.
(
SynthDef(\kps,
	{
	arg freq = 440, amp = 1.5, decay = -10, coef = 0.3, out =0, periodo = 1, pan = 0;
		var sig,env;
		sig = Pluck.ar(SoundIn.ar,1,1/50, freq.reciprocal,decay,coef);
		//sig=Disintegrator.ar(sig,SinOsc.kr(0.9,mul:0.1,add:0),0);
		sig=RLPF.ar(sig,1400,0.9);
		//sig=FreeVerb.ar(sig,0.3,0.4);
		env=EnvGen.kr(Env.perc(0.5,0.9),doneAction:2);
	Out.ar(out, Pan2.ar(sig*env,SinOsc.kr(7), amp));
}).add;
)

//RUTINA 2: Nuevas notas para el nuevo sintetizador, tempo y rutina (con el mismo funcionamiento que la de la primera sección).
(
~notasB= [2,11,12,4,9] + 76;

t=TempoClock(80/60);

OSCdef(\detectPatt, {arg msg, time, addr, port;
var evitar, escala;

  {  1.do{
		0.5.wait;
		Synth(\kps, [\freq,~notasB.choose.midicps])
	}}.fork;
},\tr,s.addr);

~at =  Synth(\ataques, [ \umbral, 0.2]);
)

~at.free

////////////////////////
////FIN DE SECCIÓN 2////
////////////////////////


