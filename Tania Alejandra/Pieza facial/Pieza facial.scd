/*Rolita Facial
Instrumentos controlados por el rostro con FaceOSC

Para utilizarlo se debe instalar el software FaceOSC (https://github.com/kylemcdonald/ofxFaceTracker/releases). Ahi mismo puedes seguir las instrucciones para instalar y configurar.
*/

//Esta línea es para conocoer el puerto de Super Collider que recibe los datos de Face OSC y corroborar que coincida con la configuración de FaceOSC
NetAddr.langPort;


//SynthDefs
(

SynthDef(\sint1,{arg freq=180, amp=0.5, freqpul=2, freqpul2=5, freq2=60, pan = 0, gate = 1;
	var sig, env;
	env = EnvGen.kr(Env.asr(0.01, 1, 1.0), gate, doneAction:2);
	sig = SinOsc.ar(freq, 0, amp) * Pulse.ar(freqpul) * Saw.ar(freq2) * Pulse.kr(freqpul2);
	Out.ar(0, Pan2.ar(sig * env, pan));
}).add;

SynthDef(\sint2,{arg freq=1800, amp=0.3, freqpul=4,freq2=60, pan = 0, gate = 1;
	var sig, env;
	env = EnvGen.kr(Env.asr(0.01, 1, 1.0), gate, doneAction:2);
	sig = SinOsc.ar(freq, 0, amp) * Pulse.ar(freqpul);
	Out.ar(0, Pan2.ar(sig * env, pan) );
}).add;

SynthDef(\sint3,{arg freq=180, amp=0.1, amp2=0.2, freq2=600, pan = 0, gate = 1;
	var sig, env;
	env = EnvGen.kr(Env.asr(0.01, 1, 1.0), gate, doneAction:2);
	sig = SinOsc.ar(freq, 0, amp)+ SinOsc.ar (freq2, 0, amp2);
	Out.ar(0, Pan2.ar(sig * env, pan));
}).add;

)



//Lista de etiquetas asignadas a los mensajes de FaceOSC. Estas etiquetas están predefinidas en FaceOSC y corresponden a las distintas partes del rostro que FaceOSC detecta. La función OSCdef se encarga de recibir los mensajes OSC y mediante la función "switch" se separan los mensajes y se mapean los valores recibidos para controlar los valores de los SynthDef.

(

~faceKeys = [
	'/found', '/gesture/eye/left', '/gesture/eye/right', '/gesture/eyebrow/left', '/gesture/eyebrow/right', '/gesture/jaw', '/gesture/mouth/height', '/gesture/mouth/width', '/gesture/nostrils', '/pose/orientation', '/pose/position', '/pose/scale', '/raw'
];
~facePost = ();
~faceKeys.collect {|key, i|
	~facePost[key] = false;
	OSCdef((key ++ "_post").asSymbol, {|msg, time, addr, recvPort|
		if(~facePost[key]) {
			msg.postln;
			// Recomiendo también usar el argumento pan para sonificar parámetros:
			switch(~faceKeys[i].asSymbol,
				'/gesture/eye/left',{~sintes[0].set(\freq,msg[1].linlin(2.0, 4.0, 200, 600))},
				'/gesture/eye/right',{~sintes[0].set(\freq,msg[1].linlin(2.0, 4.0, 1500, 2000))},
				'/gesture/eyebrow/right',{~sintes[1].set(\freq,msg[1].linlin(6.6, 8.0,500,700))},
				'/gesture/eyebrow/right',{~sintes[1].set(\freq,msg[1].linlin(6.6, 8.0,100,1500))},
				'/gesture/nostrils',{~sintes[2].set(\freq,msg[1].linlin(6.0,8.0,180,2000), \freq2,msg[1].linlin(6.0,8.0,600,700),
					\amp,msg[1].linlin(6.0,8.0,0,0.5))},
				'/gesture/mouth/height',{~sintes[0].set(\freqpul,msg[1].linlin(1.1,6.0,1,10))},
				'/gesture/mouth/width',{~sintes[0].set(\freqpul2,msg[1].linlin(8.0,20.0, 1,10))},
				'/gesture/jaw',{~sintes[1].set(\freqpul,msg[1].linlin(1.1,7.0,1,10))},
				'/pose/orientation',{~sintes[1].set(\amp,msg[1].linlin(1.1,7.0,0,0.5))},
				'/pose/position',{~sintes[1].set(\amp,msg[1].linlin(1.1,7.0,0,0.5))},
				'/pose/scale',{~sintes[2].set(\amp,msg[1].linlin(1.1,7.0,0,0.5), \amp2,msg[1].linlin(1.1,7.0,0,0.5))},
			)
		};
	}, key);
};


// Esta linea crea un array para 3 sintes:
~sintes = [Synth.newPaused(\sint1), Synth.newPaused(\sint2), Synth.newPaused(\sint3)];

//GUI para interactuar con los mensages OSC recibidos.

~facePostWindow = Window("FaceOSC", Rect(150, 400, 210, 620)).front;
~facePostWindow.view.addFlowLayout;
~facePost.keys.asArray.sort.do {|item, i|
	Button(~facePostWindow, 200@40)
	.states_([
		[item.asString, Color.black, Color.white],
		[item.asString, Color.black, Color.green]
	])
	.action_({|button|
		~facePost[item] = ~facePost[item].not;
	});
};
// Crea 3 botones para sintes:
~synthButtons = 3.collect{|sinte|
	Button(~facePostWindow, 60@40)
	.states_([
		["Sinte"++ (sinte+1).asString, Color.black, Color.white],
		["Sinte"++ (sinte+1).asString, Color.black, Color.green]
	]);
};
~synthButtons.do{|b, i|
		b.action_({|boton|
			if (boton.value == 1) {
				~sintes[i] = Synth("sint" ++ (i+1).asString);
			}{
			     ~sintes[i].set(\gate, 0);
			};
		});
};

// Esta línea es para que cuando se cierre la ventana de la GUI se apaguen OSCdefs y sintes:
~facePostWindow.onClose = {OSCdef.freeAll; ~sintes.do{|p| p.free}};
)


//~sintes
 //(
 //~sinte1 = Synth(\sint1);
 //~sinte2 = Synth(\sint2);
 //~sinte3 = Synth(\sint3);

 //)