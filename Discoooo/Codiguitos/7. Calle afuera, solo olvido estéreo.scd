//Versión octofónico

//1: Texto y datos:_______________________________________________
__________________________________________________________________

//1.1: diccionario
(
(
(
~diccionariotexto = [
    "pienso", "mesa", "digo", "silla", "compro", "pan", "y", "me", "lo", "dejo",
    "que", "aprendo", "se", "olvida", "pasa", "es", "te", "quiero",
    "recuerdo", "imagino", "repito", "callo", "nombro", "busco", "entiendo",
    "confundo", "pregunto", "respondo", "escribo", "leo",
    "mano", "boca", "ojo", "piel", "voz", "paso", "mirada", "respiro",
    "ahora", "antes", "después", "siempre", "nunca", "todavía", "lento",
    "rápido", "vuelve", "espera",
    "puerta", "vaso", "cama", "calle", "luz", "papel", "ventana", "reloj",
    "cerca", "lejos", "junto", "solo", "contigo", "adentro", "afuera",
    "silencio", "ruido", "memoria", "olvido", "peso", "vacío", "eco"
];
);


//1.2: Rutina de buffers:


(
~rutaBuffers = "C:/Users/USUARIO/Documents/SuperColider/Poema/Buffers";
);

//1.3 objetos y carga de buffers:

(
~cargarPalabras = {
    ~palabras = ~diccionariotexto.collect { |pal|
        var ruta = ~rutaBuffers ++ "/" ++ pal ++ ".wav";

        (
            texto: pal,
            ascii: pal.ascii,
            buffer: Buffer.read(s, ruta)
        )
    };
};
);


//Selección de palabras
(
~generarPoema = { |cantidad = 12|
    ~palabrasPoema = ~palabras.scramble.copyRange(
        0,
        (cantidad - 1).clip(0, ~palabras.size - 1)
    );
};
);

~cargarPalabras.();

~generarPoema.(35);
);

//2. ANÁLISIS ASCII____________________________________________________________|

(
(
~analisisAscii = { |ascii|
    (
        suma: ascii.sum,
        promedio: ascii.mean,
        largo: ascii.size,
        min: ascii.minItem,
        max: ascii.maxItem
    )
};
);

//2.2 ASCII → binario

(
~asciiABinario = { |ascii|
    ascii.collect { |n|
        n.asBinaryDigits(8)
    }.flat
};
);
);
)
//3. SYNTHDEFS____________________________________________________________|
(
(
//3.1 Sample de palabra (con pitch variable):


(
SynthDef(\palabraBuf, {
    var sig, out;

    sig = PlayBuf.ar(
        1,
        \buf.kr(0),
        BufRateScale.kr(\buf.kr(0)) * \rate.kr(1),
        doneAction: 2
    );

    sig = sig * \amp.kr(1);

    out = \out.kr(0);       // canal octofónico

    Out.ar(out, sig);
}).add;
);


//~palabraBuf.(~palabras.choose);//prueba buff

//3.2 Percusión ASCII (racimos, Env.perc)

(
SynthDef(\asciiPercClean, {
    var sig, env;

    env = Env.perc(0.002, \dur.kr(0.15), curve: -4)
        .kr(doneAction: 2);

    sig = SinOsc.ar(\freq.kr(800));

    // filtro suave para limpiar
    sig = BPF.ar(
        sig,
        \freq.kr(800),
        0.2
    );

    sig = sig * env * \amp.kr(0.3);

    Out.ar(0, Pan2.ar(sig, \pan.kr(0)));
}).add;
);

//3.3 percusión (drum & bass)

     //kick
(
SynthDef(\kick, {
    var env, sig;

    env = Env.perc(0.005, 0.25, curve: -4)
        .kr(doneAction: 2);

    sig = SinOsc.ar(
        Env([55, 30], [0.04]).kr
    );

    sig = sig * env * 3;
    Out.ar(0, Pan2.ar(sig, 0));
}).add;
);

    //Snare
(
SynthDef(\snare, {
    var env, noise, sig;

    env = Env.perc(0.005, 0.18)
        .kr(doneAction: 2);

    noise = WhiteNoise.ar;
    sig = HPF.ar(noise, 2000);

    sig = sig * env * 0.3;
    Out.ar(0, Pan2.ar(sig, 0));
}).add;
);

   //hihat
(
SynthDef(\hihat, {
    var env, sig;

    env = Env.perc(0.001, 0.08)
        .kr(doneAction: 2);

    sig = WhiteNoise.ar;
    sig = HPF.ar(sig, 6500);

    sig = sig * env * 0.02;
    Out.ar(0, Pan2.ar(sig, 0));
}).add;
);

//3.4 Intérprete binario
(
~ampPercusion= 1.0;
);

(
~percusionAscii = { |p, dur = 1.2|
    var bits, paso, datos, ampLocal;

    bits = ~asciiABinario.(p[\ascii]);
    datos = ~analisisAscii.(p[\ascii]);

    // tempo drum & bass
    paso = 0.05;

    // amplitud derivada del ASCII
    ampLocal = datos[\largo]
        .linlin(3, 12, 0.4, 1.0)
        .clip(0.3, 1.2)
        * ~ampPercusion;

    Routine({
        bits.do { |bit, i|
            if (bit == 1) {
                switch (i % 4,
                    0, {
                        Synth(\kick, [
                            \amp, ampLocal * 1.2,
                            \out, rrand(0, 7)
                        ])
                    },

                    1, {
                        Synth(\hihat, [
                            \amp, ampLocal * 0.4,
                            \out, rrand(0, 7)
                        ])
                    },
                    2, {
                        Synth(\snare, [
                            \amp, ampLocal * 0.8,
                            \out, rrand(0, 7)
                        ])
                    },
                    3, {
                        Synth(\snare, [
                            \amp, ampLocal * 0.6,
                            \out, rrand(0, 7)
                        ])
                    }
                );
            };
            paso.wait;
        };
    }).play;
};
);

//Atmósferas:

(
// Pentáfona Eb mayor (grados base)
~pentEbM = [48, 55, 61, 63, 67]; // Eb2 aprox

// expandir ±2 octavas
~pentEbMExt = [-24, -12, 0, 12, 24].collect { |oct|
    ~pentEbM.collect { |n| n + oct }
}.flat.sort;

// función para elegir nota
~notaPent = {
    ~pentEbMExt.choose.midicps;
};
);

);


//Synthdef

(
(
SynthDef(\atmoPad, {
    var sig, env, mod;

    mod = SinOsc.kr(
        rrand(0.01, 0.05),
        0,
        \freq.kr(440) * 0.02
    );

    sig = Saw.ar(\freq.kr(440) + mod, 0.25)
        + SinOsc.ar(\freq.kr(440) * 0.5, 0, 0.2);

    sig = RLPF.ar(
        sig,
        \filt.kr(1200),
        0.35
    );

    env = Env.linen(
        1.5,
        rrand(2.5, 5),
        2.5
    ).kr(doneAction: 2);

    sig = sig * env * \amp.kr(0.2);

    Out.ar(\out.kr(0), Pan2.ar(sig, 0));
}).add;
);


//Control ASCII atmósferas:

(
~atmosferaAscii = { |p|
      var datos;

    datos = ~analisisAscii.(p[\ascii]);

    Synth(
        \atmoPad,
        [
            \freq, ~notaPent.(),                 // ← nota nueva cada palabra
            \filt, datos[\suma].linexp(300, 1200, 800, 5000),
            \amp, datos[\largo].linlin(3, 12, 0.12, 0.35),
            \out, rrand(0, 1)                     // ← octofonía
        ]
    );
};
);
);

//~atmosferaAscii.(~palabras.choose);//prueba atmosfera

//4. SONIFICACIÓN____________________________________________________________|
(
//4.1 Memoria: pitch del siguiente sample
(
~pitchSiguiente = 1.0;
);
//4.2 Actualizar pitch a partir del ASCII

(
~actualizarPitch = { |p|
    var datos;

    datos = ~analisisAscii.(p[\ascii]);

    ~pitchSiguiente = datos[\promedio]
        .linexp(97, 122, 0.5, 2.0)
        .clip(0.4, 2.5);
};
);


//4.3 Sonificación ASCII (varios golpes)

(
~sonificarAscii = { |p|
    var datos;

    datos = ~analisisAscii.(p[\ascii]);

    2.do {
        Synth(
            \asciiPercClean,
            [
                \freq, datos[\promedio].linexp(97, 122, 400, 1600)
                    * rrand(0.95, 1.05),
                \dur, datos[\largo].linlin(2, 10, 0.05, 0.2),
                \pan, rrand(-0.5, 0.5),
                \amp, 0.1,
				\out, rrand(0,7)
            ]
        );
    };
};
);


//Cuadro de Texto:

(
// VENTANA
~win = Window(
    "Poema",
    Rect(200, 200, 800, 400)
).front;

~win.background = Color.black;

// TEXTO
~texto = StaticText(~win, ~win.bounds);
~texto.align = \center;
~texto.font = Font("Times", 60);
~texto.stringColor = Color.white;
~texto.background = Color.clear;

// función para recentrar
~centrarTexto = {
    ~texto.bounds = ~win.bounds;
};

// AppClock: polling simple y seguro
AppClock.sched(0.1, {
    if (~win.isClosed.not) {
        ~centrarTexto.();
        0.1
    } {
        nil
    }
});
);

//Controlador de texto

(
~mostrarPalabra = { |p|
    var datos, tam, col;

    datos = ~analisisAscii.(p[\ascii]);

    tam = datos[\largo]
        .linlin(3, 12, 40, 140)
        .clip(40, 160);

    col = Color.hsv(
        datos[\promedio].linlin(97, 122, 0.0, 0.8),
        0.6,
        0.9
    );

    {
        if (~texto.notNil and: { ~win.isClosed.not }) {
            ~texto.string = p[\texto];
            ~texto.font = Font("Times", tam);
            ~texto.stringColor = col;
        };
    }.defer; // ← ESTO ES LA CLAVE
};
);
);

//Secciones:__________________________________________________________________________|

(
//A:


(
~seccionA = Routine({
    var poema, mitad;

    poema = ~palabrasPoema;
    mitad = (poema.size / 2).asInteger;

    poema.do { |p, i|

        Synth(\palabraBuf, [
            \buf, p[\buffer],
			\rate, 1,
            \amp, 1.5,
			\out, rrand(0,1)
		]);

        ~sonificarAscii.(p);

		~mostrarPalabra.(p);

        // atmósfera SOLO después de la mitad
        if (i >= mitad) {
            ~atmosferaAscii.(p);
        };

        1.2.wait;
    };
});
);


//B:
(
~seccionB = Routine({
    var poema;

    poema = ~palabrasPoema;
    ~pitchSiguiente = 1.0;

    poema.do { |p|

        // voz / sample
        Synth(
            \palabraBuf,
            [
                \buf, p[\buffer],
                \rate, ~pitchSiguiente,
                \amp, 2,
				\out, rrand(0,1)
            ]
        );

        // atmósfera
        ~atmosferaAscii.(p);

        // percusión (si la tienes activa)
        ~percusionAscii.(p, 1.2);

        // calcular pitch siguiente
        ~actualizarPitch.(p);

		//texto
		~mostrarPalabra.(p);

        rrand(0.9, 1.4).wait;
    };
});
);

//C1:


(
~seccionC1 = Routine({
    var poema, vueltas, total, idxGlobal;

    poema = ~palabrasPoema;
    vueltas = 10;                    // ← cuántas veces recorre el poema
    total = poema.size * vueltas;   // total de eventos
    idxGlobal = 0;

    vueltas.do { |v|
        poema.do { |p|

            var caos, espera, pitch, filt;

            caos = idxGlobal / (total - 1); // 0 → 1 REAL

            espera = caos.linexp(0, 1, 0.9, 0.01);

            pitch = rrand(
                caos.linlin(0, 1, 0.4, 0.1),
                caos.linlin(0, 1, 1.6, 3.8)
            );

            filt = rrand(
                caos.linexp(0, 1, 600, 200),
                caos.linexp(0, 1, 2000, 9000)
            );

            // TEXTO
            ~mostrarPalabra.(p);

            // VOZ
            Synth(\palabraBuf, [
                \buf, p[\buffer],
                \rate, pitch,
                \amp, caos.linlin(0, 1, 1.2, 2.3),
                \out, rrand(0, 1)
            ]);

            // ATMÓSFERA
            Synth(\atmoPad, [
                \freq, ~notaPent.(),
                \filt, filt,
                \amp, caos.linexp(0, 1, 0.9, 0.01);
                \out, rrand(0, 1)
            ]);

            idxGlobal = idxGlobal + 1;

            espera.wait;
        };
    };
});
);




//C2(final):

(
~seccionC2 = Routine({
    var poema, mitad;

    poema = ~palabrasPoema;

    poema.do { |p, i|

       ~generarPoema.(35);

		Synth(\palabraBuf, [
            \buf, p[\buffer],
			\rate, 1,
            \amp, 1.5,
			\out, rrand(0,1)
		]);



		~mostrarPalabra.(p);

        1.2.wait;
    };
});
);

);
)

~seccionC1.play

//Disparos:

~seccionA.play;

~seccionB.play;





//CONTROL GENERAL:

(
Routine({
    ~seccionA.play;
    35.wait;

    ~seccionB.play;
    40.wait;

    ~seccionC1.play;
    78.wait;

    ~seccionC2.play;
}).play;
)


