/*
Título: Caja Negra (redux)
Compositor: Jorge Avilés
En honor a Mark Fisher
Este codigo puede compartirse y reutilizarse sin problemas

Para realizar las acciones en código solo se necesita posicionarse en cualquier lugar después del primer paréntesis abierto
y dar la combinación de teclas ctrl+enter (cmd+enter en mac)

Órden de ejecución

1. Cambiar la dirección de la variable ~path a la de la carpeta donde el intérprete tenga guardados los samples
2. Dar ctrl+enter en cualquier lugar después de donde se indica (después del primer paréntesis - linea 25 del código)
3. En cuanto se abra el GUI, dar click al boton para que pase al número 1 y cargue los buffers y variables. Dar unos segundos para la carga correcta
4. Cuando se desee comenzar la interpretación dar click para pasar al estado 2 - Sección 1 de la pieza.
5. El cambio a las secciones 2 y 3 podrá hacerlas la máquina de manera aleatoria o el intérprete presionando el botón.
    Las condiciones del uso de botón deben consultarse previamente en las instrucciones para el intérprete adjuntas en pdf.
6. El cambio a la coda y al cierre de la pieza las hará exclusivamente el intérprete utilizando el botón. Para más detalle consulte las instrucciones adjuntas en pdf.
*/

//Limpieza previa

(
//Dar ctrl+enter A PARTIR DE AQUI

s.options.memSize=8192*128;
s.boot;
s.freeAll;
s.freeAllBuffers;
~path = thisProcess.nowExecutingPath.dirname ++ "/Materiales Caja Negra (Redux)_b/Samples/";
//~path = "C:/Users/adess/Documents/ENES/6o Semestre/Composicion VI/Pieza Final/Samples/";
~in = 0;
~out = 0;
)



//SYNTHDEFS Y BUFFERS

(
SynthDef.new(\detsaw, {
	arg freq=40, amp = 0.5, dups=10;
	var temp, suma, env;
	suma=0;
	env = EnvGen.kr(
		Env.perc(0.01, 5, 1, -2),
		doneAction:2
	);
	dups.do{
		temp= VarSaw.ar(
			(freq*{Rand(0.99,1,02)}!2),
			{Rand(0.0,1.0)}!2,
			{ExpRand(0.005, 0.05)}!2
		);
		suma = suma+temp;
	};
	suma=CombL.ar(suma,0.5,0.47,0.5);
	suma = suma * 0.05 * env;
	Out.ar(~out, suma * amp);
}).add;


SynthDef(\cripi, {
	|freq=440 amp=0.5 gate=1,ampMod = 1, modulacion = 1, profMod = 1, maxT = 0.5, dlayT = 0.3, ffilter = 440, ffilter2 = 2000, pos = 0, rq=0.01, velData=1, dur|
	var sig, lfo, dlay;
	sig =SoundIn.ar (~in,2) * 0.1;
	lfo = if(modulacion, SinOsc.ar(ampMod,0, profMod.range(0,0.5), 0.5), 1);
	sig = sig*amp*lfo;
	dlay = DelayC.ar(RLPF.ar(sig,ffilter,rq),maxT,dlayT);
	Out.ar(~out,Pan2.ar([sig,dlay],pos ));
	SendTrig.kr(Impulse.kr(dur.reciprocal), 0, ampMod);
}).add;

SynthDef(\suno, {
	|freq=220 atk=0.005 rls=0.3 amp=0.6 pan=0 frk=800 dcy=0.6 mix=0 rm=0 dist=0|
	var sig, env;
	sig=SinOsc.ar(freq+LFTri.ar(frk, mul:200));
	sig=CrossoverDistortion.ar(sig,dist, mul: amp);
	sig=FreeVerb.ar(sig,mix,rm,amp);
	env=EnvGen.kr(Env.new([0,1,0],[atk,rls],[1,-1]),doneAction:2);
	sig=Pan2.ar(sig, pan, amp);
	sig=sig*env*amp;
	Out.ar(0,sig);
}).add;

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

SynthDef(\shaper, {
	|buf=0 freq=250 amp=0.3 out=0 atk=1 sus=0 rel=2 cmax=1|
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
}).add;

SynthDef(\buf1,{  ///Para samples de 1 canal
	|amp=0.4 buf rate=1 da=2 t_trig=1, start=0, loop=0, mix=0.7, room=0.5, damp=0.7, pos=0|
	var sig;
	sig=PlayBuf.ar(1, buf, BufRateScale.kr(buf)*rate, t_trig, start, loop, da);
	sig=FreeVerb.ar(sig,mix, room,damp, 0.4);
	sig=sig*amp;
	Out.ar(~out,Pan2.ar(sig, pos));
}).add;

SynthDef(\buf2,{  ///Para samples de 2 canales
	|amp=0.4 buf rate=1 da=2 t_trig=1, start=0, loop=0, mix=0.7, room=0.5, damp=0.7, pos=0|
	var sig;
	sig=PlayBuf.ar(2, buf, BufRateScale.kr(buf)*rate, t_trig, start, loop, da);
	sig=FreeVerb.ar(sig,mix, room,damp, 0.4);
	sig=sig*amp;
	Out.ar(~out,Pan2.ar(sig, pos));
}).add;

SynthDef(\bufFisher,{  // Para samples de Fisher (release de 5 segundos por tamaño de
	|amp=0.4 buf rate=1 da=2 t_trig=1, start=0, loop=0, mix=0.7, room=0.5, damp=0.7, pos=0, t_gate=1|
	var sig, env;
	env=EnvGen.kr(Env.asr(0.001,0.7,5),t_gate,doneAction:2);
	sig=PlayBuf.ar(2, buf, BufRateScale.kr(buf)*rate, t_trig, start, loop, da);
	sig=FreeVerb.ar(sig,mix, room,damp, 0.4);
	sig=sig*env*amp;
	Out.ar(~out,PanAz.ar(2,sig,pos));
}).add;
);



//PBINDS

(
~pb1=Pbind(\instrument, \detsaw,
		\freq, Pseq([Pseq([64,66,67,66,64,62,[64,67,62], 47, 45,[67,47,64],[47,45,62]].midicps,1),
		          Pxrand([[64,67,62],[64,47],[66,45,62],67,66,64,62,47,45,[45,47,62]].midicps,inf)],inf),
		\dur, Pseq([Pseq([1, 0.75, 1/4, 1,1/2,1/8,1/4,1/4,1],inf),Prand([1/2,1/4,1/3,1/8,0.85],inf)],inf),
		\octave, Pseq([4,5,6,7],inf),
		\amp, Pwhite(0.45,0.7,inf),
		\dups, Pwhite(7,10,inf),
		\legato, Pwhite(0,1.15, inf),
		\strum, Pwhite(0.7,1.23,inf),
		\tempo, Pwhite(1,85/60,inf)
	);


~pb32=Pbind(\instrument, \suno,
	\midinote, Pseq(([[38,45],[36,43],[38,45],[36,43],[34,41],[33,40],[31,38],[33,40]]+rrand(20,26)),inf),
	\dur, 2+rrand(0.01,0.1),
	\amp, Pwhite(0.4,0.777,inf),
	\dist, 0.07,
	\rls, Pwhite(0.2,07,inf),
	\frk, Pwhite(500,1000,inf),
	\rm, Pwhite(0.3,0.5,inf),
	\mix, Pwhite(0.3,0.7,inf),
	\strum, Pwhite(0.3,1.5,inf),
	\tempo, 50/60,
	\pan, Pwhite(-1,1,inf)
);

);




//PIEZA

~procesos = [{"Da click para iniciar la carga".postln;},
	{
		"Cargando".postln;
		//Variables globales, valores iniciales
		(
			~srcGrp = Group.new; //Para las fuentes de audio
			~sampGrp= Group.after(~srcGrp); //Para los samples de fisher
			~shap=Group.after(~sampGrp);
			~thresFreq = 1350;
			~c = 0;
		);
\___.postln;
		~b0=Array.new;
		~folder=PathName.new(~path ++"FisherJD");
		~folder.entries.do({
			arg path;
			~b0=~b0.add(Buffer.read(s,path.fullPath));
			});
\___.postln;
		~b1=Array.new;
		~fold1=PathName.new(~path ++"FisherDB");
		~fold1.entries.do({
				arg path;
				~b1=~b1.add(Buffer.read(s,path.fullPath));
			});
\___.postln;
		~b2=Array.new;
		~fold2=PathName.new(~path ++"drum");
		~fold2.entries.do({
				arg path;
				~b2=~b2.add(Buffer.read(s,path.fullPath));
			});
\___.postln;
		~b3=Array.new;
		~fold3=PathName.new(~path ++"glitch");
		~fold3.entries.do({
				arg path;
				~b3=~b3.add(Buffer.read(s,path.fullPath));
			});
\___.postln;
		~b4=Array.new;
		~fold4=PathName.new(~path ++"bass1");
		~fold4.entries.do({
				arg path;
				~b4=~b4.add(Buffer.read(s,path.fullPath));
			});
\___.postln;
		~b5=Array.new;
		~fold5=PathName.new(~path ++"FisherRC");
		~fold5.entries.do({
				arg path;
				~b5=~b5.add(Buffer.read(s,path.fullPath));
			});
\___.postln;
		~b6=Array.new;
		~fold6=PathName.new(~path ++"Coda");
		~fold6.entries.do({
				arg path;
				~b6=~b6.add(Buffer.read(s,path.fullPath));
			});
\___.postln;



	~pbd1=Pbind(\instrument, \buf1,
	\buf, Pwhite(~b2[0].bufnum,~b2[~b2.size-1].bufnum,inf),
	\dur, 0.25,
	\tempo, 180/60,
	\room, 0.2,
	\mix, 0.1,
	\amp, Pseq(([1, 0 ,0, 0, 1,0,0,0, 1,0,0.1, 1,0,0,0])*rrand(1.1,1.2),inf),
	\pos, Pwhite(-1,1,inf)
	);
\___.postln;
~pbd2=Pbind(\instrument, \buf1,
	\buf, Pwhite(~b3[0].bufnum,~b3[~b3.size-1].bufnum,inf),
	\dur, 0.25,
	\tempo, 180/60,
	\room, 0.2,
	\mix, 0.1,
	\amp, Pseq([0.95, 0 ,0.95, 0,   0,0.95,0,0.95,   0,1,1,0,    0.95,0,0.95,0]*rrand(1.1,1.22),inf),
	\pos, Pwhite(-1,1,inf)
	);
\___.postln;
~pbd3=Pbind(\instrument, \buf1,
	\buf, Pwhite(~b4[0].bufnum,~b4[~b4.size-1].bufnum,inf),
			\dur, Pseq([Pseq([Rest(90)],1),Pseq([2,2.5],80),Pxrand([1,0.75,1.25,0.5],inf)],inf),
	\tempo, 180/60,
	\room, 0.1,
	\mix,0.1,
	\rate, Pwhite(0.9, 1.5,inf),
	\amp, Pseq([0.95, 0 ,0.7, 0,   0,0.55,0,0.85,   0,0,1,0,    0.65,0,0.75,0],inf),
	\pos, Pwhite(-1,1,inf),
	\target, ~sampGrp
	);
\___.postln;
~pb31=Pbind(\instrument, \shaper,
		\buf, ~tfBuf,
		\dur, 2,
		\amp, Pwhite(0.65,0.777,inf),
		\midinote, Pseq(([[38,41,45,48],[36,40,43],[38,41,45,48],[36,40,43],[34,38,41,43],[33,36,40,43],[31,34,38,41],[33,37,40,43]]+rrand(-4,2)),inf),
		\legato, Pwhite(0.3,1.5,inf),
		\rel, Pseq([1.85,1.7,1.7,1.7,1.7,1.7,1.7,1.7],inf),
		\tempo, 50/60,
	\target, ~shap
);
\___.postln;
~pbcd=Pbind(\instrument, \bufFisher,
	\buf, Pseq([Pwhite(~b6[0].bufnum,~b6[~b6.size-1].bufnum,20),
				Pxrand([~b6[~b6.size-1].bufnum,
					            ~b6[~b6.size-2].bufnum,
					            ~b6[~b6.size-3].bufnum,
					            ~b6[~b6.size-3].bufnum,
					            ~b6[~b6.size-3].bufnum],inf)
			],inf),
	\dur, Pseq([Pseq([Rest(10)],1),Pseq([1.5,2.5],40),Pxrand([0.25,0.35],inf)],inf),
	\tempo, 60/60,
	\room, 0.1,
	\mix,0.1,
	\rate, Pwhite(0.8, 1.2,inf),
	\amp, Pseq([Pwhite(0.9,1.1,40),Pwhite(1.1,1.3,inf)],1),
	\pos, Pwhite(-1,1,inf),
	\target, ~sampGrp
	);
\___.postln;
	~b0Min=0;
	~b0Max=~b0.size-1;
	~b1Min=0;
	~b1Max=~b1.size-1;
	~b5Min=0;
	~b5Max=~b5.size-1;

"Ya Cargué".postln;
},


	///PRIMERA SECCIÓN

	"PRIMERA SECCIÓN".postln;

	{
		~pm1 = Pmono( \cripi,
			\ampMod, Pfunc{rrand(200,2000)},
			\profMod,Pfunc{rrand(0.5,10)},
			\dlayT,Pfunc{rrand(0.01,0.7)},
			\maxT,Pfunc{rrand(1,5)},
			\ffilter, Pfunc{rrand(40,700)},
			\rq, 0.1,
			//\llave, Pfunc{|e| e.postln},
			\dur, Pfunc{rrand(0.5,4)},
			\amp, Pfunc{rrand(0.1,0.3)},
			\velData, Pfunc(rrand(0.2,1)),
			\group, ~srcGrp
		);
	~ej0 = ~pm1.play;
	~ej1 = ~pb1.play; // detSaw
	OSCdef(\escuchador, {
	|msg, time, addr, recvPort|
	msg[3].postln;
	if(msg[3]>= ~thresFreq){

				a = rrand(~b0Min, ~b0Max);
				f=~b0[a];
				x=Synth(\bufFisher, [\buf, f.bufnum, \amp, 1.2, \rate, 1.02, \mix, 0.1], ~sampGrp);

				~c = ~c + 1;
				~c.postln;
			};
			if(~c == 50){
				{b.valueAction = 3}.fork(AppClock);
				~c = 0;
				~pb1.stop;
				~listen.free;
				~sampGrp.freeAll;
				};
		},'/tr', s.addr );
	},

	{

	////SEGUNDA SECCION

	"SEGUNDA SECCIÓN".postln;
    ~ej0.stop; ~srcGrp.freeAll;
	~ej1.stop; // apagar lo anterior;
	OSCdef(\escuchador).clear;

	~thresFreq = 5000;
	~c = 0;
	~pp=Pmono(\cripi, \ampMod, Pwhite(2000,10000,inf));
	~pm2=~pp<>~pm1;
	~ej2=~pm2.play;
	~ej3=~pbd1.play;
	 ~ej4=~pbd2.play;
	~ej5=~pbd3.play;


	OSCdef(\escucha2, {
	|msg, time, addr, recvPort|
	msg[3].postln;

		if(msg[3]>=~thresFreq){
			a = rrand(~b1Min, ~b1Max);
				f=~b1[a];
				x=Synth(\bufFisher, [\buf, f.bufnum, \amp, 1.75, \room, 0.1, \mix, 0.3, \rate, 0.7], ~sampGrp);

				~c = ~c + 1;
				~c.postln;
			};
			if(~c>=45)
			{
				//Disparar el bajo
				~ej5.stop;
			};
			if(~c>=48)
			{
				//Disparar el bajo
				~ej4.stop;
			};
			if(~c==50){
				{b.valueAction = 4}.fork(AppClock);
			~c = 0;
				};
	},'/tr', s.addr );
Server
		},
	{

		//TERCERA SECCION

		"TERCERA SECCIÓN".postln;
		~ej2.stop; ~srcGrp.freeAll;
		~ej3.stop;
		~ej4.stop;
		~ej5.stop; ~sampGrp.freeAll;
		OSCdef(\escucha2).clear;


		~thresFreq = 300;
		~c = 0;
		~pp2=Pmono(\cripi, \ampMod, Pwhite(20,500,inf), \amp, Pwhite(0.05,0.1,inf));
	    ~pm3=~pp2<>~pm1;

		~ej6=~pb31.play;
		~ej7=~pb32.play(quant: 4);
		~ej8=~pm3.play;
		OSCdef(\escucha3, {
			|msg, time, addr, recvPort|
			msg[3].postln;
			if(msg[3]>=~thresFreq){
			a = rrand(~b5Min, ~b5Max);
				f=~b5[a];
				x=Synth(\bufFisher, [\buf, f.bufnum, \amp, 1.75, \room, 0.1, \mix, 0.3, \rate, 1], ~sampGrp);
			};
		},'/tr', s.addr );


	},
	{

		//CODA SUICIDA

		"CODA SUICIDA".postln;
		OSCdef(\escucha3).clear;
		~threshFreq=100000;~c=0;
		~ej8=~pm3.stop; ~srcGrp.freeAll;
		~ej6.stop; ~shap.freeAll;
		OSCdef(\escucha3).clear;
		~ej9=~pbcd.play
	},
	{
		//Apagar procesos activos (similar a lo que aparece en tercera sección.
		~ej7.stop;
		~ej9.stop; ~sampGrp.freeAll;
	}

];



//GUI


w=Window(\Caja_Negra,  Rect(396.0, 179.0, 290.0, 305.0));
w.background=Color.black;
w.alpha=0.8;
b= Button(w, Rect(100, 100, 100, 100));
b.states_(~procesos.size.collect{|x|
	[x.asString,Color.black,Color.rand]}).action_({ |v| ~procesos[v.value].value});

w.front;


w.onClose = {
	~listen.free;
	Pbindef(\x).stop;
	s.freeAll;
	\Apagado.postln;
	Buffer.freeAll;
};
)