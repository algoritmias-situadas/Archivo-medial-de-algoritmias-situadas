// Sammples generados con el Arturia MiniFreak

~choir = (
	raiz: [36, 48, 60],
	buf: [
		Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "choir C2.wav"),
		Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "choir C3.wav"),
		Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "choir C4.wav")
	]

);

~glassy = (
	raiz: [36, 48, 60],
	buf: [
		Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "glassy C1.wav"),
		Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "glassy C2.wav"),
		Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "glassy C3.wav"),
		Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "glassy C4.wav")
	]

);

~metalglass = (
	raiz: [36, 48, 60],
	buf: [
		Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "metalglass C1.wav"),
		Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "metalglass C2.wav"),
		Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "metalglass C3.wav"),
		Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "metalglass C4.wav")
	]

);

~organ = (
	raiz: [36, 48, 60],
	buf: [
		Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "organ C1.wav"),
		Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "organ C2.wav"),
		Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "organ C3.wav")
	]

);


~tone = (
	raiz: 45, //A
	buf: Buffer.read(s,PathName(thisProcess.nowExecutingPath).parentPath +/+ "samples" +/+ "tone C3.wav")
);



postln("samples.scd cargado");