/*

MARKÓYAGER

Rodrigo Lizárraga
(en colaboración con Juan S. Lach)

*/

/*

requiere la instalación de la clase ShannonFinger del Quark MathLib:
para instalar, evaluar: Quarks.install("MathLib") y volver a compilar la librería de SC

*/

// variables globales
~capa = 1;
~numSpeakers = 2; //número total de canales
~firstOut = 0; // primera salida (en caso de interfaces como los MOTU que empiezan en la salida 2)

~transpose = 7; // intervalo de transposición para las inversiones del cánon
~quantize = 0.125; // quantizar duraciones: 0 = no cuantizar, 0.25 = 8vo, 0.125 = 32avo, etc

// flag del canon
~canonF = true;

//
~patrones = Array.newClear(9);
~pitchM = [];
~durM= [];
~markP = [];
~markD = [];


// cargar sonidos:
// el usuario puede añadir sus syndefs en el siguiente archivo:
"syndefs.scd".loadRelative;

// debe también actualizar el siguiente arreglo con los nombres de sus synthdefs:
~syns = [\reed, \melos, \bup, \plucking, \dx11, \bell, \superpiano, \superhammond,\supermandolin, \piano_MDA];


// detectores

/*
SynthDef(\detectaAmps, {|in = 0, umbral = 0.5|
	var inp, onsets, chain, amp, pich, hasPich;
	inp = SoundIn.ar(in); // entrada de audio
	amp  = Amplitude.kr(inp, 0.01, 1); // detector de amplitud
	SendReply.kr(Impulse.kr(20), '/amplis', amp);
}).add;
*/

SynthDef(\detectaPich, {|in = 0|
	var inp, pich, hasPich;
	inp = SoundIn.ar(in); // entrada de audio
	#pich, hasPich = Pitch.kr(inp); // detector de alturas
	SendReply.kr(Impulse.kr(20), '/alturas', pich); // actualizar alturas 20 veces x segundo
}).add;

SynthDef(\detectaAtaque, {|in = 0, umbral = 0.5|
	var inp, chain, onsets;
	inp = SoundIn.ar(in); // entrada de audio
	chain =  FFT(LocalBuf(512), inp); // detector de ataques
    onsets = Onsets.kr(chain, umbral, \rcomplex, 1.5); // envío de trigger cada detección de ataque
	SendTrig.kr(onsets, 0);
}).add;


// función de inicialización
~init = {
	~altura = 440;

	// función que recoge cada altura detectada
	OSCdef(\detectP, {arg msg, time, addr, port;
		~altura = msg[3]
	}, '/alturas', s.addr).disable;

	~duraciones = [];
	~alturas= [];

	//cada vez que se detecta un ataque, esta función añade al array melódico la altura actual y la hora de llegada del ataque
	OSCdef(\detectPatt, {arg msg, time, addr, port;
		~duraciones = ~duraciones.add(time);
		~alturas = ~alturas.add(~altura);
		[time.round(0.1), ~altura.round(0.1)].postln;
	}, \tr, s.addr).disable;
};


// GUI:
~bt = Array.newClear(8);
w = Window(\markoyager, 500@300).front;
c = CompositeView(w, Rect(5, 5, 490, 290)).background_(Color.new255(104, 131, 139).vary(0.05, 0.35, 0.7));
c.decorator = FlowLayout(c.bounds);
c.decorator.margin = 2@2; c.decorator.gap = 2@2;
~font = Font("Optima-Regular", 25);
~bt[0] = Button(c, 200@150).states_([
	["detectar", Color.white, Color.red(0.7, 0.9)],
	["stop", Color.black, Color.yellow(0.7, 0.3)]
]).font_(~font);
c.decorator.shift(100, 0);
~bt[1] =PopUpMenu(c, 180@40).font_(~font);
~bt[1].items = ~syns;

c.decorator.nextLine;
c.decorator.shift(320, -110);
~bt[2] = Button(c, 150@100).states_([["play", Color.white, Color.blue(0.8, 0.8)]]).font_(~font);

c.decorator.nextLine;
c.decorator.shift(320, 0);
~bt[3] = Button(c, 150@50).states_([["stop", Color.black, Color.cyan(0.4, 0.8)]]).font_(~font);
~bt[3].action = { ~patrones[~capa].stop};
	//~playerActual.stop

// función de encender los detectores con el botón 'detectar'
~bt[0].action = {|b|
	if (b.value == 1) {
		\comienza.postln;
		~init.value;
		~s1 = Synth(\detectaAtaque, [\umbral, 0.53]);
		~s2 = Synth(\detectaPich);
		OSCdef(\detectP).enable;
		"tocar melodía".postln;
		OSCdef(\detectPatt).enable;
}{
		// apagar detectores:
		OSCdef(\detectPatt).disable;
		~s1.free; ~s2.free;
		\yaAcabe.postln;
	}
};


c.decorator.shift(-260, -100);
~bt[4] = Button(c, 100@50).states_([
	["canon", Color.black, Color.green(0.7, 0.9)],
	["simple", Color.black, Color.green(1, 0.8)]
]).font_(~font).action = {|b| if (b.value == 0) {~canonF = true} {~canonF = false}};

c.decorator.nextLine;
c.decorator.shift(320, 100);
~bt[5]= Button(c, 150@50).states_([["stopAll", Color.black, Color.magenta(0.7, 0.7)]]).font_(~font);

~bt[5].action = {~patrones.do{|x| x.stop}};

c.decorator.shift(-260, -52);
~lin = ControlSpec(1, 8, 'lin', 1, 1);
~bt[6] = EZNumber(c, 100@50, "capa",~lin, {}, ~capa, true).font_(~font);

~bt[6].action = {|b|~capa = b.value; };


// botón play:
~bt[2].action = {|b|
	// notas predeterminadas por si el análisis no arrojó información:
	if ( ~duraciones.isEmpty) {~duraciones = [1, 2]; ~alturas = [440, 550];};
	// crear duraciones relativas de tiempos absolutos, cuantizar y quitar ceros por si acaso:
	~durs= ~duraciones.differentiate[1..].round(~quantize).reject{|x| x == 0.0}.abs;
	// se puede cambiar el redondeo para que se cuanticen diferentemente las alturas (1 es semitonos):
	~pitches = ~alturas.cpsmidi.round(1);
// entrenar el markov:
	if (~canonF) {
		// intervalos invertidos:
		~int = (~pitches - ~pitches[0]);
		// inversión de las alturas
		~inv = ~pitches[0] - ~int;
		// el canon son las alturas, las reversas, la inv transpuesta y su reversa:
		~canon = ~pitches ++ ~pitches.reverse ++ (~inv+~transpose) ++ (~inv+~transpose).reverse;
	}{
		// el caso simple:
		~canon =~pitches
	};
	// alimentar la cadena de Markov de alturas:
	~pitchM = ~pitchM.add(ShannonFinger.new.data = ~canon);
	// alimentar la cadena de Markov de duraciones:
	~durM = ~durM.add(ShannonFinger.new.data = ~durs);
	// arrays de flujos de markovs para todas las capas
	~markP = ~markP.add(~pitchM.last.asStream(order: 1));
	~markD = ~markD.add(~durM.last.asStream(order: 1));
// el patrón que toca:
	~uno = Pbind(\instrument, ~bt[1].item, // instrumento seleccionado en el PopUpMenu
		\midinote, ~markP.last,
		\dur, ~markD.last,
		\pan, -1,
		// las salidas van alternando según la capa y hasta el número de salidas
		\out, ~firstOut + (~capa-1).fold2(~numSpeakers-1).abs
	);
	// quant: 1 implica esperar un beat para comenzar, se puede cambiar
	~playerActual = ~uno.play(quant:1);
	// reemplaza el patrón que pudiera estar tocando antes:
	~patrones[~capa].stop;
	~patrones[~capa] = ~playerActual;
};


/*TO DO:
diferentes órdenes de cadenas de Markov
añadir number boxes al GUI para cambiar:
cuantización de duraciones, transposición y redondeo de alturas, orden de Markov y cuantización del playback
*/