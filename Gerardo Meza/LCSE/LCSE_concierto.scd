//Buffer.freeAll;
//sintes aquí y buffers
// el primer sonido puede ser remplazado en cada interpretación
//aprender de las secciones

"envolventes_fonemas.scd".loadRelative;
s.sendBundle(nil, [\error, 0]);
~m = Archive.at(\ampMatrixLCSE);
~chanOut = 8;
~out = 0;
~improDur = 120;
~improDur2 = 120;
~gAmp = 0;
~maxGsize = 4;
//~composite ={nil}!3;
~position = {0}!8;
~rotacion = {0}!8;
~ampInter = {0.5}!8;
~gSize = {0.1}!8;
~dataCollection = [nil, nil, nil, nil, nil];  //tamaño, posicion, profundidad, amplitud y pitch
~pos = [];
~amp = [];
~revb = [];
~gdur = [];
~pitch = [];
~partes = 4;
~duracion = 120;
~gAmount = 200;
~count = 0;
~mod = 1;
~cuadrantes =[nil,nil,nil,nil];

///carga de archivos de audios
~ruta = thisProcess.nowExecutingPath.dirname;
~folderAnimales = PathName(~ruta ++ "/LosCiborgssonEter/animales/");
~folderFrases = PathName(~ruta ++ "/LosCiborgssonEter/frases/");
~folderFonemas = PathName(~ruta ++ "/consonantes/");

~vocoderBus = Bus.audio(s,1);
~animales = [nil,nil,nil,nil,nil,nil];
~frases = [];
~fonemas = {nil}!11;


~folderAnimales.folders.do({
	arg i, index;
	index.postln;
	i.entries.do{|j| ~animales[index]= ~animales[index].add(Buffer.read(s, j.fullPath));}
});


~folderFonemas.folders.do({
	arg i, index;
	index.postln;
	i.entries.do{|j| ~fonemas[index]= ~fonemas[index].add(Buffer.read(s, j.fullPath));}
});


~folderFrases.entries.do({
	arg path;
	~frases= ~frases.add(Buffer.read(s, path.fullPath));
});

~bus = Bus.audio(s,1);
//~gr1 = Group(s);

////archivos de sonido
~introduccion = Buffer.read(s,thisProcess.nowExecutingPath.dirname +/+"/intro_LCSE.wav");
//~parte2.play;
~parte2 = Buffer.read(s,thisProcess.nowExecutingPath.dirname +/+ "/segundaparte_LCSE.wav");
//~parte2 = Buffer.read(s,thisProcess.nowExecutingPath.dirname +/+ "/segundaparte_LCSE_2_binaural.wav");
~parte3 = Buffer.read(s,thisProcess.nowExecutingPath.dirname +/+"/LosCiborgssonEter/Espacios/selva_lluvia.aif");
~inhChord = Buffer.read(s,thisProcess.nowExecutingPath.dirname +/+"/textura_inhuman3.wav");
//~inhChord.play;
~cajaG = Buffer.read(s,thisProcess.nowExecutingPath.dirname +/+"/cajagolpe.wav");
~keyWings = Buffer.read(s,thisProcess.nowExecutingPath.dirname +/+ "/kewings_butterfly.wav");
~rotacionEsp = Buffer.read(s,thisProcess.nowExecutingPath.dirname +/+"/LCSE_rotacion_pan2.wav");
~mar = Buffer.read(s,thisProcess.nowExecutingPath.dirname +/+"/mar2.wav");

~textura = Buffer.read(s,thisProcess.nowExecutingPath.dirname +/+"/textura_inhuman3.wav");
~b= Buffer.read(s,thisProcess.nowExecutingPath.dirname +/+"/birds.wav");


///// MIDI y synths
"mdi_LCSE.scd".loadRelative;
"SintesLCSE.scd".loadRelative;
"gui_23Dic_LCSE.scd".loadRelative;



/////////funciones//////////////////////
//ten-to-15tn seconds 30 to 36 eventss
//25ms el grano
~secuencia = {
	|seccion = 20, duracion = 100, gAmout = 10 |
	var lista = [];
	q = Array.rand(seccion, 1, 10);
	e = q.normalizeSum;
	e.sum;
	//a = e*100;
	//a.sum;
	a = e * duracion;
	/////
	//a.postln;
	b = a.collect({|i| i.partition3(gAmout.rand, rrand(5,3), 7)});
	//b[11].sum;
	//b.collect({|i| if( i.sum>= 0.01,{lista = lista.add(i)});};);
	//~lista = b.select{|i| i.sum>= 0.01;};
	~lista = b;
};


~fragmentosAudios = {
	|numFrames, sampleRate = 44100|
	var proceso, lista,lista2, secciones;
	//s.sampleRate;
	//numFrames.postln;
	o = ~lista;
	secciones = o.collect(_.size);
	o = o.flat;
	proceso = o.collect{|i| 44100*i};
	lista = proceso.integrate;
	lista2 = lista.normalizeSum;
	lista = lista.clumps(secciones);
	lista2 = lista2.clumps(secciones);
	// se puede recollecar el ultimo item por subarray y agregar al próximo para que los rangos no tengan saltos y la última sección no esté rara...
	lista[0].addFirst(0);
	[lista,lista2]
};


~funcionOperacionesEspacializador = {
	var coordenadas;
	~pos.do{|i,index|~pos.removeAllSuchThat({|j| j == nil})};
	//~pos.removeAllSuchThat({|j| j == nil})};
~reverb = ~revb.linlin(0.0,1.0, 150.0,190.0); //150
~tamano = ~gdur.linlin(0.0,1, 3, 10);
~posicion = ~pos.linlin(0.0, 2.0, 0.0, 40);

	~cuadrantes[0] = ~posicion.collect({|i|if(( i < 4.99999) or: (i >35),{i})});
	~cuadrantes[0].removeAllSuchThat({|i| i == nil});
	~cuadrantes[1] = ~posicion.select({|i| i.inclusivelyBetween(5, 14.99)});
	~cuadrantes[2] = ~posicion.select({|i| i.inclusivelyBetween(15, 24.999)});
	~cuadrantes[3] = ~posicion.select({|i| i.inclusivelyBetween(25, 34.999)});
	~cuadrantesPost = ~cuadrantes.collect{|i| i.size};

	coordenadas = ~posicion / 2pi;
	~color = {Color.rand(0.1,0.9)}!20;
	~a = coordenadas.collect({|i| var x; Polar(~reverb[i], i).rotate(-0.75pi)});

};


~puntos = [nil,nil,nil];

~dibujaPunto = {
	|pos, rev, gdur, color, indx|
	var coordenada, reverb, tamano, posicion, polar, punto;
	if(pos == nil){pos = 0};
	posicion = pos.linlin(0.0, 2.0, 0.0, 40);
	reverb = rev.linlin(0.0,1.0, 150.0,190.0); //150
	tamano = gdur.linlin(0.0,1, 3, 10);
	coordenada = posicion / 2pi;
	punto = Polar(reverb,coordenada).rotate(-0.75pi);
	~puntos[indx] = ~puntos[indx].add(punto);
	~gdur = ~gdur.add(tamano);
	//iteracion
	z.view.drawFunc = {
		Pen.fillColor = color;
		Pen.translate(200,200);
				Pen.moveTo(0@0);
		~puntos[indx].do{|p, i|
			Pen.strokeColor = Color.hsv(~gdur[i], 1, 1, 1);
			//aquí está el error
			Pen.addOval(Rect.aboutPoint(p.asPoint,~gdur[i], ~gdur[i]));
		Pen.fillStroke;
		};
	};
	z.view.refresh;

};


~seccion = {
	|ventana|
	var cuenta ;
	cuenta = 0;
	~cuenta = 0;
	e = ~composite.normalizeSum * (z.comp5[0]).bounds.width;
q = e.collect{|i, index|
		var text, text2;
		b = CompositeView(ventana, Rect(~cuenta, 0, i , 100));
		b.background_(Color.rand);
		text = StaticText(b, Rect(2, 0, b.bounds.width, 20));
		text2 = StaticText(b, Rect(2, 70, b.bounds.width, 30));
		text.font = Font("Arial", 10);
		text2.font = Font("Arial", 15);
		text.string = ~composite[index].round(0.15).asString;
		text2.string = "("++~lista[index].size ++")";

		~x = ~lista[index].normalizeSum * b.bounds.width;
		//~x.size.postln;
		~x.do{|j, index|
			//j.postln;
			//la posición en Y dependera de la amplitud del evento o frecuencia
			c = CompositeView(ventana, Rect(cuenta,50-20.rand, j ,  j));
			c.background_(Color.black);
			cuenta = cuenta + j;
			~count = ~count + j;
		};
	~cuenta = ~cuenta + i;
	//~cuenta.postln;
//	b
};
};

/////
//// Procesos ordenados de la pieza

~procesos = [
	{},
	{
	"Loscibors son éter".postln;
	"comieza cueva con murcielagos".postln;
		d = Synth(\playerB,[\buf,~introduccion, \modulacion, 0, \amp, 0.5,\rot,0.001,\width, 8]);
		//d.free;
		~secuencia.value(~partes,~duracion,rrand(10,100));
		~composite = ~lista.collect(_.sum);
		~seccion.value(z.comp5[0]);
		//~startFrame = ~fragmentosAudios.value(~b.numFrames,~b.sampleRate).flat;
		~startFrame = ~fragmentosAudios.value(~b.numFrames,~b.sampleRate);

},
{
	"operacion de granos y forma".postln;
	w = ~lista.collect(_.sum);
	~lista.size.asString ++ " Secciones; " ++"Duracion: " ++ w.sum++" segundos".postln;

	"Pbind compu con Granos de aves".postln;
		~gr1 = Group(s);

~cont = 0;

~patron = Pn( ///cambiar
	Plazy{
		var patron, contador2;
		//~cont = ~cont + 1;
		//~cont.postln;
		contador2 = 0;

		patron = Pbind(\instrument,\granulador,
					\buf, Pxrand(~animales[2], inf),
		//	\startPos, Pseq(~e,1),
			\startPos, Pfunc{rrand((~startFrame[0][~cont].wrapAt(contador2)),
				(~startFrame[0][~cont].wrapAt(contador2+1)))},
				//.wrapAt(~startFrame[0][~cont].lastIndex)}
			//	.wrapAt(~startFrame[0][~cont].lastIndex)*0.5)},
			\ventana, Prand(~envolventesAmps,inf),
			\mix, Prand((0.01,0.02..1.0),inf),
			\dur, Pseq(~lista[~cont], 1),
			\gdur,Pseq(~lista[~cont], 1),
					\amp, Pfunc{|e| if (e.gdur < 1,{rrand(0.5,1)},{rrand(0.1,0.25)})},
			\pos, Pwhite(0.0,2.0,inf),
			\group, ~gr1,
			//\llave2, Pfunc{~pitch.postln},
			\llave, Pfunc{|e|
				//e.postln;
							{
							~dibujaPunto.value(e.pos,e.mix, e.gdur, Color.cyan,0)}.fork(AppClock);
				~pos = ~pos.add(e.pos);
				~amp = ~amp.add(e.amp);
				~revb = ~revb.add(e.mix);
				~gdur = ~gdur.add(e.gdur);
			},
					\contador , Pfunc{contador2 = contador2 + 1;
						//[~cont, contador2].postln;/
					},
			//\lo, Pfunc{~pos.size.postln;}
		);

		~cont = ~cont + 1;
		patron;

	},
	(~lista.size-1)
).asEventStreamPlayer;
	~patron.play;
},
{       /////////////////////////////////////////////
		///////////////IMPROVISACION 1//////////////
		/////////////////////////////////////////////
		/////////////////////////////////////////////
		~gr1.freeAll;
		~gr = Group();
		r{15.wait;~patron.stop}.play;

		"Improvisación A".postln;
		"Aprox 2 minutos".postln;
		~timer = Chronometer(115,1000,5,"improA", 600, 110);
		~pattern = 6.collect{|i|
			//i.postln;
		Pbind(\instrument,\granulador,
				\buf,Pfunc{~animales[i][0]},
				\tendAmp, Pseg(~maskAmp[1],~maskAmp[0][1..].linlin(0,1,0,~improDur).differentiate),
				\tendDur, Pseg(~maskDur[1].linlin(0,1,0.2,~maxGsize),~maskDur[0][1..].linlin(0,1,0,~improDur).differentiate),
	//\fun, Pfunc{|e| e.r3.postln},
	\gdur, Pfunc{~gSize[i]},
	\amp, Pfunc{|e| ~ampInter[i] * e.tendAmp / 1}.trace,
	\mix, 0,
	\modulacion,1,
				\ampMod, Pfunc{~mod; ~mod.postln},
	\repVel, Pwhite(0.5,2, inf),
	\dur, Pfunc{|e| e.tendDur}.trace,
	\pos,Pfunc{~position[i] + ~rotacion[i]},
			\llave, Pfunc{|e|
				~pos = ~pos.add(e.pos);
				~amp = ~amp.add(e.amp);
				~revb = ~revb.add(e.mix);
				~gdur = ~gdur.add(e.gdur);
		},
		\group, ~gr,
		).asEventStreamPlayer;
	};

	~pattern2 = 6.collect{|i|
	//i.postln;
		Pbind(\instrument,\granulador,
	\buf,Pfunc{~fonemas[0].choose},
	\tendAmp, Pseg(~maskAmp2[1],~maskAmp2[0][1..].linlin(0,1,0,~improDur2).differentiate),
	\tendDur, Pseg(~maskDur2[1].linlin(0,1,0.2,~maxGsize),~maskDur2[0][1..].linlin(0,1,0,~improDur2).differentiate),
	//\fun, Pfunc{|e| e.r3.postln},
	\gdur, Pfunc{~gSize[i]},
	\amp, Pfunc{|e| ~ampInter[i] * e.tendAmp / 1},
	\mix, 0,
	\modulacion,1,
				\ampMod, Pfunc{~mod },
	\dur, Pfunc{|e| e.tendDur},
	\repVel, Pwhite(0.5,2, inf),
	\pos,Pfunc{~position[i] + ~rotacion[i]},
			\llave, Pfunc{|e|
				~pos = ~pos.add(e.pos);
				~amp = ~amp.add(e.amp);
				~revb = ~revb.add(e.mix);
				~gdur = ~gdur.add(e.gdur);
			},
	\group, ~gr,
		).asEventStreamPlayer;
	};

		r{"Ya viene textura".postln;
			120.wait;
			x = (0,2..8).scramble.collect{|i|
				Synth(\player,[\buf,~textura,\modulacion, 0, \amp,0.1,\atk,8,\rel,rrand(5,10.0), \width,6, \pos,2,\out,i,\start,44100*10]);
		};
		20.wait;
			"se modula no esperes a al siguiente paso".postln;
		x.do{|i| i.set(\modulacion,rand(0.5))};

		}.play;
	},
	{
		/////////////////////////////////////////////
		///////////////SELVA/////////////////////////
		/////////////////////////////////////////////
		/////////////////////////////////////////////
		~timer.w.close;
		"selva".postln;
		x.do{|i| i.set(\gate,0)};
		//d = Synth(\player,[\buf,~parte2,\modulacion, 0,\atk, 20,\amp,2]);
		d = (0,2..8).scramble.collect{|i|Synth(\player,[\buf,~parte2,\modulacion, 0, \amp,0.5,\atk, 400,\rel, 10, \width,6, \pos,2,\out,i])};
		~secuencia.value(~partes,~duracion,rrand(10,100));
		~composite= ~lista.collect(_.sum);
		~seccion.value(z.comp5[1]);

~cont = 0;


~patron = Pn( ///cambiar
	Plazy{
		var patron, contador2;
		//~cont = ~cont + 1;
		//~cont.postln;
		contador2 = 0;

		patron = Pbind(\instrument,\granulador,
					\buf,Pfunc{if(~cont <= 2, {[~animales[2],~animales[0]].flatten.choose},{[~fonemas[1],~fonemas[0]].flatten.choose})},
		//	\startPos, Pseq(~e,1),
			/*\startPos, Pfunc{rrand((~startFrame[0][~cont].wrapAt(contador2)),
						(~startFrame[0][~cont].wrapAt(~startFrame[0][~cont].lastIndex)))},*/
			//	.wrapAt(~startFrame[0][~cont].lastIndex)*0.5)},
			\ventana, Prand(~envolventesAmps, inf),
			\mix, Prand((0.01,0.02..1.0),inf),
			//\amp, Pwhite(0.1,1.0, inf),
			\dur, Pseq(~lista[~cont], 1),
			\gdur,Pseq(~lista[~cont], 1),
			\amp, Pfunc{|e| if (e.gdur < 1,{rrand(0.5,1)},{rrand(0.1,0.25)})},
			\pos, Pwhite(0.0,2.0,inf),
			\group, ~gr1,
			//\llave2, Pfunc{~pitch.postln},
			\llave, Pfunc{|e|
				//e.postln;
							{
							~dibujaPunto.value(e.pos,e.mix, e.gdur, Color.magenta,0)}.fork(AppClock);
				~pos = ~pos.add(e.pos);
				~amp = ~amp.add(e.amp);
				~revb = ~revb.add(e.mix);
				~gdur = ~gdur.add(e.gdur);
			},
			\contador , Pfunc{contador2 = contador2 + 1; //contador2.postln;
					},

			//\lo, Pfunc{~pos.size.postln;}
		);

		~cont = ~cont + 1;
		patron;

	},
	~lista.size
).asEventStreamPlayer;
	~patron.play;

	},
{
		/////////////////////////////////////////////
		///////////////IMPROVISACION B//////////////
		/////////////////////////////////////////////
		/////////////////////////////////////////////
		~gr.freeAll;

		"Improvisación B".postln;
		~d = (0,2..8).scramble.collect{|i|Synth(\player,[\buf,~inhChord,\modulacion, 0, \amp, 0.2,\atk, 400,\rel, 10, \width,6, \pos,2,\out,i])};
		~timer = Chronometer(115,1000,5,"improB", 600, 110);


		~gr1.freeAll;
		~gr = Group();
		~pattern = 6.collect{|i|
			//i.postln;
		Pbind(\instrument,\granulador,
				\buf,Pfunc{~animales[i][0]},
				\tendAmp, Pseg(~maskAmp[1],~maskAmp[0][1..].linlin(0,1,0,~improDur).differentiate),
				\tendDur, Pseg(~maskDur[1].linlin(0,1,0.2,~maxGsize),~maskDur[0][1..].linlin(0,1,0,~improDur).differentiate),
	//\fun, Pfunc{|e| e.r3.postln},
	\gdur, Pfunc{~gSize[i]},
	\amp, Pfunc{|e| ~ampInter[i] * e.tendAmp / 1},
	\mix, 0,
	\modulacion,1,
				\ampMod, Pfunc{~mod; //~mod.postln
				},
	\repVel, Pwhite(0.5,2, inf),
	\dur, Pfunc{|e| e.tendDur},
	\pos,Pfunc{~position[i] + ~rotacion[i]},
			\llave, Pfunc{|e|
				~pos = ~pos.add(e.pos);
				~amp = ~amp.add(e.amp);
				~revb = ~revb.add(e.mix);
				~gdur = ~gdur.add(e.gdur);
		},
		\group, ~gr,
		).asEventStreamPlayer;
	};

	~pattern2 = 6.collect{|i|
	//i.postln;
		Pbind(\instrument,\granulador,
	\buf,Pfunc{~fonemas[0].choose},
	\tendAmp, Pseg(~maskAmp2[1],~maskAmp2[0][1..].linlin(0,1,0,~improDur2).differentiate),
	\tendDur, Pseg(~maskDur2[1].linlin(0,1,0.2,~maxGsize),~maskDur2[0][1..].linlin(0,1,0,~improDur2).differentiate),
	//\fun, Pfunc{|e| e.r3.postln},
	\gdur, Pfunc{~gSize[i]},
	\amp, Pfunc{|e| ~ampInter[i] * e.tendAmp / 1},
	\mix, 0,
	\modulacion,1,
				\ampMod, Pfunc{~mod },
	\dur, Pfunc{|e| e.tendDur},
	\repVel, Pwhite(0.5,2, inf),
	\pos,Pfunc{~position[i] + ~rotacion[i]},
			\llave, Pfunc{|e|
				~pos = ~pos.add(e.pos);
				~amp = ~amp.add(e.amp);
				~revb = ~revb.add(e.mix);
				~gdur = ~gdur.add(e.gdur);
			},
	\group, ~gr,
		).asEventStreamPlayer;
	};


	},
	{
		"solo modulacion".postln;
		~d.do{|i|i.set(\modulacion,1); i.set(\loop,1);};
},
{
	     /////////////////////////////////////////////
		///////////////LLUVIA/////////////////////////
		/////////////////////////////////////////////
		/////////////////////////////////////////////
		~gr1.freeAll;
		//~d.free;
		"Lluvia pre climax....espera y dispara".postln;
		~timer.w.close;
		r{
		~q2 = (0,2..8).scramble.collect{|i|Synth(\player,[\buf, ~parte3, \modulacion,0,\rel, 40, \out,i]);};
		~secuencia.value(~partes,~duracion,rrand(10,100));
		~composite = ~lista.collect(_.sum);
		///~seccion.value(z.comp5[2]);
		~q2.do{|i|i.set(\dur, 40)};
		~q2.do{|i|i.set(\modulacion, 1);};
		20.wait;
		~d.do{|i|i.set(\gate,0)};

		}.play;
	},{
		////Climax
		///iteracion de granos
		/// glissandos
		/// paisajes rotando
		"Climax espera los dos PBIND".postln;
		10.collect{
			~iter = ~iter.add(~fonemas[5.rand].choose);
			~iter = ~iter.add(~animales[5.rand].choose);
		};

		10.collect{
			~iter2 = ~iter2.add(~fonemas[5.rand].choose);
			~iter2 = ~iter2.add(~animales[5.rand].choose);
		};

		~acel = 0.1;
		~bufm = [];
		~bufm2 = [];
		~dt = [];
		~dt2 = [];
		~amp = [];
		~amp2 = [];



		////////////////////////////////
		////////////////////////////////
		////////////////////////////////////////////////////////////////
		////////////////////////////////TOCAR//////////////////////////
		~gr = Group();
		~pattern = 6.collect{|i|
			//i.postln;
		Pbind(\instrument,\granulador,
				\buf,Pfunc{~animales[i][0]},
				\tendAmp, Pseg(~maskAmp[1],~maskAmp[0][1..].linlin(0,1,0,~improDur).differentiate),
				\tendDur, Pseg(~maskDur[1].linlin(0,1,0.2,~maxGsize),~maskDur[0][1..].linlin(0,1,0,~improDur).differentiate),
	//\fun, Pfunc{|e| e.r3.postln},
	\gdur, Pfunc{~gSize[i]},
	\amp, Pfunc{|e| ~ampInter[i] * e.tendAmp / 1},
	\mix, 0,
	\modulacion,1,
				\ampMod, Pfunc{~mod; //~mod.postln
				},
	\repVel, Pwhite(0.5,2, inf),
	\dur, Pfunc{|e| e.tendDur},
	\pos,Pfunc{~position[i] + ~rotacion[i]},
			\llave, Pfunc{|e|
				~pos = ~pos.add(e.pos);
				~amp = ~amp.add(e.amp);
				~revb = ~revb.add(e.mix);
				~gdur = ~gdur.add(e.gdur);
		},
		\group, ~gr,
		).asEventStreamPlayer;
	};

	~pattern2 = 6.collect{|i|
	//i.postln;
		Pbind(\instrument,\granulador,
	\buf,Pfunc{~fonemas[0].choose},
	\tendAmp, Pseg(~maskAmp2[1],~maskAmp2[0][1..].linlin(0,1,0,~improDur2).differentiate),
	\tendDur, Pseg(~maskDur2[1].linlin(0,1,0.2,~maxGsize),~maskDur2[0][1..].linlin(0,1,0,~improDur2).differentiate),
	//\fun, Pfunc{|e| e.r3.postln},
	\gdur, Pfunc{~gSize[i]},
	\amp, Pfunc{|e| ~ampInter[i] * e.tendAmp / 1},
	\mix, 0,
	\modulacion,1,
				\ampMod, Pfunc{~mod },
	\dur, Pfunc{|e| e.tendDur},
	\repVel, Pwhite(0.5,2, inf),
	\pos,Pfunc{~position[i] + ~rotacion[i]},
			\llave, Pfunc{|e|
				~pos = ~pos.add(e.pos);
				~amp = ~amp.add(e.amp);
				~revb = ~revb.add(e.mix);
				~gdur = ~gdur.add(e.gdur);
			},
	\group, ~gr,
		).asEventStreamPlayer;
	};


		r{
			~q2.do{|i|i.set(\gate, 0)};
			~d.do{|i|i.free;};
			d = Synth(\player,[\buf, ~cajaG,\modulacion, 0, \amp,1]);
			//l = Synth(\player,[\buf, ~rotacionEsp,\modulacion, 0, \amp,0.5,]);
			d = Synth(\playerB,[\buf, ~rotacionEsp,\modulacion, 0, \amp,0.3, \rot,0.01, \width,8]);

			t = TempoClock(1);
			Task({Array.geom(8,0.1,2).do{|i| t.tempo = i; 10.wait;}}).play;
		~pp=Pbind(\instrument,\granulador,
			\buf, Pshuf(~iter, inf),
			//\ventana, Prand(~envolventesAmps, inf),
			\repVel, Pwhite(1.0,1.5,inf),
			\mix, Prand((0.01,0.02..1.0),inf),
			\amp, Pwhite(0.1,1.0, inf),
				\dur, Pshuf([0.1,0.1,0.3,0.2,0.1,0.1], inf),
			\gdur,Pwhite(0.1,0.7, inf),
			\pos,Pseq((-1,-0.99..2.0),inf),
			\group, ~gr1,
			\modulacion,1,
				\ampMod, Pfunc{~mod; //~mod.postln;
				},
				//la funcionde dibujo retrasa la llegada del pbind

		/*	\llave, Pfunc{|e|
							{~dibujaPunto.value(e.pos,e.mix, e.gdur, Color.cyan,0)}.fork(AppClock);
				/*~pos = ~pos.add(e.pos);
				~amp = ~amp.add(e.amp);
				~revb = ~revb.add(e.mix);
				~gdur = ~gdur.add(e.gdur);*/
			},*/
		/*	\factor, Pfunc{|e|
					~bufm = ~bufm.add(e.buf.bufnum);
					~amp = ~amp.add(e.amp);
					~dt = ~dt.add(Date.getDate.rawSeconds)},
*/
			).asEventStreamPlayer.play(t);

			120.wait;
			"SEGUNDO PBIND  FINAL".postln;
		//// 2 stream mas con distintas trayectorias
		~pp2= 	Pbind(\instrument,\granulador,
			\buf, Pshuf(~iter2, inf),
			\repVel, Pwhite(1.5,2, inf),
			\mix,0.5,
			\room, 1,
			\dlayTime, 1,
			\modulacion,1,
				\ampMod,Pfunc{~mod},
			\amp, Pwhite(0.1,1.0, inf),
			\dur, Pshuf([0.1,0.1,0.3,0.2,0.1,0.1],inf),
			\gdur,Pwhite(0.3,0.7, inf),
			\pos,Pseq((0,0.01..2.0),inf),
			\group, ~gr1,
			/*\llave, Pfunc{|e|
							{~dibujaPunto.value(e.pos,e.mix, e.gdur, Color.cyan,0)}.fork(AppClock);
				/*~pos = ~pos.add(e.pos);
				~amp = ~amp.add(e.amp);
				~revb = ~revb.add(e.mix);
				~gdur = ~gdur.add(e.gdur);*/
			},*/
			/*\factor, Pfunc{|e|
					~bufm2 = ~bufm2.add(e.buf.bufnum);
					~amp = ~amp.add(e.amp);
					~dt = ~dt.add(Date.getDate.rawSeconds)},*/
			).asEventStreamPlayer.play(t);

			60.wait;
			"RMAriposas cuenado estes listo".postln;
		}.play;







	},

	{
		////llaves voladoras
		~k2 = Synth(\playerB,[\buf,~keyWings,\modulacion, 0,\start, 600000,\rel, 20, \rot, 0.1]);
		~k = Synth(\playerB,[\buf, ~keyWings, \modulacion, 0, \start, 600000, \rate, 2, \rot, 0.2]);

	},
	{
////Coda
		///mar


		g = Synth(\playerB,[\buf, ~mar,\modulacion, 0,\start, 1000000,\room, 1, \atk, 410,\rel, 20, \rot,0.001,\width,8]);

		r{10.wait;
		~gr1.free;
		~gr.free;
		~pp2.stop;
		~pp.stop;
		~k2.set(\gate,0);
		~k.set(\gate,0);
		}.play;
	},
{
		"FIN".postln;
		t.stop;
		g.set(\gate,0);

		}

/*
	"procesando birp, burp, barp".postln;
	~storage = [~amp,~pos,~gdur];
	~storage[0];
	~ampR = [nil,nil,nil,nil];
	~rangos = Array.series(5,0,0.25);
	~ampR.do{|i,index|
		~ampR[index] = ~storage[0].select{|j|
			j.inclusivelyBetween(~rangos[index],~rangos[index+ 1])};

	};
	~ampR.do{|i| if(i.isEmpty,{i.add(1)})};

	~y = ~ampR.collect{|i| i.size};
	~ampR.plot;
	~probAmp = ~y.normalizeSum;
	~matrix = ~m.asArray.flat;
	~nMatrix = ~matrix.collect{|item, index|
		var prob;
		//[index, item].postln;
		prob = item + ~probAmp[index] * 0.5;
	};

	"Suma de probabilidades: " ++ ~nMatrix.sum.postln;

	a = [~matrix,~nMatrix].plot;
	a.plotMode = \bars; a.refresh;
	q = ();
		q[\matrix] = ~nMatrix;
		Archive.put(\ampMatrixLCSE, q);
},
{
		"LCSE"
	}
	*/
];




//"/Users/gerardomeza/Desktop/Entrelazados Project/Codigos/gui_23Dic_LCSE.scd".loadPaths;
