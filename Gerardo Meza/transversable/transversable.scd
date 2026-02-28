/*

TRANSVERSABLE

Gerardo Meza

Revision: 1 de febrero 2026
SC version: SUperCollider 3.13
*/

/*

requiere la instalación de la clase Chronometer y newTimeString
para instalar:
SuperCollider > Extensions > clase
Recompilar la librería de SC

*/

//solo queda remplazar los sintes por el pbind tocador de versiones pasadas
//mayor control de volumentes
//freqshit cambiar tonica
//panFM?

s.sendBundle(nil, [\error, 0]);

// MIDI
MIDIClient.init;
MIDIIn.connectAll;
//MIDIIn.disconnectAll;


//variables globales
~t= TempoClock(80/60);
~samplerate = 48000;
~panVel = 20;
~fmAmp = 0.3;
~brakeAmp = 0.3;
~microvol = 0.5;
~amp = 1;
~contador = 0;
~gateAnterior = 0;
~volSpec = ControlSpec(0, 1.0, 'lin', 0.005, -inf, 'amp');
~gateSpec = ControlSpec(0, 1.0, 'lin', 0.005, 0.4, 'compuerta');
~panSpec =ControlSpec(10, 100, 'exp', 1, 20, 'hz');
~gate = 1;
//~mic = [0,1]; //estereo
~mic = 0; //mono
~audios1 = [];
~audios2 = [];
~folder1 = PathName(thisProcess.nowExecutingPath.dirname+/+"/bdrum");
~folder2 = PathName(thisProcess.nowExecutingPath.dirname+/+"/VERSUS_INTER");
~foldergrava = "/Users/gerardomeza/Desktop/VERSUS_INTER/";

/// carga de archivos de audio
(
~folder1.entries.do({
	arg path;
	~audios1= ~audios1.add(Buffer.read(s, path.fullPath));
})
);

(
~folder2.entries.do({
	arg path;
	~audios2= ~audios2.add(Buffer.read(s, path.fullPath));
})
);


// Buffers
~codaBuf = Buffer.alloc(s,~samplerate*50,2);
~soloBuf = Buffer.alloc(s,~samplerate*42,2);
~soloBuf2 = Buffer.alloc(s,~samplerate*20,2);
~record = Buffer.alloc(s,~samplerate*450,2);



//SynthDefs
g= ();
///syntes

SynthDef(\micRec,{
	|in = 0, out = 0, bufnum, gate= 1|
	var sig, input, env;
	env= EnvGen.kr(Env.asr(0.01,1,1),gate, doneAction:2);
	input = SoundIn.ar(~mic)!2;//, ~microvol);
	sig = RecordBuf.ar(input,bufnum,loop:0,doneAction:2);
	Out.kr(0,sig * env);
}).add;

//a = Synth(\micRec,[\bufnum,~soloBuf.bufnum])
~soloBuf.plot;

// detectores



/*
SynthDef(\detectaAmps, {|in = 0, umbral = 0.5|
	var inp, onsets, chain, amp, pich, hasPich;
	inp = SoundIn.ar(in); // entrada de audio
	amp  = Amplitude.kr(inp, 0.01, 1); // detector de amplitud
	SendReply.kr(Impulse.kr(20), '/amplis', amp);
}).add;
*/


SynthDef(\escuchador, {
	arg amp=1, out=0, rate=1, bufnum, gate=1, startPos = 1, mix = 0, room =0, damp = 0;
	var sig, env, input, inputAmp, compuerta, threshold;
	input = SoundIn.ar(~mic);
	inputAmp = (Amplitude.kr(input)* 100);
	//threshold = ~gate;
	//compuerta = Lag.kr(inputAmp > threshold, 1);
	SendTrig.kr(Impulse.kr(10),0,inputAmp);
}).add;



SynthDef(\amplis, {
	var in = SoundIn.ar(~mic);
	var ampl;
	ampl = Amplitude.kr(in, 0.001, 0.001, 1);
	SendTrig.kr(Impulse.kr(10), 0,ampl);
}).add;



SynthDef("fm1", { arg out = 0, freq = 440, carPartial = 1, modPartial = 1, index = 3, mul = 0.05, atk = 0.01,sus = 0.25,rel = 1, gate =1, pos = 0, amp = 0.3, panvel = 20;
	var mod, car, env;

	mod = SinOsc.ar(freq * modPartial, 0, freq * index * LFNoise1.kr(5.reciprocal).abs);
	car = SinOsc.ar((freq * carPartial) + mod, 0, mul);
	env = EnvGen.kr(Env.perc(atk,1), doneAction: Done.freeSelf);
	Out.ar(out,Pan2.ar(car* env * amp,LFNoise2.kr(panvel)))
}).add;

//f = Synth("fm1");



SynthDef(\electroSolo, {
	arg out = 0, bufnum, ratio =3,rate =1 ,pan = -1, end = 1,dur =1, amp = 0.01, panvel = 20;
	var sig, prc;
	sig = PlayBuf.ar(2, bufnum,rate,startPos:0,doneAction:2);
	prc = PitchShift.ar(sig,0.2,ratio,0,0);
	prc = prc * amp;
	Out.ar( out,Pan2.ar(prc,LFNoise2.kr(panvel)))
}).add;

SynthDef(\electroCoda, {
	arg out = 0, bufnum, ratio =3,rate =1 ,pan = 0, ffreq = 0, start = 0, end = 0, dur = 0,famp = 1, bw= 2, amp = 0.01, gate = 1, panvel = 20;
	var sig, prc, filt, env;
	env= EnvGen.kr(Env.asr(0.01,1,1),gate, doneAction:2);
	sig = PlayBuf.ar(2, bufnum,rate,startPos:0,doneAction:2);
	prc = PitchShift.ar(sig,0.2,ratio,0,0);
	filt = BBandPass.ar(prc,ffreq,XLine.kr(start,end,dur),famp);
	filt = GVerb.ar(filt);
	filt = filt * amp * env;
	Out.ar( out,Pan2.ar(filt,LFNoise2.kr(panvel))) /// paneoo
}).add;

SynthDef(\pleyer, {
	arg amp=1, out=0, rate=1, bufnum, gate=1, startPos = 1, mix = 0, room =0, damp = 0, loop = 0, dens = 1;
	var sig, env, trig, amp1 , input;
	input = SoundIn.ar(~mic);
	trig = Blip.kr(dens);
	env = EnvGen.kr(Env.asr(0.01,1,0.5),gate, doneAction:2);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * rate,dens,startPos,loop:loop, doneAction:2);
	sig = sig * env * amp;
	Out.ar(out, FreeVerb.ar(sig, mix, room, damp));

}).add;

//patrones

~p3 =Pbind(\instrument, \pleyer,
	\bufnum, Pxrand((0..11),inf),
	\rate, Pxrand([4,5,6,7,8,9,10],inf),
	\dur,0.166,
	\amp,Pfunc{~brakeAmp},
);


~p1 =Pbind(\instrument, \pleyer,
	\pfunc,Ptime.new.trace,
	\bufnum, Pxrand((0..11),inf),
	\rate, Pxrand([4,5,6,7,8,9,10,13,14,15,16],inf),
	\dur,Pif(Pkey(\pfunc)>5,
		Pseries(0.1,0.01,60),//frenado no tan abrupto
		0.5),
	\amp,Pfunc{~brakeAmp},
	//dens,Env([1,40],10,\exp)
);


~p2 = Pbind(\instrument,"fm1",
	\freq,
		Pseq([
		Pwhite(800,3000,5),
		Pwhite(5400,18000,5)],20).trace,
		\dur,Pgeom(1,Pbrown(0.5, 1.01, 0.01, inf),15),
	\amp, Pfunc{~fmAmp},
	\panvel, Pfunc{~panVel}
);

//~p1.play


//~fmAmp = 1



// RUTINAS

~rutina = r{|play|
	~t= TempoClock(80/60);
	~v = Synth("fm1",
		[\freq,1000,
			\index,100,
			\freqMod,400,
			\modPart,30000,
			\maxAttack,0.2,
			\reltime,2.5,
			\amp,0.5]);
	2.wait;
	"Patron de Breakdrums (ON)".postln;
	~q = ~p3.play(~t);
	27.wait;
	~q.stop;
	"Patron Breakdrums (OFF)".postln;
};

//~rutina.play;

~r2 =	r {|play|
			"FM detektor on".postln;
			  ~z= Synth(\amplis);
	~osc = OSCdef(\amplix, {|msg,time, addr, recv|
	~amp = msg[3].postln;
},'/tr', s.addr );

		~fm = Pbind(\instrument, "fm1",
		\midinote,Phprand(80,127,inf),
		\atk, Pif(Pkey(\midinote) >100,Pfunc{~amp*10},Pfunc{~amp*100}),
		\dur,Pif(Pkey(\atk) < 1, Pwhite(0.01,0.2),Pwhite(1.0,2)),
		\index, 23,
		\pos,Prand((-1,-0.9..1.0),inf),
		\amp, Pfunc{~amp * ~fmAmp},
		\panvel, Pfunc {~panVel}
	).play;
};

//~r2.play

~coda = r {|play|
	~codah= Synth(\electroCoda,[\bufnum,~codaBuf.bufnum,\ffreq, 10000,\start,0.001,\end,4,\dur,20, \famp,5]);
		25.wait;
	"25 segundos".postln;
		~codah2 =Synth(\electroCoda,[\bufnum,~codaBuf.bufnum,\ffreq, 12000,\start,0.001,\end,1,\dur,20, \famp,5, \rate,2, \ratio, 4]);
	~q = ~p3.play;
	23.wait;
	~q.stop;
};



/*
~pasado =Pbind(\instrument, \pleyer,
	\bufnum,Pxrand(~audios2,1).trace,
	\dur,10,
	\amp,0.7,
);

*/
//~pasado.play


///Pocesos de la pieza


~procesos = [
	{},
	{
		"Proceso de grabación (ON)".postln;
		~e = Synth(\micRec,[\bufnum, ~codaBuf.bufnum])},
	{
		"Proceso de grabación (OFF)".postln;
		~e.set(\gate,0);
		"Proceso de escucha (ON)".postln;
		~x = Synth(\escuchador);
		r = OSCdef(\flat, {|msg,time, addr, recv|
			if ( (~gateAnterior == false) and: (msg[3] >= ~gate)) {
				~contador = ~contador + 1;
				if (~contador == 10) {
					"cotnador 190".postln;
					p = ~p2.play;};
				if (~contador == 15){
					q = ~p1.play;};
				if (~contador == 20) {
					p.stop;
					~contador = 0;};
			};

			[~contador, ~gateAnterior].postln;

	~gateAnterior = msg[3] >= ~gate;

	},'/tr', s.addr);},
	{
		"Proceso de escucha (OFF)".postln;
		~x.free;
		r.stop;
		p.stop;
		q.stop;
		~contador = 0;
	"Proceso de grabación (ON)".postln;
	~e = Synth(\micRec,[\bufnum, ~soloBuf.bufnum]);

	},
	{
		"Proceso de grabación (OFF)".postln;
		"Sintetizador FM responde según amp de entrada".postln;
		~r2.play;
		~e.set(\gate,0);
	},
	{
		~fm.stop;
		~z.free;
		~osc.free;
		"Proceso de grabación (ON)".postln;
		~e = Synth(\micRec,[\bufnum, ~soloBuf2.bufnum]);
		~soloBuf2.play;

	},
	{

		"Proceso de grabación (OFF)".postln;
		"Electronica solo, trepale al fader".postln;
		~e.set(\gate,0);
		~solo = Synth(\electroSolo,[\bufnum,~soloBuf.bufnum,\ratio,4,\rate,2]);
		~solo2 = Synth(\electroSolo,[\bufnum,~soloBuf2.bufnum,\ratio,2,\rate,1]);
	},
	{
		" FIN Electronica solo".postln;
		~solo.free;
		~solo2.free;

	},
	{
		~rutina.play;

	},// disparar solo
	{
		~q.stop;
		~coda.play;

	},
	{
		~codah.set(\gate,0);
		~codah2.set(\gate,0);
		~q.stop;
		~update.stop;
	},
	{
		~codaBuf.write(~foldergrava++"transversable_"++Date.getDate.stamp++".wav","wav",'int24');
		//
		"TRANSVERSABLE".postln;
	}

];





///GUI////


~win = Window("Transversable", Rect(869.0, 723.0,574, 312));
~view = CompositeView(~win,Rect(230,75,340,220));
~view.decorator = FlowLayout(~view.bounds);
~view.decorator.gap =6@6;
~fondo = Image.new(
    PathName(thisProcess.nowExecutingPath).pathOnly
	++"/fondo_GUI_transversable.png"
);

//~win.bounds;

~win.view.backgroundImage_(~fondo,11,1,~win);
~view.background_(Color.gray(alpha:0.2));


~cue = StaticText(~win,Rect(240,15,100,20));
~cue.font = Font("Helvetica",20);
~cue.align = \center;
~cue.stringColor = Color.white;
~cue.string = ("CUE");

~boton = Button(~win, Rect(20, 10, 200, 200));
~boton2 = Button(~win, Rect(20, 220, 90, 80));
~boton3 = Button(~win, Rect(420,10, 140,60));




~boton.states = ~procesos.size.collect{|x| [x.asString, Color.white, Color.green(alpha:0.5)]};
~boton.font = Font("Helvetica", 150);
~boton.action = {|b| ~procesos[b.value].value};

~boton2.states = [["GRAVA", Color.rand],[ "STAHP",Color.blue(alpha:0.5)]];
~boton2.font = Font("Helvetica", 20);
~boton2.action = {|b|
	if (b.value == 1)
	{~prix = Synth(\micRec,[\bufnum, ~record.bufnum]);
		"grabando".postln;}
	{
		~prix.free; "ingrabando".postln;
		"Save-mi".postln;
		~record.write(~foldergrava++"prix_"++Date.getDate.stamp++".wav","wav",'int24');
	}
};


~boton3.states = [["PANIC", Color.white,Color.red],["LOL",Color.white,Color.red]];
~boton3.font = Font("Helvetica", 20);
~boton3.action = {|b|
	if (b.value ==1)
		{"jajajaja, Ya valiste madre".postln};
		{}
	};

~volumen = 0;

~fader = EZSlider(~view,60@210,"Solosvol",~volSpec,{
	|ez| ~volumen = ez.value;
	~solo.set(\amp,~volumen);
	~solo2.set(\amp,~volumen);
		~codah.set(\amp,~volumen);
			~codah2.set(\amp,~volumen);


},layout:\vert);

~fader2= EZSlider(~view,60@210,"FMamp",~gateSpec,{
	|ez| ~fmAmp = ez.value;

},0.3,layout:\vert);

~fader4= EZSlider(~view,60@210,"BDamp",~gateSpec,{
	|ez| ~brakeAmp = ez.value;

},0.3,layout:\vert);

~fader3= EZSlider(~view,60@210,"Gate",~gateSpec,{
	|ez| ~gate = ez.value;
	~x.set(\threshold,~gate);
},layout: \vert);

~fader5= EZSlider(~view,60@210,"PanVel",~panSpec,{
	|ez| ~panVel = ez.value;
	~codah.set(\panvel,~panVel);
	~codah2.set(\panvel,~panVel);
	~solo.set(\panvel,~panVel);
	~solo2.set(\panvel,~panVel);

},layout:\vert);

~fader.setColors(stringColor:Color.white,sliderBackground:Color.rand);
~fader3.setColors(stringColor:Color.white,sliderBackground:Color.rand);
~fader2.setColors(stringColor:Color.white,sliderBackground:Color.rand);
~fader4.setColors(stringColor:Color.white,sliderBackground:Color.rand);	~fader5.setColors(stringColor:Color.white,sliderBackground:Color.rand);



~makeTimer = {
	if (~relojito.notNil) { ~relojito.startTime = thisThread.seconds
	}{
		~timer = Chronometer(115,1000,5,"Transversable",600,110);
	};
};
~closeTimer = {~relojito;~win.close; ~relojito = nil;};

~timerB=  Button(~win,Rect(130,220,90,80)).states_([
		["timer", Color.grey(1,1), Color.blue(0.5, 0.5)],
		["timer", Color.grey(1,1), Color.blue(0.9, 0.8)]
	]);
~timerB.font = Font("Helvetica", 30);

~relojito = nil;
~timerB.action_{|v|
	if(v.value ==1) {
		~makeTimer.value;
	}{
		~closeTimer.value;
	};
};


    ~cajatexto =NumberBox(~win, Rect(240,40, 100, 20));
    ~cajatexto.value = (~procesos.size);
    ~cajatexto.action = {arg numb;
	~boton.value = numb.value ; };

//s.plotTree;
s.meter;

~win.onClose = {
	s.freeAll;
	SkipJack.stopAll;
	\saleBye.postln;
};

~win.front.alwaysOnTop_(true);





////// MIDI ////////

MIDIdef.noteOn(\botonCC, {|val, ctr|
[val, ctr].postln;
	if (ctr == 41) { if (val == 127) {
		{~boton.valueAction = ~boton.value + 1}.defer;
	}};
	if (ctr == 73) { if (val == 127) {
		{~boton2.valueAction = (~boton.value)}.defer;
	}};

});



MIDIdef.cc(\faders, {|val, cnum|
	//[\cntl, cnum, val].postln;
	switch(cnum,
		77, {~volumen = val.linlin(0,127,0,1)},
		78, {~fmAmp  = val.linlin(0,127,0,1)},
		79, {~brakeAmp  = val.linlin(0,127,0,1)},
		80, {~gate = val.linlin(0,127,0,1)},
		81,{~panVel = val.linlin(0,127,10,100)}
	);
});




~update = SkipJack(
	{
//		\running.postln;
		~fader.valueAction = ~volumen;
		~fader2.valueAction = ~fmAmp;
		~fader4.valueAction = ~brakeAmp;
		~fader3.valueAction = ~gate;
		~fader5.valueAction = ~panVel;
	}, 0.015, name: "wui"
).play;



