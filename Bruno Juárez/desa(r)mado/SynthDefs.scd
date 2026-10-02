
//Synthdefs
SynthDef(\buffing, {arg ini=0, vel, fil, bfn=~axo, gat=1, pano, atk, dec, rel, dbe, dur, amp, out=0, st;
	var sig, pan, ff, ev;
	sig=PlayBuf.ar(2, bfn, (BufSampleRate.kr(bfn)/s.sampleRate)*vel, gat, ini,0, 2);
	ff=LPF.ar(sig, fil, 1);
	ev=EnvGen.kr(Env.linen(atk, st,dur*rel, 1, 4),1,doneAction:2);
	pan=PanAz.ar(~bocinas,ff, pano)*ev;
	Out.ar(out, pan*dbamp(dbe));
}).add;
//Reproductor de buffers parametrizable con un LPF, una envelope linen y paneo.

SynthDef(\crack, {arg ini=0, vel, fil, bfn=~axo, gat=1, pano, atk, dec, rel, dbe, dur, amp, out=0, st, tgf;
	var sig, pan, ff, ev, imp;
	imp=Impulse.kr(tgf, 0, 0.5, 0.5);
	sig=PlayBuf.ar(2, bfn, (BufSampleRate.kr(bfn)/s.sampleRate)*vel, imp, ini,1, 2);
	ev=EnvGen.kr(Env.linen(atk, st,dur*1.5, 1, 4),1,doneAction:2);
	pan=PanAz.ar(~bocinas,sig, pano, ev);
	Out.ar(out, pan*dbamp(dbe))*amp;}).add;
//Similar a buffing, pero con un impluse para mandar a reproducir buffer con cierta frecuencia.

SynthDef(\buffing2, {arg ini=0, vel, fil, bfn=~axo, gat=1, pano, atk, dec, rel, dbe, out=0;
	var sig, pan, ff, ev;
	sig=PlayBuf.ar(1, bfn, (BufSampleRate.kr(bfn)/s.sampleRate)*vel, gat, ini,0, 2);
	ff=LPF.ar(sig, fil, 1);
	ev=EnvGen.kr(Env.adsr(atk, dec, 0.5, rel),1, doneAction:2);
	pan=PanAz.ar(~bocinas,ff, pano, ev);
	Out.ar(out, pan*dbamp(dbe));
}).add;
//Similar a buffing, pero con una envolvente Adsr.

SynthDef(\ruffus, {arg pos=0, vel=1, fit=30, bfno, gt=1, pn=1, atk=1, st=1, rel=3, deb, out=0;
	var sng, pan, ff, ev;
	sng=PlayBuf.ar(2, bfno, (BufSampleRate.kr(bfno)/s.sampleRate)*vel, gt, pos, 0, 2);
	ff=LPF.ar(sng, XLine.kr(1, 20000,fit, 1, doneAction:0), 1);
	ev=EnvGen.kr(Env.linen(atk, st, rel, 1, 4), 1, doneAction:2);
	pan=PanAz.ar(~bocinas,ff, LFNoise0.kr(pn, 1, 1), ev);
	Out.ar(out, pan*dbamp(deb))}).add;
SynthDef(\ruffusalt, { arg pos=0, vel=1, fit=30, bfno, gt=1, pn=1, atk=1, st=1, rel=3, deb, fgt, out=0;
	var sng, pan, ff, ev, trg;
	trg=Impulse.kr(fgt, 0, 0.5, 0.5);
	sng=PlayBuf.ar(2, bfno, (BufSampleRate.kr(bfno)/s.sampleRate)*vel, trg, pos, 0, 2);
	ff=LPF.ar(sng, XLine.kr(1, 20000,fit, 1), 1);
	ev=EnvGen.kr(Env.linen(atk, st, rel, 1, 4), trg, doneAction:2);
	pan=PanAz.ar(~bocinas,ff, LFNoise0.kr(pn, 1, 1), ev);
	Out.ar(out, pan*dbamp(deb)*0.25);
}).add;
//Ruffus y Ruffusalt reproducen un buffer que se filtra por un LFO, que a su ves es controlado por un Xline, por lo que se abre el filtro en cierto tiempo. Ruffusalt se hico con un impluse para mandar a reproudicr más de un buffer a la vez.

SynthDef(\sampi, {arg buf, vel, gt, pos, pane, dev, timp, geo, atk, out=0;
	var sono, pan, env;
	sono=PlayBuf.ar(2, buf, (BufSampleRate.kr(buf)/s.sampleRate)*vel, gt, pos,0, 0);
	pan= PanAz.ar(~bocinas, sono[0], pane,1);
	env = EnvGen.kr(Env.linen(atk, timp, timp*geo, 1), doneAction: 2);
	Out.ar(out, pan*env*dbamp(dev));
}).add;
//Reproductor de buffers modificando su posición de incio, su velocidad, el paneo, etc.

SynthDef(\locura, {arg bfun, vel=1, gat=1, ini=0, pan=0.5, atk=0.1, sust=0, rel=0.5, out=0;
	var sig, lad, env;
	sig=PlayBuf.ar(2, bfun, (BufSampleRate.kr(bfun)/s.sampleRate)*vel, gat, BufFrames.kr(bfun)*ini,0,doneAction:2);
	lad=PanAz.ar(~bocinas, sig, pan,0.9);
	env=EnvGen.kr(Env.linen(atk, sust, rel, -12.dbamp),gat, doneAction:2);
	Out.ar(out, lad*env);
}).add;
//reproductor de buffers con paneo, aquí se pueden cambiar el buffer por lo que pueden reproducir varios sonidos.

SynthDef(\pelele, {arg freq=440,freqm1=420,freqm2=432, mod=1, mod1=1.2, atk=2, dec=0.5, rel=1, pos=0, gat, vol, out=0;
	var sin, fm1, fm2, env, pan, fil;
	fm2=SinOsc.kr(freqm2, 0, 1, freq*mod);
	fm1=SinOsc.kr(fm2+freqm1, 0, 1, fm2*mod1);
	sin=SinOsc.ar(freq+fm1, 0, 1);
	env=EnvGen.kr(Env.perc(atk,rel,dbamp(vol)), gat, doneAction:2);
	pan= PanAz.ar(~bocinas,sin, pos,1);
	fil= LPF.ar(pan, Line.kr(10000,1, rel*0.8), 1);
	Out.ar(out, fil*env*0.5);
}).add;
//Synth fm para hacer un parte del organillo.

SynthDef(\kteto, {arg freq, fqm, mod, rel, atk, pan=0,gat, ffre, amt, out=0;
	var sg, ft, pn, am, ev;
	am=SinOsc.kr(fqm, 0, 0.5,0.5);
	sg=SinOsc.ar(freq, 0, am);
	ft=LPF.ar(sg,SinOsc.kr(ffre,0,ffre, ffre));
	ev=EnvGen.kr(Env.perc(atk, rel, 0.8),gat,doneAction:2);
	pn=PanAz.ar(~bocinas, ft*ev, pan,dbamp(amt));
	Out.ar(out, pn);
}).add;
//Synth fm para hacer un parte del organillo, este tiene un LPF.

SynthDef(\ddruido, {arg mul, freC=600, fRec=100, pan, rel, atk, out=0;
	var wht, pen, ev;
	wht=BPF.ar(PinkNoise.ar(mul), freC, fRec.reciprocal, 1);
	pen=PanAz.ar(~bocinas,wht,pan,1);
	ev=EnvGen.kr(Env.perc(atk, rel, 1),1, doneAction:2);
	Out.ar(out, pen*ev);
}).add;
//Ruido rosa filtrado con un filtro de banda, emulando a un sonido airoso.

SynthDef(\grano, {arg buf, rate, tfreq, pan, pos, amp, sdur, out=0;
	var trig, sig;
    trig = Impulse.kr(tfreq);
	sig = TGrains.ar(~bocinas, trig, buf, (BufSampleRate.kr(buf)/s.sampleRate)*rate, pos*BufDur.kr(buf), sdur, pan, amp);
	Out.ar(out, sig);
}).add;
//Sinte para la granulación de un sample, emplea el Impluse para dar el triger al TGrains.

SynthDef(\hibrido, {arg bun, pos, trg, rat, gdr, wh, pan, gps, gt, vel, out=0;
	var uno, dos, sig, tig, env, tgr, pen;
	uno=PlayBuf.ar(1, bun, (BufSampleRate.kr(bun)/s.sampleRate)*rat, 1, pos, 0, 2);
	pen=PanAz.ar(~bocinas, uno, pan, 1);
	tig=Impulse.kr(trg);
	dos=TGrains.ar(2, tig,bun, (BufSampleRate.kr(bun)/s.sampleRate)*vel, BufDur.kr(bun)*gps, gdr, pan, 0.5);
	sig=SelectX.ar(wh, [pen,dos],1);
	Out.ar(out, sig);
}).add;
//Genera un seleccionador entre un buf(una grabación de una carta)y una granulación de ese mismo sample.

SynthDef(\chan1, {arg in, atck, rel,tiempo, amp;
	var rev, env, mixo;
	rev=In.ar(in, ~bocinas);
	env=EnvGen.kr(Env.linen(atck, tiempo, rel,1, 4),doneAction:2);
	Out.ar(0, rev*env)}).add;
SynthDef(\chan2, {arg in, atck, rel, tiempo, amp;
	var rev, env, mixo;
	rev=In.ar(in, ~bocinas);
	env=EnvGen.kr(Env.linen(atck, tiempo, rel, 1, 4),doneAction:2);
	Out.ar(0, rev*env)*amp}).add;
SynthDef(\chan3, {arg in, atck, rel, tiempo, amp;
	var rev, env, mixo;
	rev=In.ar(in, ~bocinas);
	env=EnvGen.kr(Env.linen(atck, tiempo, rel,1, 4),doneAction:2);
	Out.ar(0, rev*env)*amp}).add;
//Ultimos tres SynthDefs son para generar las envolventes de amplitud para los resultados de los patrones, es una "mixer".