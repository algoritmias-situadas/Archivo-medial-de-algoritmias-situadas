e=Env.sine;
//variable para hacer que la reproducción del patron variable, guiada por la forma de una sinusoide.

k=Array.series(51, 0, 0.02);
// array para guardar los valores de cada posición de la sinusoide.

~senoide=k.collect{|x| e.at(x)};
//metodo para guardar estos valores en una variable global

x=Prand([10, 13, 15],inf);
~locura=Pbind(\instrument,\locura,
	\bfun, Pxrand([~axo, ~trunk, ~urb, ~ye, ~campana, ~pisos, ~ambient, ~ariles],inf),
	\ini, 1/Pwhite(1,10,inf), //valores entre 1/10 a 1, es decir se empieza a reproducir desde 1/10 del sample total random hasta empezar en el final (1)
	\vel, Pwhite(-1.0, 1.0, inf), // hacer que se reprodusca el sample entre su velocidad orignal (1) y más lento (ej. 0.3) hasta que se pueda reproducir al reves (-1).
	\pan, Pwhite(0.0,2.0, inf), // Para PanAz random de 0.0 a 2.0
	\atk, 1, // ataque de un segundo
	\rel, Pseries(0.5, 0.1,inf), // release va decreciendo desde 0.5 sec a 0 sec en pasos de 0.1 segundos
	\sust, Pseries(1, 0.1,inf), //sustain que descrece en 0.1 desde 1 segundo
	\dur, Pseq([Pseries(1, -0.01, 100), Pseq([0.1], 50), Pseq([0.01], inf)], 1), //secuencia de para emular que la duración va disminuyendo.
	\out, 27, //output 27 para mandarlo a la mixer
	\amp, dbamp(-18) //bajar amplitud
);
//Pbind para hacer una textura sonora con cambio de sample (declarados en el archivo de "pathi.scd") dónde la una masa sonora caotica domine un espacio de la pieza.
~org=Pbind(
	\instument, \kteto,
	\freq, Plet(\melos, Pwhite(40, 123, inf)),
	\fqm, Pwhite(1000, 6000, inf),
	\md, Pbrown(0, 1,pi/10, inf),
	\rel,Plet(\rr, Ppoisson(0.5,inf)),
	\atk, Ppoisson(0.1,inf),
	\gat, 1,
	\dur,Plet(\ry, Pseq(k,inf)*0.5+0.1*x),
	\pan, Plet(\pn,Ppoisson(2/~bocinas/2, inf)),
	\ffre, Pmeanrand(0, 10, inf),
	\amt, -24,
	\out, 19,
);
//Patron para el organillo, genera melodias por medio de una distribución aleatoria de ruido blanco. Los toca en Fm y Am. Emplea un Plet para prestar sus alturas a los Pbind con el Synth de aire filtrado (aire, naire, etc)
~orga=Pbind(
	\instrument, \pelele,
	\freq, Plet(\melo2,Pxrand([Pwhite([100, 400],[1000, 2000], 1), Pbrown([234, 346], [234*7/8, 348*3/2], 31,1), 420, 666, 741, Prand([100, 150, 70, 80, 99, 910], 4)], inf)),
	\gat, 1,
	\amp, Pwrand([1,0], [0.7, 0.3], inf) *0.1,
	\freqm1, Pkey(\freq)*pi,
	\freqm2, Pwhite(300, 12000, inf),
	\pan, Plet(\pxn, Pbrown(0, 2.0, 0.05, inf)),
	\rel, Plet(\rela, Prand([0.9, 0.4,0.8], inf)),
	\atk, 0.25,
	\ffre, 100,
	\dur, Plet(\r2, Pseq(k,inf)*0.5+0.1*x/64),
	\vol, -24,
	\out, 19);
//Lo mismo que org, pero con frequencias más agudas, también manda sus alturas al Plambda
~orga2=Pbind(
	\instrument, \pelele,
	\freq, Plet(\inD,Pxrand([Prand([62, 61, 59, 57,55],8), Pwrand([[73, 69], 71, 69, 67,66], [0.3,0.15,0.15,0.2,0.2],8)],inf)).midicps,
	\dur, Plet(\inr,Pseq(k,inf)*0.5+0.1*Prand([Pwrand([1/16, 1/8, 1/4], [0.1,0.4,0.5],16),Pwrand([1/16, 1/8, 1/4]*2,[0.1,0.4,0.5],16)],inf)),
	\vol, -24,
	\gat, 1,
	\rel, 0.5,
	\freqm1, Pkey(\freq)*5/4,
	\freqm2, Pkey(\freq)*3/2,
	\pos, Plet(\pin, Pwhite(0.0,2.0,inf)),
	\atk, 0.25,
	\out, 27);
~org3=Pbind(
	\instument, \kteto,
	\freq, Plet(\min, Pwrand([50, 54, 57, 48, 49]-24, [1, 1/2, 3/4, 1, 1/8].normalizeSum,inf)).midicps,
	\fqm, Pkey(\freq)*6/5,
	\rel, Plet(\res,Prand([0.8, 0.44], inf)),
	\atk, 0.25,
	\ffre, Pwhite(1000, 20000,inf),
	\dur, Plet(\ryth,Pseq(k,inf)*0.2+1*Pxrand([4,2,6],inf)),
	\mod, Pwhite(1, 1000, inf),
	\amt, -24,
	\pan, Plet(\pen, Pwhite(0.0,2.0,inf)),
	\out, 27
);
//orga2 y orga3 es exactamente lo mismo que org y orga, pero están afinados a Re para sonar más como organillo.
~aire=Pbind(
	\instrument, \ddruido,
	\mul, 1,
	\pan, Pget(\pxn,1, inf),
	\freC, Pget(\melo2, 100, inf),
	\fRec, 50,
	\dur,Pget(\r2, 1, inf),
	\rel,Pget(\rela,1,inf),
	\atk, 0.25,
	\out, 19);
~aire2=Pbind(
	\instrument, \ddruido,
	\mul, 1.5,
	\pan, Pget(\pn,1, inf),
	\freC, Pget(\melos,1,inf),
	\fRec, 50,
	\dur,Pget(\ry, 1,inf),
	\rel,Pget(\rr,1,inf)*1.2,
	\out, 19);
~naire=Pbind(
	\instrument, \ddruido,
	\mul, 1.5,
	\pan, Pget(\pin,0, inf),
	\freC,Pget(\inD,100,inf).midicps,
	\fRec, 50,
	\dur,Pget(\inr, 1, inf),
	\rel, 0.5,
	\atk, 0.25,
	\out, 27,);
~n4ire=Pbind(
	\instrument, \ddruido,
	\mul, 1,
	\freC, Pget(\min, 100, inf).midicps,
	\fRec, 50,
	\dur,Pget(\ryth, 1, inf),
	\rel, Pget(\res,1,inf)*1.1,
	\pan, Pget(\pen,0, inf),
	\out, 27);
//Patrones de Aire filtrado, usan ddruido y toman sus duraciones, frecuencias, paneo y release de los Pbinds de org, orga, orga2, orga3.
~coroPian=Pbind(
	\instrument, \buffing,
	\bfn, ~axo,
	\gat, Pwrand([1,0], [0.45,0.55],inf),
	\vel, Pxrand([1, 3/2, 7/8, 9/13]/2, inf) ,
	\fil, Pbrown(10, 2000, 100,inf),
	\pano, Pwhite(0.0,2.0,inf),
	\dur, Ppoisson(15, inf),
	\ini, ~axo.numFrames/Pwhite(2, 10,inf),
	\atk, Prand([2, 3, 4], inf),
	\dec, Pmeanrand(0.1, 1, inf),
	\rel, Ppoisson(20, inf),
	\dbe, -21,
	\out, 12
);
//Reproductor de sample de una grabación (mia) de coro y piano, hace armonías proporcionales a las relaciones que puse en \vel.
~alerta=Pbind(
	\instrument, \buffing2,
	\bfn, ~alarma,
	\gat, Pwrand([1,0], [0.7,0.3],inf),
	\vel, Pxrand([1/2, 3/2, 7/8, 7/13], inf) ,
	\fil, 4000,
	\pano, Pwhite(0.0, 2.0,inf),
	\dur, 1,
	\ini, ~alarma.numFrames/Prand([3, 7, 2, 9],inf),
	\atk, Prand([2, 3, 4], inf),
	\dec, Pmeanrand(0.1, 1, inf),
	\rel, Ppoisson(10, inf),
	\dbe, -18);
//Reproductor de buffers para generar una masa sonora coral y aireosa, se entrelaza con la granulación.
~martillos=Pbind(
	\instrument, \ruffusalt,
	\bfno, ~trunk,
	\fit, 30,//esto es un el tiempo recorido del filtro
	\gat, 1,
	\fgt, 1,//esto es una freq de trigger
	\pn, 8,//esto es una freq
	\atk, 0.1,
	\st, 20,
	\rel, 5,
	\vel, Pxrand([1/Pwhite(2, 10, 5), Pslide([1, 2, 4, 7],5) /Pslide([2, 3, 5, 8], 5)],inf),
	\dur, Ppoisson(3, inf),
	\pos, 0,
	\deb, -21,
	\out, 12
);
//Poliritmia entre un sample de martillos, con relación a las proporciones de vel.
~paisaje=Pbind(
	\instrument, \ruffus,
	\bfno, ~urb,
	\fit,Ppoisson(80, 1) ,
	\atk, Ppoisson(60, 1),
	\dec, Ppoisson(40, 1),
	\rel, Ppoisson(50, 1),
	\deb, -12,
	\pn, 1,
	\out, 19,
);
//Reproductor de un paisaje sonoro que con el tiempo se descubre gracias a la apertura del filtro.
~kanye=Pbind(
	\instrument, \sampi,
	\buf, ~ye,
	\vel, Pwhite(0.5, 1,inf),
	\dur, ~ye.numFrames/60/~ye.sampleRate,
	\pos, ~ye.numFrames*Pwhite(0.1, 1.0, inf),
	\pane, Pwhite(0.0, 2.0, inf),
	\dev, -12,
	\timp, Pkey(\dur, inf),
	\geo, Pseries(1, 0.1,inf),
	\atk, 0.1,
	\out, 27
);
//Reproduce partes de la canción I love Kanye, para hacer una masa sonora muy hablada, saturada.
~bells=Pbind(
	\instrument, \sampi,
	\buf, ~campana,
	\vel, Prand([1,3,5,7],inf)/Pxrand([2,4,8],inf)/2,
	\gt,1,
	\pos, ~campana.numFrames*Pbrown(0.0,1.0,0.314, inf),
	\pane, Pwhite(0.0,2.0,inf),
	\dev,-18,
	\dur, Pmeanrand(0,8,inf),
	\timp, Pkey(\dur,inf),
	\geo,1,
	\atk, 1,
	\out, 12
);
//Reproducción de campanas a relaciones armonicas.
~crunch=Pbind(
	\instrument,\crack,
	\bfn, ~pisos,
	\ini, ~pisos.numFrames/Pwhite(2.0, 10.0,inf),
	\vel, Pxrand([1/2, 2/3/2, 5/4/2],inf),
	\atk, 1,
	\dur, Ppoisson(10, inf),
	\rel, 1.5,
	\dbe, -9,
	\pano, Pwhite(0.0,2.0,inf),
	\out, 12,
	\st, Ppoisson(10,inf),
	\tgf, 0.1
);
//Sample de un piso de madera.
~lluvia=Pmono(
	\buffing,
	\bfn, ~ambient,
	\ini, 0,
	\vel, 1,
	\pano, 2/~bocinas/2,
	\fil, Pbrown(600, 20000, 100,inf),
	\atk, 10,
	\rel, 1,
	\dbe,-18,
	\dur, 0.001,
	\out, 12,
	\st, ~ambient.numFrames/s.sampleRate
);
//paisaje sonoro de lluvia, con esto empieza la pieza.
~corito1=Pmono(\grano,
	\buf, ~alarma,
	\rate, 1,
	\tfreq, 294/5/2,
	\pan, 0.5,
	\pos, Pwhite(0.0,2.0,inf),
	\amp, dbamp(-15),
	\sdur, 0.1,
	\dur, Prand([~ariles.numFrames/s.sampleRate/46, (~ariles.numFrames/s.sampleRate/46)/2],inf),
	\out, 12
);
~corito2=Pmono(\grano,
	\buf, ~alarma,
	\rate, 1,
	\tfreq, 294/2,
	\pan, -0.5,
	\pos, Pwhite(0.0,2.0,inf),
	\amp, dbamp(-15),
	\sdur, 0.1,
	\dur, Prand([~ariles.numFrames/s.sampleRate/46, (~ariles.numFrames/s.sampleRate/46)/2],inf),
	\out, 12
);
//Patron que genera un contra punto entre voces afinado en Re que cambia con el compas del sample de Ariles y Mas Ariles.
~a4iles=Pmono(\ruffus,
	\pos, 0,
	\vel , 1,
	\fit, 10,
	\bfno, ~ariles,
	\deb, -12,
	\amp, 0.45,
	\st, ~ariles.numFrames/s.sampleRate,
	\out, 12
);
//sample de ariles y mas ariles.
~agustinlara=Pmono(\hibrido,
	\bun, ~augustomono,
	\pos, 0,
	\trg, Pxrand([54, 36, 45, 43].midicps/2,inf),
	\wh, Pwrand([0,1], [0.8,0.2].normalizeSum,inf),
	\pan, Pseg([0, 1, 0.3, 1.1, 1, 0.5, 0.75, 0], [rrand(0.0, 5),rrand(0.0, 5),rrand(0.0, 5),rrand(0.0, 5),rrand(0.0, 5),rrand(0.0, 5),rrand(0.0, 5)],4, inf),
	\gps, Pwhite(0.1, 0.9,inf),
	\gdr, Prand([0.25, 0.15, 0.5, 0.75],inf),
	\rat,1,
	\vel, Pwhite(0.0,1.0,inf),
	\dur, Pmeanrand(0.5,Pseries(1, -0.005,inf),inf),
	\out, 12,
);
//patron que intercala entre la granulación de una grabación de una carta y la grabación de la carta misma.

~inicio=Ppar([~crunch, ~lluvia],inf);
~coral=Ppar([~corito1, ~corito2, ~a4iles], 1);
~unoogranun=Ppar([Plambda(Ppar([~org,~aire2],1)),Plambda(Ppar([~orga, ~aire],1))],inf);
~tuneogranundos=Ppar([Plambda(Ppar([~orga2,~naire],1)),Plambda(Ppar([~org3, ~n4ire], 1))],inf);
~pianoso=Ppar([~coroPian, ~martillos,~bells], inf);
//ppar para ejecutar ciertos Pbinds al mismo tiempo y Plambdas para hacer ambientes para compartir datos entre Pbinds.