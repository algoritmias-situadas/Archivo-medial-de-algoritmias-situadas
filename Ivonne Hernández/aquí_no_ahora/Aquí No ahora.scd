/*Prototipo Instalación Sonora "Aquí, No ahora"
Diciembre 2023
Versión Hidrófono + Cuencos con Agua
Asesores: Kepa Landa i Jordi Virgili
*/

//________________________________________________________________________________________
/*INSTRUCCIONES
1. ACTIVAR SERVER Y DEFINIR ENTRADAS Y SALIDAS DE AUDIO
2. CARGAR BUFFERS
3. CARGAR SYNTHDEF DE BUFFERS
4. CARGAR PBINDS DE BUFFERS
5. CARGAR INPUT MIC, SYNTH DELAY Y REVERB
*/





//________________________________________________________________________________________
//1. Activar el Server
(
Server.killAll;
s = Server.local;

// Para definir Entradas
ServerOptions.devices;
o = Server.default.options;
//o.inDevice_( "MME : Microphone (Scarlett 2i2 USB)"); //Tarjeta local
//o.inDevice_("Windows WASAPI : Microphone (Fast Track)"); // (INPUT)
o.inDevice_("MME : Input 1 (2- Minifuse 1)");
//o.inDevice_( "MME : Micrófono (MobilePre)");
//o.outDevice_("Windows WASAPI : Speakers (Fast Track)"); // Para interfaz externa (OUTPUT)
o.outDevice_("  MME : Altavoces (MobilePre)"); // Para audifonos
//o.outDevice_("MME : Altavoz (Conexant SmartAudio HD"); //Para altavoz de compu
//o.outDevice_("MME : Speakers (Scarlett 2i2 USB)");
s.waitForBoot("A trabajar, maldito holgazán".postln);
)

s.meters;
//________________________________________________________________________________________
//2. Cargar Buffers
(
~path = thisProcess.nowExecutingPath.dirname;

~nom =[
	"Vivaldi - Trio Sonata ＂La Follia＂ in D Minor RV63.wav",
	"Cielo - Ivonne Hernández.wav"
];

~path= "C:/Users/MXTLab/Downloads/";

~bofs = ~nom.collect{|nom|Buffer.read(s, ~path ++ "/" ++ nom)};

~pleyer = ~bofs;


//Para escuchar los audios pre-cargados
~bofs[0].play;
~bofs[1].play;
)



//________________________________________________________________________________________
//3. Cargar SynthDef de Buffers

(
//Mono
SynthDef(\playmono, {arg rate = 1, amp = 1, buffer, startPos = 0, attack = 0.02, sustain = 1, release = 0.5, pan = 0, timeatk= 4, timesus = 20, timerel = 6, gate = 1, out = 0;
	var sig, env;
	env = EnvGen.kr(Env([attack, sustain,release], [timeatk, timesus, timerel], curve: \lin), doneAction: 1);
	sig = PlayBuf.ar(
		numChannels: 2,
		bufnum: buffer,
		rate: BufRateScale.ir(buffer) * rate,
		startPos: startPos.linlin(0, 1, 0, BufFrames.kr(buffer))
	);
	sig = sig * env;
	sig = Pan2.ar(sig, pan);
	Out.ar(0, sig);
}).add;


SynthDef(\playBufFinal, {arg rate = 1, amp = 1, buffer, startPos = 0, attack = 0.02, sustain = 1, release = 0.5, ffreq = 1000, rq = 0.1, pan = 0, delay = 0.3, decay = 1, timeatk= 4, timesus = 20, timerel = 6, gate = 1;
	var snd, env;
	env = EnvGen.kr(Env([attack, sustain,release], [timeatk, timesus, timerel], curve: \lin), doneAction: 1);
	snd = PlayBuf.ar(
		numChannels: 2,
		bufnum: buffer,
		rate: rate,
		startPos: startPos.linlin(0, 1, 0, BufFrames.kr(buffer))
	);
	snd = snd * env;
	snd = BPF.ar(snd, ffreq, rq);
	snd = CombC.ar(snd, maxdelaytime: 2, delaytime: delay, decaytime: decay);
	snd = Balance2.ar(snd[0],snd[1], pan);
	Out.ar(0, snd);
}).add;

)

//________________________________________________________________________________________
//4. Cargar PBind de Buffers

(
~bufMonoMod = Pbind(
	\instrument, \playmono,
	\buf, Prand([~bofs[0], ~bofs[1], ~bofs[2]]),
	\buf,~bofs[1],
	\pitchRatio, 1,
	\pitchDispersion, 0,
	\amp, 0.8,
	\windowSize, 3,
	\pitchRatio, 1/3,
	\pitchDispersion, 2,
	\timeDispersion, 1,
	\freqHP,100,
	\freqLP,Pwhite(10000,20000.0),
);



~bufMonoRand = Pbind(
	\instrument, \playmono,
	\buf, Prand([~bofs[0], ~bofs[1], ~bofs[2]]),
	\buf,~bofs[1],
	\amp, 0.8,
	\rate,Prand([ -1, -1/2, 1, 16/15, 2.squared, 9/5], 10),
	\dur,10,
	\startPos, 0,
	\attack, 0.01,
	\sustain, 0.5,
	\timesus, 20,
	\timerel,  4,
	\release,  0.1,

);

~textoss = ["Todos los objetos
deben recibir la misma atención, ya sean humanos, no humanos,naturales, culturales, reales o ficticios.", "Los objetos no son idénticos a sus propiedades, sino que tienen una relación tensa con esas propiedades, y esta misma tensión es responsable de
todos los cambios que se producen en el mundo.", "Las propiedades de los objetos también son de dos
tipos: de nuevo, reales y sensuales.", "Poc a poc", "No puedes engañarte a ti mismo.", "El suicidado, como cualquier muerto, el dolor se ha ido", "Una caricia es un viaje a través del vacío emocional", "¡Basta, no me lastimas!", "Hoy es un buen día para intentarlo", "¿Será?", "Caí en cuenta que el combate era consigo mismo", "Un cadáver significa la posibilidad de abrir el libro de los misterios que el movimiento niega.", "Tienes la oportunidad de explorar mis mapas", "Esta tierra está abierta a la exploración", "¿Estás preocupado?", "Te prometo que voy a olvidarte", "Atraviesan los sueños como un espéctro", "¿En qué estas pensando?", "Gracias, por sus caricias", "A oscuras y en la bruma el frío se alarga", "¿Cómo dormiste?", "Llega hasta mí, e instalate en mi piel como  en tu casa", "¿Quién es ese, que su veneno temen aquellos que de sólo oír su nombre tiemblan?", "¿Será cosa del amor?", "Esplendor exiliado", "Poblado de soledumbre y deliciosa eternidad", "Gime un par de atros pra estas tinieblas vivas", "Sin embargo no siempre está claro dónde se supone que debemos encontrar la verdad y el conocimiento que se recomiendan como nuestra cura milagrosa", "Yo habré de estar dispuesta a abandonar", "Lo opuesto del amor no es odio, es indiferencia", "Carajo", "Lleida, desde 2023", "Transferencias Aurales, 2024", "Ruidos - CDMX"];

~align = [\center];


(
w = Window.new("Pantalla", 880@880);
l = CompositeView(w, w.bounds);
w.background = Color.white;
t = StaticText(l, l.bounds);
t.stringColor = Color.black;
t.font = Font("Courier", 50);
t.string = "Aquí, No ahora";
t.align = \center;
);


(
~w_2 = Window.new ("Pantalla", 480@200);
~tf = TextField(~w_2, Rect(20, 10, 380, 30));
~tf.string = "¿Algún mensaje para alguien, en algún lugar, en algún tiempo?";
~butt = Button(~w_2, Rect(20, 50, 380, 30)).states_([["Guardar", Color.black, Color.cyan]]).action_({
	~textoss = ~textoss.add(~tf.string);
	~tf.string = "";
	~tf.align = \center;
	~tf.font = Font("Courier", 20);

})

);

//Pbind
~colores = Pbind(
	\textin, Pfunc{ {t.background = Color.rand; t.align = ~align.choose; t.string = ~textoss.choose}.defer},
	\pos, Prand([-0.8, 0.8], 0),
);

~w_2.front;
w.front;

)

//Para probar los Pbinds
// ~bufMonoMod.play;
// ~bufMonoRand.play;

//Para guardar textos

(

~path = "C:/Users/MXTLab/Downloads/" ++ "aquí_no_ahora_memoria.txt";

~file = File(~path, "w");

~file.write(~tf.string);

)


//________________________________________________________________________________________
//4. Cargar PBind de Buffers
(
// Monitor
~revIsOn = False;

//Buses

s.newBusAllocators;
~soundBus = Bus.audio(s, 2);
~reverbBus = Bus.audio(s, 2);

~sourceGrp = Group.new;
~reverbGrp = Group.new(~sourceGrp, \addAfter);

//Input Hidrófono

SynthDef(\micro,{arg in=0 /*Este es la senal para el Hidrofono*/, out=0;
	var sig;
	sig = SoundIn.ar(in);
	Out.ar(out, sig.dup);
}).add;

~micro = Synth(\micro, target: ~sourceGrp);

//Reverb

SynthDef(\reverb,
	{
		arg in=55, out=0, mix=0.9, room = 0.9, damp= 0.7;
		var sig, rev;
		sig = In.ar(in);
		rev = FreeVerb.ar(sig,mix,room,damp,1.0);
		Out.ar(out, rev.dup);
	}
).add;


//Delay
/*
SynthDef(\delay,
{
arg in= 1, delayTime = 3, feedback= 0.8, out = 0;
var sig, delay;
sig =  DelayN.ar(SoundIn.ar(in),delayTime,delayTime);
delay = Feedback.ar(sig,feedback);
Out.ar(out, delay.dup);
}
).add;

~delay = Synth(\delay);

*/
)
//________________________________________________________________________________________

//5. CARGAR INPUT MIC, SYNTH DELAY Y REVERB

(
//Detector de Amplitud en el Tiempo
SynthDef(\detectorAmp,
	{
		arg in = 0;
		var input, ampF;
		input  =  SoundIn.ar(in);
		ampF = Amplitude.kr(input);
		SendTrig.kr(Impulse.kr(5), 2, ampF);
}).add;

x = Synth(\detectorAmp);


// Variables Globales:

~flag = false;
~umbral = 0.009; // umbral de amplitud
~umbralT = 0.09;//mbral de tiempo
~tiempo = 0;

~flagForSynthe = false;
~umbralForSynthe = 0.009; // umbral de amplitud
~umbralTForSynthe = 0.09; // umbral de tiempo

~ventanita = false;

/*
OSCdef(\deTec, {
	arg msg, time, addr, port;
	var pich, ampli;
	ampli = msg[3];
	ampli.round(0.001).post; ":::    flag: ".post; ~flag.postln;

	if (~flag)

	// Si flag es true entonces:
	{
		if (ampli > ~umbral) {
			if ((Process.elapsedTime - ~tiempo) > ~umbralT) {
				\victoria.postln;
				if (~revIsOn == True) // Aquí se evalúa la condición
				{
					// Este bloque se ejecuta si la condición es false
					~revIsOn = False;
					~rev.free;
					//~delay.free;
					~micro.set(\out, 0);
					"reverb desactivated".postln;
				}
				{
					// Este bloque se ejecuta si la condición es true
					~revIsOn = True;
					~rev = Synth(\reverb, [\in, ~reverbBus], ~reverbGrp);
					//~delay = Synth(\delay,[\in, ~reverbBus], ~delayGrp);
					~micro.set(\out, ~reverbBus);
					"reverb activated".postln;
				};
				~flag = false;
				~tiempo = 0;
			};
		}{~flag = false; ~tiempo = 0};
	};


	if ((ampli > ~umbral) and: ~flag.not) {
		~flag = true;
		~tiempo = Process.elapsedTime;
		[~flag, ~tiempo].postln;
	};
}, \tr, s.addr);
*/



//PARA ACTIVAR BUFFERS



OSCdef(\deToc, {
	arg msg, time, addr, port;
	var pich, ampli;
	ampli = msg [3];
	ampli.round(0.001).post; ":::    flag: ".post; ~flag.postln;

	if (~flagForSynthe)
	{
		if (ampli > ~umbralForSynthe) {
			if ((Process.elapsedTime - ~tiempo) > ~umbralTForSynthe) {
				\FuncionandoBuffers.postln;
				if (~bufMonoRand.isPlaying) // Aquí se evalúa la condición
				{
					if (~ventanita)
					{
						"opción 1".postln;
						~colores.play;
					}
					{
						"opción 2".postln;
						~colores.play;
						w.front;
					}


				}
				{
					if (~ventanita)
					{
						{"opción 3".postln}.defer;
						~colores.play;
						~bufMonoRand.play;
					}
					{
						"opción 4".postln;
						~ventanita = true;
						w.front;
						~bufMonoRand.play;
					}
					// Este bloque se ejecuta si la condición es true

				};
				~flagForSynthe = false;
				~tiempo = 0;
			};
		}{~flagForSynthe = false; ~tiempo = 0};
	};


	if ((ampli > ~umbralForSynthe) and: ~flagForSynthe.not) {
		~flagForSynthe = true;
		~tiempo = Process.elapsedTime;
		[~flagForSynthe, ~tiempo].postln;
	};
}, \tr, s.addr);



)

// Plot Tree
s.plotTree;
// Meter
s.meter;


Platform.userExtensionDir;
