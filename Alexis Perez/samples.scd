

~samples = (
	raiz: [36, 48, 60],
	buf: [
		Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "choir C2 fd.wav"),
		Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "choir C3 fd.wav"),
		Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "choir C4 fd.wav")
	]

);


~choir = (
	raiz: 60, //F#
	buf: Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "choir C4 fd.wav") // F#
);

~pad = (
	raiz: 45, //A
	buf: Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "Breath (JW1).wav") // A
);

~smp = (
	raiz: 52, // E3
	buf: Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "Jungle (E3).wav") // F#
);

~bongo = (
	raiz: 48,
	buf: Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "Bongo C.wav") // C
);

~sinte = (
	raiz: 60,
	buf: Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "80s_CZbassA-C4.wav") // C
);

~flutta = (
	raiz: 72,
	buf: Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "Flutta Pad.wav") // C
);

~epiano = (
	raiz: 48,
	buf: Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "88-PCM E-Piano-060 C3 128.WAV") // C
);

~glasspad = (
	raiz: 48,
	buf: Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "Glisten Pad.wav") // C
);

~saw  = (
	raiz: 72, //C5
	buf: Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "saw_C5.wav") // C
);


postln("samples.scd cargado");