//Por Oscar Hiram Castellanos Jiménez

//Para leer todos los sonidos, secuencias e instrumentos está esta línea de código que carga los archivos que tienen eso almacenado

(
~ruta = thisProcess.nowExecutingPath.dirname;
"SynthDefsP.scd".loadRelative;
"Synths Pdef.scd".loadRelative
)

//A continuación está la línea de código principal que activa el mapa interactivo de la instalación

(
//Esta primera línea carga el mapa que es la base y sobre la cuál se muestra todo lo demás
w = Window("Slider2D", Window.screenBounds);
i = Image.open(~ruta ++ "/mapa_chidori.png");
i.scalesWhenResized_(true);
i.setSize(Window.screenBounds.width.asInteger, Window.screenBounds.height.asInteger);


//A continuación viene la sección que carga todas las imágenes dentro del mapa y las posiciona donde deben aparecer cuando sea requerido.
~overlayjolt = View(w, Rect(Window.screenBounds.width/2*0.33, Window.screenBounds.height/2*0.5, 200, 200));
~imgjolteon = Image.open(~ruta ++ "/mapa/jolteon_sprite.png");


~imgjolteon.scalesWhenResized_(true);
~imgjolteon.setSize(100, 100);
~overlayjolt.setBackgroundImage(~imgjolteon, 5, 1, Rect(10, 10, 200, 200));
~overlayjolt.front;
~overlayjolt.visible_(false);


~overlayjolt2 = View(w, Rect(Window.screenBounds.width/2*1.5, Window.screenBounds.height/2*1.7, 200, 200));
~imgjolt2 = Image.open(~ruta ++ "/mapa/jolteon_sprite.png");
~imgjolt2.scalesWhenResized_(true);
~imgjolt2.setSize(100, 100);
~overlayjolt2.setBackgroundImage(~imgjolt2, 5, 1, Rect(10, 10, 200, 200));
~overlayjolt2.front;
~overlayjolt2.visible_(false);


~overlayaron = View(w, Rect(Window.screenBounds.width/2*0.53, Window.screenBounds.height/2*1.17, 400, 400));
~imgaron = Image.open(~ruta ++ "/mapa/aron_sprite.png");
~imgaron.scalesWhenResized_(true);
~imgaron.setSize(190, 190);
~overlayaron.setBackgroundImage(~imgaron, 5, 1, Rect(10, 10, 400, 400));
~overlayaron.front;
~overlayaron.visible_(false);


~overlaytenta = View(w, Rect(Window.screenBounds.width/2*0.9
, Window.screenBounds.height/8, 200, 200));
~imgtenta = Image.open(~ruta ++ "/mapa/tentacool_sprite.png");
~imgtenta.scalesWhenResized_(true);
~imgtenta.setSize(125, 130);
~overlaytenta.setBackgroundImage(~imgtenta, 5, 1, Rect(10, 10, 200, 200));
~overlaytenta.front;
~overlaytenta.visible_(false);


~overlaytenta2 = View(w, Rect(Window.screenBounds.width/2*0.9
, Window.screenBounds.height/2*1.5, 150, 150));
~imgtenta2 = Image.open(~ruta ++ "/mapa/tentacool_sprite.png");
~imgtenta2.scalesWhenResized_(true);
~imgtenta2.setSize(100, 100);
~overlaytenta2.setBackgroundImage(~imgtenta2, 5, 1, Rect(10, 10, 150, 150));
~overlaytenta2.front;
~overlaytenta2.visible_(false);


~overlayvigo = View(w, Rect(Window.screenBounds.width/2*1.2, Window.screenBounds.height/10, 400, 400));
~imgvigo = Image.open(~ruta ++ "/mapa/vigoroth_sprite.png");
~imgvigo.scalesWhenResized_(true);
~imgvigo.setSize(110, 110);
~overlayvigo.setBackgroundImage(~imgvigo, 5, 1, Rect(10, 10, 400, 400));
~overlayvigo.front;
~overlayvigo.visible_(false);


~overlaygyarados = View(w, Rect(Window.screenBounds.width/2*1.15, Window.screenBounds.height/2*0.85, 400, 400));
~imggyarados = Image.open(~ruta ++ "/mapa/gyarados_sprite.png");
~imggyarados.scalesWhenResized_(true);
~imggyarados.setSize(110, 110);
~overlaygyarados.setBackgroundImage(~imggyarados, 5, 1, Rect(10, 10, 400, 400));
~overlaygyarados.front;
~overlaygyarados.visible_(false);


~overlaywingull = View(w, Rect(Window.screenBounds.width/2*0.85, Window.screenBounds.height/2, 400, 400));
~imgwingull = Image.open(~ruta ++ "/mapa/wingull_sprite.png");
~imgwingull.scalesWhenResized_(true);
~imgwingull.setSize(150, 150);
~overlaywingull.setBackgroundImage(~imgwingull, 5, 1, Rect(10, 10, 400, 400));
~overlaywingull.front;
~overlaywingull.visible_(false);


~overlaywar = View(w, Rect(Window.screenBounds.width/2*0.6, Window.screenBounds.height/10, 400, 400));
~imgwar = Image.open(~ruta ++ "/mapa/warturtle_sprite.png");
~imgwar.scalesWhenResized_(true);
~imgwar.setSize(140, 140);
~overlaywar.setBackgroundImage(~imgwar, 5, 1, Rect(10, 10, 400, 400));
~overlaywar.front;
~overlaywar.visible_(false);

~overlaychar = View(w, Rect(Window.screenBounds.width/2*0.33, Window.screenBounds.height/2, 400, 400));
~imgchar = Image.open(~ruta ++ "/mapa/charizard_sprite.png");
~imgchar.scalesWhenResized_(true);
~imgchar.setSize(120, 120);
~overlaychar.setBackgroundImage(~imgchar, 5, 1, Rect(10, 10, 400, 400));
~overlaychar.front;
~overlaychar.visible_(false);


~overlaykadabra = View(w, Rect(Window.screenBounds.width/2*1.53, Window.screenBounds.height/2*0.45, 400, 400));
~imgkadabra = Image.open(~ruta ++ "/mapa/kadabra_sprite.png");
~imgkadabra.scalesWhenResized_(true);
~imgkadabra.setSize(110, 110);
~overlaykadabra.setBackgroundImage(~imgkadabra, 5, 1, Rect(10, 10, 400, 400));
~overlaykadabra.front;
~overlaykadabra.visible_(false);


~overlaylin = View(w, Rect(Window.screenBounds.width/2*1.2, Window.screenBounds.height/2*1.65, 200, 200));
~imglin = Image.open(~ruta ++ "/mapa/linoone_sprite.png");
~imglin.scalesWhenResized_(true);
~imglin.setSize(120, 120);
~overlaylin.setBackgroundImage(~imglin, 5, 1, Rect(10, 10, 200, 200));
~overlaylin.front;
~overlaylin.visible_(false);


~overlaybulba = View(w, Rect(Window.screenBounds.width/2*1.47, Window.screenBounds.height/2*0.78, 200, 200));
~imgbulba = Image.open(~ruta ++ "/mapa/bulbasaur_sprite.png");
~imgbulba.scalesWhenResized_(true);
~imgbulba.setSize(100, 100);
~overlaybulba.setBackgroundImage(~imgbulba, 5, 1, Rect(10, 10, 200, 200));
~overlaybulba.front;
~overlaybulba.visible_(false);


~overlaycombu = View(w, Rect(Window.screenBounds.width/2*1.71, Window.screenBounds.height/2*1.25, 200, 200));
~imgcombu = Image.open(~ruta ++ "/mapa/combusken_sprite.png");
~imgcombu.scalesWhenResized_(true);
~imgcombu.setSize(125, 125);
~overlaycombu.setBackgroundImage(~imgcombu, 5, 1, Rect(10, 10, 200, 200));
~overlaycombu.front;
~overlaycombu.visible_(false);


//Después vienen las instrucciones que determinan la posición del cursor y llo hacen actuar como un slider al darle click.

t = Slider2D(w, Window.screenBounds)
.setBackgroundImage(i, 5, 1, Window.screenBounds)
        .x_(0)
        .y_(0)
        .action_({|sl|
	x = ((sl.x).asFloat * 1920).asInteger;
	y = ((sl.y).asFloat * 1080).asInteger;

//Dentro de esta misma sección vienen las líneas de código que usando la posición del slider determinaran que melodía o motivo algorítmico sonará segpun la unicación del slider en la pantalla.

	if(x.inclusivelyBetween(1450, 1600) && y.inclusivelyBetween(880, 1000)) {
		Pdef(\defensitaPdef).set(\amp, 0.8);
		Pdef(\defensitaPdef).play;
	}{
		Pdef(\defensitaPdef).set(\amp, 0);
		SystemClock.sched(1.0, Pdef(\defensitaPdef).stop;)
	};

	if((x > 780) && (x < 870) && (y > 300) && (y < 380)) {
		Pdef(\Desierto).set(\amp, 0.8);
		Pdef(\Desierto).play;
	}{
		Pdef(\Desierto).set(\amp, 0);
		SystemClock.sched(1.0, Pdef(\Desierto).stop;)
	};


if((x > 850) && (x < 960) && (y > 530) && (y < 630)) {
		Pdef(\Intro).set(\amp, 0.8);
		Pdef(\Intro).play;
	}{
		Pdef(\Intro).set(\amp, 0);
		SystemClock.sched(1.0, Pdef(\Intro).stop;)
	};


if((x > 300) && (x < 440) && (y > 170) && (y < 300)) {
		Pdef(\Velocito).set(\amp, 0.8);
		Pdef(\Velocito).play;
	}{
		Pdef(\Velocito).set(\amp, 0);
		SystemClock.sched(1.0, Pdef(\Velocito).stop;)
	};


if((x > 1680) && (x < 1780) && (y > 50) && (y < 160)) {
		Pdef(\Final).set(\amp, 0.8);
		Pdef(\Final).play;
	}{
		Pdef(\Final).set(\amp, 0);
		SystemClock.sched(1.0, Pdef(\Final).stop;)
	};


if((x > 300) && (x < 400) && (y > 870) && (y < 1000)) {
		Pdef(\Ataquito).set(\amp, 0.8);
		Pdef(\Ataquito).play;
	}{
		Pdef(\Ataquito).set(\amp, 0);
		SystemClock.sched(1.0, Pdef(\Ataquito).stop;)
	};


if((x > 1020) && (x < 1130) && (y > 40) && (y < 120)) {
		Pdef(\Chill).set(\amp, 0.8);
		Pdef(\Chill).play;
	}{
		Pdef(\Chill).set(\amp, 0);
		SystemClock.sched(1.0, Pdef(\Chill).stop;)
	};


if((x > 1670) && (x < 1760) && (y > 490) && (y < 580)) {
		Pdef(\Pastoral).set(\amp, 0.8);
		Pdef(\Pastoral).play;
	}{
		Pdef(\Pastoral).set(\amp, 0);
		SystemClock.sched(1.0, Pdef(\Pastoral).stop;)
	};


//Esta otra parte hace mismo pero además utiliza las variables en las que se guardaron las imágenes para también mostrarlas y ocultarlas según la ubicación del slider.

if((x > 880) && (x < 950) && (y > 310) && (y < 530)) {
		Pdef(\Wingull).set(\amp, 0.6);
		Pdef(\Wingull).play;
		~overlaywingull.visible_(true);
	}{
		Pdef(\Wingull).set(\amp, 0);
		~overlaywingull.visible_(false);
		SystemClock.sched(1.0, Pdef(\Wingull).stop;)
	};


if((x > 270) && (x < 440) && (y > 500) && (y < 800)) {
		Pdef(\Jolteon).set(\amp, 0.6);
		Pdef(\Jolteon).play;
		~overlayjolt.visible_(true);
	}{
		 Pdef(\Jolteon).set(\amp, 0);
		~overlayjolt.visible_(false);
		SystemClock.sched(1.0, {Pdef(\Jolteon).stop;

		});
};

if((x > 660) && (x < 1160) && (y > 800) && (y < 960)) {
		Pdef(\Tentacool).set(\amp, 0.6);
		Pdef(\Tentacool).play;
		~overlaytenta.visible_(true);
	}{
		 Pdef(\Tentacool).set(\amp, 0);
		~overlaytenta.visible_(false);
		SystemClock.sched(1.0, {Pdef(\Tentacool).stop;
		});
};

if((x > 800) && (x < 1400) && (y > 880) && (y < 1000)) {
		Pdef(\Vigoroth).set(\amp, 0.6);
		Pdef(\Vigoroth).play;
		~overlayvigo.visible_(true);

	}{
		 Pdef(\Vigoroth).set(\amp, 0);
		~overlayvigo.visible_(false);
		SystemClock.sched(1.0, {Pdef(\Vigoroth).stop;

		});
};

if((x > 1000) && (x < 1350) && (y > 530) && (y < 630)) {
		Pdef(\Gyarados).set(\amp, 0.6);
		Pdef(\Gyarados).play;
		~overlaygyarados.visible_(true);
	}{
		 Pdef(\Gyarados).set(\amp, 0);
		~overlaygyarados.visible_(false);
		SystemClock.sched(1.0, {Pdef(\Gyarados).stop;
		});
};

if((x > 450) && (x < 750) && (y > 280) && (y < 370)) {
		Pdef(\Aron).set(\amp, 0.6);
		Pdef(\Aron).play;
		~overlayaron.visible_(true);
	}{
		 Pdef(\Aron).set(\amp, 0);
		~overlayaron.visible_(false);
		SystemClock.sched(1.0, {Pdef(\Aron).stop;
		});
};

if((x > 500) && (x < 950) && (y > 870) && (y < 1000)) {
		Pdef(\Warturtle).set(\amp, 0.6);
		Pdef(\Warturtle).play;
		~overlaywar.visible_(true);
	}{
		 Pdef(\Warturtle).set(\amp, 0);
		~overlaywar.visible_(false);
		SystemClock.sched(1.0, {Pdef(\Warturtle).stop;
		});
};


if((x > 280) && (x < 440) && (y > 370) && (y < 700)) {
		Pdef(\Charizard).set(\amp, 0.6);
		Pdef(\Charizard).play;
		~overlaychar.visible_(true);
	}{
		 Pdef(\Charizard).set(\amp, 0);
		~overlaychar.visible_(false);
		SystemClock.sched(1.0, {Pdef(\Charizard).stop;
		});
};


if((x > 1280) && (x < 1650) && (y > 20) && (y < 180)) {
		Pdef(\Jolteon2).set(\amp, 0.4);
		Pdef(\Jolteon2).play;
		~overlayjolt2.visible_(true);
	}{
		 Pdef(\Jolteon2).set(\amp, 0);
		~overlayjolt2.visible_(false);
		SystemClock.sched(1.0, {Pdef(\Jolteon2).stop;
		});
};


if((x > 1450) && (x < 1600) && (y > 680) && (y < 860)) {
		Pdef(\Kadabra).set(\amp, 0.6);
		Pdef(\Kadabra).play;
		~overlaykadabra.visible_(true);
	}{
		 Pdef(\Kadabra).set(\amp, 0);
		~overlaykadabra.visible_(false);
		SystemClock.sched(1.0, {Pdef(\Kadabra).stop;
		});
};


if((x > 870) && (x < 970) && (y > 170) && (y < 420)) {
		Pdef(\Tentacool2).set(\amp, 0.6);
		Pdef(\Tentacool2).play;
		~overlaytenta2.visible_(true);
	}{
		 Pdef(\Tentacool2).set(\amp, 0);
		~overlaytenta2.visible_(false);
		SystemClock.sched(1.0, {Pdef(\Tentacool2).stop;
		});
};


if((x > 1130) && (x < 1480) && (y > 20) && (y < 180)) {
		Pdef(\Linoone).set(\amp, 0.8);
		Pdef(\Linoone).play;
		~overlaylin.visible_(true);
	}{
		 Pdef(\Linoone).set(\amp, 0);
		~overlaylin.visible_(false);
		SystemClock.sched(1.0, {Pdef(\Linoone).stop;
		});
};

if((x > 1140) && (x < 1640) && (y > 520) && (y < 800)) {
		Pdef(\Bulbasaur).set(\amp, 0.8);
		Pdef(\Bulbasaur).play;
		~overlaybulba.visible_(true);
	}{
		 Pdef(\Bulbasaur).set(\amp, 0);
		~overlaybulba.visible_(false);
		SystemClock.sched(1.0, {Pdef(\Bulbasaur).stop;
		});
};


if((x > 1600) && (x < 1800) && (y > 210) && (y < 450)) {
		Pdef(\Combusken).set(\amp, 0.8);
		Pdef(\Combusken).play;
		~overlaycombu.visible_(true);
	}{
		 Pdef(\Combusken).set(\amp, 0);
		~overlaycombu.visible_(false);
		SystemClock.sched(1.0, {Pdef(\Combusken).stop;
		});
};



//Esta es una pequeña sección con líneas para hacer debug, las primeras líneas ayudan a determinar la posición y los valores de la ubicación del slider, aunque no son perfectas ya que estas reportan abajo izquierda como ubicación 0, 0 y las imagenes de los pokemones determinan como arriba izquierda el 0, 0 con valores peeculiares, pero ayudan a determinar las posiciones requeridas para la música, lo demás son líneas para probar diferentes secciones por separado, se pueden ignorar o usar para experimentar.


	/*"x ".post;x.postln;
	"y ".post;y.postln;*/



/*if((x > 0) && (x < 50) && (y > 0) && (y < 50)) {
	if(Pdef(\Aron).isPlaying) {
		Pdef(\Aron).set(\amp, 0);
		SystemClock.sched(1.0, { Pdef(\Aron).stop });
	};
	if(Pdef(\defensitaPdef).isPlaying) {Pdef(\defensitaPdef).set(\amp, 0);
	SystemClock.sched(1.0, { Pdef(\defensitaPdef).stop });
	};
	if(Pdef(\Intro).isPlaying) {Pdef(\Intro).set(\amp, 0);
	SystemClock.sched(1.0, { Pdef(\Intro).stop });
	};
	};



	"x ref ".post;((sl.x).asFloat * 1536).asInteger.postln;
	"y ref ".post;(y-864).abs.postln;*/


        });
w.fullScreen;
w.front;
)




//Por Oscar Hiram Castellanos Jiménez



//Esta es una pequeña sección para hacer pruebas con diferentes partes del código previo, se puede ignorar o utilizar para hacer experimentos propios, solo hay que remover los simbolos "/" y "*" al inicio y al final.


/*(
~w = Window("Slider2D", Window.screenBounds);

~mapaImg = Image.open(~ruta ++ "/mapa_chidori.png");
~mapaImg.scalesWhenResized_(true);
~mapaImg.setSize(Window.screenBounds.width.asInteger, Window.screenBounds.height.asInteger);

~imgIntro = Image.open(~ruta ++ "/jolteon_sprite.png");

// Overlay para la imagen pequeña
~overlayIntro = View(~w, Rect(900, 420, 200, 200));
~overlayIntro.drawFunc = { |view, drawContext|
    if (~imgIntro.notNil) {
        drawContext.drawImage(~imgIntro, view.bounds);
    };
};

~overlayIntro.visible = false; // invisible inicialmente

// Slider2D con imagen de fondo
~t = Slider2D(~w, Window.screenBounds)
    .setBackgroundImage(~mapaImg, 5, 1, Window.screenBounds)
    .x_(0)
    .y_(0)
    .action_({ |sl|
        var x = (sl.x * Window.screenBounds.width).asInteger;
        var y = (sl.y * Window.screenBounds.height).asInteger;

        if(x.inclusivelyBetween(1450, 1600) && y.inclusivelyBetween(880, 1000)) {
            Pdef(\defensitaPdef).set(\amp, 0.8);
            Pdef(\defensitaPdef).play;
        } {
            Pdef(\defensitaPdef).set(\amp, 0);
            SystemClock.sched(1.0, Pdef(\defensitaPdef).stop);
        };

        if((x > 780) && (x < 900) && (y > 300) && (y < 400)) {
            Pdef(\Desierto).set(\amp, 0.8);
            Pdef(\Desierto).play;
        } {
            Pdef(\Desierto).set(\amp, 0);
            SystemClock.sched(1.0, Pdef(\Desierto).stop);
        };

        if((x > 850) && (x < 960) && (y > 530) && (y < 630)) {
            Pdef(\Intro).set(\amp, 0.8);
            Pdef(\Intro).play;
        } {
            Pdef(\Intro).set(\amp, 0);
            SystemClock.sched(1.0, Pdef(\Intro).stop);
        };

        if((x > 300) && (x < 440) && (y > 170) && (y < 300)) {
            Pdef(\Velocito).set(\amp, 0.8);
            Pdef(\Velocito).play;
        } {
            Pdef(\Velocito).set(\amp, 0);
            SystemClock.sched(1.0, Pdef(\Velocito).stop);
        };

        if((x > 1680) && (x < 1780) && (y > 50) && (y < 160)) {
            Pdef(\Final).set(\amp, 0.8);
            Pdef(\Final).play;
        } {
            Pdef(\Final).set(\amp, 0);
            SystemClock.sched(1.0, Pdef(\Final).stop);
        };

        if((x > 300) && (x < 400) && (y > 870) && (y < 1000)) {
            Pdef(\Ataquito).set(\amp, 0.8);
            Pdef(\Ataquito).play;
        } {
            Pdef(\Ataquito).set(\amp, 0);
            SystemClock.sched(1.0, Pdef(\Ataquito).stop);
        };

        if((x > 1000) && (x < 1500) && (y > 40) && (y < 120)) {
            Pdef(\Chill).set(\amp, 0.8);
            Pdef(\Chill).play;
        } {
            Pdef(\Chill).set(\amp, 0);
            SystemClock.sched(1.0, Pdef(\Chill).stop);
        };

        if((x > 880) && (x < 950) && (y > 420) && (y < 530)) {
            Pdef(\Wingull).set(\amp, 0.6);
            Pdef(\Aron).play;
        } {
            Pdef(\Aron).set(\amp, 0);
            SystemClock.sched(1.0, Pdef(\Aron).stop);
        };

        if((x > 880) && (x < 950) && (y > 370) && (y < 500)) {
            Pdef(\Jolteon).set(\amp, 0.6);
            Pdef(\Jolteon).play;
            ~overlayIntro.visible = true;
        } {
            Pdef(\Jolteon).set(\amp, 0);
            SystemClock.sched(1.0, {
            Pdef(\Jolteon).stop;
                ~overlayIntro.visible = false;
            });
        };

        ("x: " ++ x).postln;
        ("y: " ++ y).postln;
    });

~w.front;
~w.fullScreen;
)

*/











