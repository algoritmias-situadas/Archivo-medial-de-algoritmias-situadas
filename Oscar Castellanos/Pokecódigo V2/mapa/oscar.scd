

(

w = Window("Slider2D", Window.screenBounds);
i = Image.open(thisProcess.nowExecutingPath.dirname ++ "/mapa_chido.jpg");
i.scalesWhenResized_(true);
i.setSize(Window.screenBounds.width.asInteger, Window.screenBounds.height.asInteger);
t = Slider2D(w, Window.screenBounds)
.setBackgroundImage(i, 5, 1, Window.screenBounds)
        .x_(0) // initial location of x
        .y_(0)   // initial location of y
        .action_({|sl|
	x = ((sl.x).asFloat * 1920).asInteger;
	y = ((sl.y).asFloat * 1080).asInteger;

	if((x > 280) && (x < 420) && (y > 180) && (y < 300)) {
	Pdef(\defensitaPdef).set(\amp, 0.8); // sube el volumen antes de activar
	Pdef(\defensitaPdef).play;
	if(Pdef(\Aron).isPlaying) {Pdef(\Aron).set(\amp, 0);
	SystemClock.sched(0.6, { Pdef(\Aron).stop });
	};
	if(Pdef(\Intro).isPlaying) {Pdef(\Intro).set(\amp, 0);
	SystemClock.sched(1.0, { Pdef(\Intro).stop });
	};
	};

if((x > 760) && (x < 950) && (y > 250) && (y < 400)) {
	Pdef(\Aron).set(\amp, 0.8);
	Pdef(\Aron).play;
	if(Pdef(\defensitaPdef).isPlaying) {Pdef(\defensitaPdef).set(\amp, 0);
	SystemClock.sched(1.0, { Pdef(\defensitaPdef).stop });
	};
	if(Pdef(\Intro).isPlaying) {Pdef(\Intro).set(\amp, 0);
	SystemClock.sched(1.0, { Pdef(\Intro).stop });
	};
	};


if((x > 850) && (x < 960) && (y > 520) && (y < 640)) {
	Pdef(\Intro).set(\amp, 0.8);
	Pdef(\Intro).play;
	if(Pdef(\defensitaPdef).isPlaying) {Pdef(\defensitaPdef).set(\amp, 0);
	SystemClock.sched(1.0, { Pdef(\defensitaPdef).stop });
	};
	if(Pdef(\Aron).isPlaying) {Pdef(\Aron).set(\amp, 0);
	SystemClock.sched(0.6, { Pdef(\Aron).stop });
	};
	};


if((x > 0) && (x < 50) && (y > 0) && (y < 50)) {
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


	"x ".post;x.postln;
	"y ".post;y.postln;
        });
w.fullScreen;
w.front;
)
​



































































