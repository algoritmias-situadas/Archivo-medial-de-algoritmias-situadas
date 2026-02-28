////////////////////////////// ARREMEDAR ////////////////////////////

~startRec = {
    var timestamp, path;
	timestamp = Date.getDate.format("%H%M_%S");
	path = "C:/Users/aldou/OneDrive/Escritorio/Amp/Burla/Arremedado%" + timestamp + ".wav";

    ~recorder = Recorder.new(s);
    ~recorder.recHeaderFormat = "wav";
    ~recorder.recSampleFormat = "int24";
    ~recorder.filePrefix = "Arremedado";
    ~recorder.record(path, ~busamp, 1);

    "✅ Grabación iniciada:".postln;
};


~stopRec = {
    if (~recorder.notNil and: { ~recorder.isRecording }) {
        ~recorder.stopRecording;
        "🛑 Grabación detenida".postln;
    } {
        "⚠️ No hay grabación activa".postln;
    };
};

///////////////// AQUÍ PONER LA DIRECCIÓN CORRECTA DE LA CARPETA "BURLA" ////////////////

~folder = "C:/Users/aldou/OneDrive/Escritorio/Amp/Burla";



SynthDef(\burlaPlayer, { |buf, out = 0, rate = 1, amp = 0.4|
    var sig;
    sig = PlayBuf.ar(1, buf, rate * BufRateScale.kr(buf), doneAction: 2);
    sig = sig * amp;
    Out.ar(out, sig);
}).add;

////////////////////////////// APLAUSÓMETRO ////////////////////////////

SynthDef(\ataquesamp, {|in 2, umbral 0.5|
	var inp, onsets, chain, amp;
	inp = SoundIn.ar(in);
	amp  = Amplitude.kr(inp, 0.01, 1);
	SendReply.kr(Impulse.kr(10), '/aplauso', amp);
}).add;


~ampla = [];


OSCdef(\aplausometro, {|msg, time, addr, port|
	//msg[3].postln;
	~ampla = ~ampla.add(msg[3])
}, '/aplauso', s.addr);


~aplausometro = Routine({
	~apla = Synth(\ataquesamp);
	6.wait;
	~apla.free;
	~aplausos = ~ampla.sum/~ampla.size;
	~ampla = [];
	~aplausos.postln;
});