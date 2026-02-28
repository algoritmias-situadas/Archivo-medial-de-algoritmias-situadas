~currentPitch = 440;
~listen = true;

SynthDef(\pitchDetector, {|inAmp = 1, outGain = 2, exec = 4000, bins = 16, median = 1,
    ampThresh = 0.1, peakThresh = 0.5, downSmp = 1, speed = 100 |
    var pitch, clarity, inp, amp, gate, trig, onset;
    inp = In.ar(~busamp);
    inp = Compander.ar(inp, inp, 0.25, 1, 0.33, 0.01, 0.1, outGain);
    # pitch, clarity= Pitch.kr(inp, 550, 70, 4000.0, exec, bins, median, ampThresh,
        peakThresh, downSmp,  clar: 1);
    SendReply.kr(Impulse.kr(speed), '/detectPitch', [pitch, clarity]);
}).add;


SynthDef(\onsetDetector, {|atk = 0.01, rel = 0.5, slowLag = 0.5, thresh = 0.5, minDur = 0.5|
    var inp, onset, amp;
    inp = In.ar(~busamp);
    onset = Coyote.kr(inp, rel, slowLag, 0.01, 0.5, thresh, minDur);
    amp = Amplitude.kr(inp, atk, rel);
    SendReply.kr(onset, '/onsetDetect', amp);
}).add;

~grO = Group(s);
~grP = Group(~grO, \addToTail);

~turnOn = {
    ~onsetDetect = Synth(\onsetDetector, [\slowLag, 2.0, \minDur, 1, \thresh, 0.25], ~grO);
    ~pitchDetect = Synth(\pitchDetector, [\speed, 20, \inAmp, 1.5,  \outGain, 2], ~grP);
};

~turnOff = {
    ~onsetDetect.free;
    ~pitchDetect.free;
};


r{1.wait; ~pitchDetect = Synth(\pitchDetector, [\speed, 20, \inAmp, 1.5,  \outGain, 2], ~grP);}.play;
~notag = 0;
~delay = 0.1;

~canal = 0;
~canalb = 7;
~sintes = {}!8;

~tocale = {|freq| "orale".postln;
	if (~canal > 7) {~canal = 0};
	~sintes[~canal] = Synth(\colchon, [\freq, freq, \out, ~canal]);
	~canal = ~canal + 1;

};

/*
~tocaleb = {|freq| "oraleb".postln;
	if (~canalb < 1) {~canalb = 7};
	~sintes[~canalb] = Synth(\colchon, [\freq, freq, \out, ~canalb]);
	~canalb = ~canalb - 1;

};
*/

OSCdef(\pitchDetect, {|msg, time|
    ~currentPitch = msg[3];
	//msg[3].postln;
	//postf("PITCH DETECT: %\n",~currentPitch.round(0.1));
}, '/detectPitch', s.addr).enable;

OSCdef(\onsetDetect, {|msg, time|
			//    postf("OSCD: %\n", [msg, time]);
	r {
		~delay.wait;
		postf("la altura actualggg es: %\n",~currentPitch);
		~tocale.value(~currentPitch);
		~onsetDetect.free;
		{~botones[20].value = 0}.defer;
	}.play(SystemClock);
	"acabe".postln;
}, '/onsetDetect', s.addr).enable;


SynthDef(\colchon, {
	|out = 0, freq = 440, amp = 0.8, gate = 1|
	var son, env, reverb, filt, noise, wow, fm, ring;

	fm = LFTri.kr(0.2, 0, 3, freq);
	son = SinOsc.ar(fm, 0, amp * 0.15);  // <-- MONO
	ring = SinOsc.ar(0.02).range(0.7, 1.2);
	son = son * ring;
	noise = PinkNoise.ar(amp * 0.04);
	wow = SinOsc.kr(0.3, 0, 0.02, 1);
	son = son * wow;
	son = son + noise;
	filt = LPF.ar(son, 1800);
	env = EnvGen.kr(Env.asr(0.05, 0.5, 1.5), gate, doneAction: 2);
	filt = filt * env;
	reverb = FreeVerb.ar(filt, mix: 0.4, room: 0.6, damp: 0.85);

	Out.ar(out, reverb);
}).add;


~wait = 2;


~rotarUno = Routine({
    var canalActual;
	canalActual= 0;
    inf.do {
        canalActual = (canalActual + 1) % 8;
        ~sintes[0].set(\out, canalActual);
        ~wait.wait;
    };
});

~rotarDos = Routine({
    var canalActual;
	canalActual= 1;
    inf.do {
        canalActual = (canalActual + 1) % 8;
        ~sintes[1].set(\out, canalActual);
        ~wait.wait;
    };
});

~rotarTres = Routine({
    var canalActual;
	canalActual= 2;
    inf.do {
        canalActual = (canalActual + 1) % 8;
        ~sintes[2].set(\out, canalActual);
        ~wait.wait;
    };
});

~rotarCuatro = Routine({
    var canalActual;
	canalActual= 3;
    inf.do {
        canalActual = (canalActual + 1) % 8;
        ~sintes[3].set(\out, canalActual);
        ~wait.wait;
    };
});

~rotarCinco = Routine({
    var canalActual;
	canalActual= 4;
    inf.do {
        canalActual = (canalActual + 1) % 8;
        ~sintes[4].set(\out, canalActual);
        ~wait.wait;
    };
});

~rotarSeis = Routine({
    var canalActual;
	canalActual= 5;
    inf.do {
        canalActual = (canalActual + 1) % 8;
        ~sintes[5].set(\out, canalActual);
        ~wait.wait;
    };
});

~rotarSiete = Routine({
    var canalActual;
	canalActual= 6;
    inf.do {
        canalActual = (canalActual + 1) % 8;
        ~sintes[6].set(\out, canalActual);
        ~wait.wait;
    };
});

~rotarOcho = Routine({
    var canalActual;
	canalActual= 7;
    inf.do {
        canalActual = (canalActual + 1) % 8;
        ~sintes[7].set(\out, canalActual);
        ~wait.wait;
    };
});