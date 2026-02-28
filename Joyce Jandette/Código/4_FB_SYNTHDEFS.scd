// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Ecosistemas en resonancia >>>>>>>>>>>>>>>>>>>>>>>>
// por Joyce Jandette
// 2025/12
// Sección: Definiciones de síntesis

(
// SynthDefs

// 0. INPUTMIC - Entrada con análisis
//==============================================================================================

SynthDef(\inputMic, {
    |out 0, copyOut 0, hpfFreq 40, lpfFreq 18000,
     humFreq 60, q 0.3, amp 1|
    var sig;
    sig = SoundIn.ar(0);
	sig = BRF.ar(sig, humFreq * [1,2,3], q).sum;     // Filtrado de ruido
    sig = HPF.ar(sig, hpfFreq);
    sig = LPF.ar(sig, lpfFreq);
    sig = LeakDC.ar(Limiter.ar(sig, 0.9));
    Out.ar([out, copyOut], sig * amp);  // Salida dual
}).add;

// 1. INICIO - Señal limpia con histéresis
//==============================================================================================

SynthDef(\inicio, {
    |in 0, out 0, gate 1, amp 0|
    var sig, env, selfRMS, soft;
    sig = In.ar(in, 1);
    selfRMS = Amplitude.kr(sig, 0.05, 0.2);   // Auto-observación
    soft = Lag.kr(selfRMS, 2.0);
	sig = sig * (1 - (soft * 0.2)).clip(0.3, 1.0); //Compresión adaptativa
	sig = LeakDC.ar(sig, 0.995);
    env = EnvGen.kr(Env.asr(0.1, 1, 2, 0), gate, doneAction: 2);
    Out.ar(out, sig * env * amp);
}).add;

// 2. EQ - Ecualizador  multibanda adaptativo
//==============================================================================================

SynthDef(\eq, {
    |in 0, out 0, gate 1, mix 0, graveFocus 4|
    var inp, freqs, rq, bands, amps, gains, flatness, adaptGains, dynGain, wet, dry, env;
    inp = In.ar(in, 1);
    freqs = [40, 55, 60, 80, 100, 120, 150, 180, 220, 280, 400, 600, 1000, 1800, 3500, 5000];
    rq = 0.35;
    bands = BPF.ar(inp, freqs, rq);
    amps  = Amplitude.kr(bands, 0.02, 0.2).clip(0, 1);
    gains = freqs.explin(40, 5000, graveFocus, 0.2);
    flatness = In.kr(\globalFlatness.kr(0), 1);
    dynGain = (1 - amps).linlin(0, 1, 0.4, 1.8);
    dynGain = dynGain * flatness.linlin(0, 1, 1.2, 0.8);
    dynGain = Lag.kr(dynGain, 0.25);
    wet = (bands * gains * dynGain).sum * 1.3;
    dry = inp;
    env = EnvGen.kr(Env.asr, gate, doneAction: 2);
    Out.ar(out, XFade2.ar(dry, wet, mix.linlin(0, 1, -1, 1)) * env);
}).add;

// 3. RINGMOD. Modulador de anillo con limitador dinámico dependiente de la amplitud
//==============================================================================================

SynthDef(\ringmod, {
    |in 0, out 0, delayTime 0.35, fbGain 0.85, modFreq 80, limThresh 0.6, filtFreq 300, amp 0, gate 1|
    var input, loop, delayed, mod, limiter, sig, ampEnv, dynCtrl;
    input = In.ar(in);
    loop = LocalIn.ar(1);
	delayed = DelayN.ar(loop, delayTime + 0.1, delayTime);
	dynCtrl = Amplitude.kr(delayed, 0.01, 0.1);
	limiter = (limThresh / (dynCtrl + limThresh)).clip(0, 1);
	mod = SinOsc.ar(modFreq);
    ampEnv = EnvGen.kr(Env.asr, gate, doneAction: 2);
	sig = (delayed * mod * fbGain).tanh;
	sig = RLPF.ar(sig, filtFreq, 0.2);
	sig = (sig * limiter) + input;
    sig = sig * ampEnv * amp;
    LocalOut.ar(sig);
    Out.ar(out, sig);
}).add;


// 4. PHASER - Con modulación caótica adaptativa
//==============================================================================================

SynthDef(\phaser, {
    |in 0, out 0, rate 30, depth - 1.0, feedback 0.7, wet 0, gate 1, amp 0|
    var inp, phs, env, chaos, adaptRate;
    inp = In.ar(in, 1);
    chaos = In.kr(\systemChaos.kr(0), 1);
	adaptRate = chaos.linlin(0, 1, rate * 0.8, rate * 1); // Rate adaptativo según chaos
    phs = AnalogPhaser.ar(inp, SinOsc.kr(adaptRate), depth, feedback, wet, 35);
    env = EnvGen.kr(Env.asr, gate, doneAction: 2);
    Out.ar(out, phs * env * amp);
}).add;

// 5. RESONANCE - Amplificación armónica. Genera múltiples resonancias armónicas (CombC).
//==============================================================================================

SynthDef(\resonance, {
	|in 0, freq 130, decay 6, out 0, gate 1, amp 0, atk 1.5|
	var input, freqf, reso, env, freqq, selfAmp, adaptDecay, rms;
    input = In.ar(in);
	rms = In.kr(\globalRMS.kr(0), 1);// Leer RMS global
	freqf = freq * Lag.kr(rms.linexp(0.05, 0.3, 1, 4), 1);
	adaptDecay = decay * rms.linlin(0, 0.6, 0.6, 1.4).clip(0.5, 2);
	freqq = freq * [1, 3, 4, 5, 6, 8, 10, 12];
	reso = Mix(CombC.ar(input, 0.5, freqq.reciprocal, decaytime: adaptDecay));
	reso = Notch.ar(reso, freqf, (freqf/2)/freqf);
	reso = LeakDC.ar(reso + (DelayC.ar(reso, 0.2, 0.05) * 0.15));
	reso = Limiter.ar(reso, 0.9);
	env = EnvGen.kr(Env.asr(atk, 1, 4), gate, doneAction: 2);
	Out.ar(out, reso * env * amp);
}).add;


// 6. RMS - Limitador no-lineal con histéresis (Bovermann-inspired)
//==============================================================================================

SynthDef(\rms, {
	|out 0, in 0, inAmp0 1, dly 0.05, filtQ 0.15, gate 1|
	var snd, inAmp, rmsSlow, rmsFast, analytics, chaos, env;
	snd   = In.ar(in, 1) * inAmp0;
	inAmp = Amplitude.ar(snd, 0.01, 0.2);
	rmsSlow = RMS.ar(snd, 400);
	rmsFast = RMS.ar(snd, 20);
	analytics = max(rmsSlow - rmsFast, 0) + rmsFast;
	snd = (snd / (analytics + 0.1));
	chaos = In.kr(\systemChaos.kr(0), 1);
	snd = snd * chaos.linlin(0, 1, 1.0, 0.8);
	snd = RLPF.ar(snd, inAmp.linlin(0, 0.4, 800, 4000), filtQ.clip(0.1, 0.9));
	snd = snd.tanh;
	snd = DelayL.ar(snd, dly, dly);
	snd = snd * 0.4;
	env = EnvGen.kr(Env.asr(0.01,1,6), gate, doneAction:2);
	Out.ar(out, snd * env);
}).add;

// 7. DISONANCE - introduce batimientos y rugosidad que producen texturas disonantes.
//==============================================================================================

SynthDef(\disonance, {
    |in 0, out 0, freq 440, decay 8, coef 0.2, freqf 100, gate 1, amp 0,
    res1 1.4, res2 3.1, res3 5.3, res4 7, res5 6.5, res6 11, freqm 3 |
    var input, filt, reso, env, resos, rms, selfAmp, adaptiveDecay;
    input = In.ar(in, 1);
    rms = In.kr(\globalRMS.kr(0), 1); // Leer RMS global
    selfAmp = Amplitude.kr(input, 0.05, 0.3); // Amplitud de la entrada
    adaptiveDecay = decay * selfAmp.linlin(0, 0.3, 0.7, 1.3).clip(0.5, 2); // Se escucha a sí mismo
    adaptiveDecay = Lag.kr(adaptiveDecay, 3.0); // Cambios lentos
    resos = [res1, res2, res3, res4, res5, res6]; // Armónicos disonantes
    filt = Notch.ar(input, freqf);
    reso = Mix(CombC.ar(filt * selfAmp, 0.5, (freq * resos).reciprocal, adaptiveDecay));
    reso = reso + (reso * SinOsc.ar(freqm, 0.2));
    reso = reso * SinOsc.ar(freqm, 0.2);
    reso = LeakDC.ar(Limiter.ar(reso, 0.7));
    env = EnvGen.kr(Env.asr(3, 1, 3), gate, doneAction: 2);
    Out.ar(out, reso * env * amp);
}).add;

// 8. PULSE - Genera oscilaciones lentas
//==============================================================================================

SynthDef(\pulse, {
    |in 0, out 0, gate 1, amp 0, freqm 3|
    var sig, env;
    sig = In.ar(in, 1);
	sig = sig + (sig*SinOsc.ar(freqm, 0.2));
	sig = sig*SinOsc.ar(freqm, 0.2);
	sig = LeakDC.ar(sig, 0.95);
	env = EnvGen.kr(Env.asr(3, 1, 6, 0), gate, doneAction: 2);
    Out.ar(out, sig * env*amp);
}).add;

// 9. SALIDA Transductor
//==============================================================================================

SynthDef(\outPut, {
    |in 0, out 0, amp 1|
    var inp, sines, mod, env, energy, phase, spatialRate;
    inp = In.ar(in, 1);
	inp = Limiter.ar(inp, 0.99);
    Out.ar(~outBus, inp!2 * amp);
}).add;

// 9. SALIDA Multicanal - Con espacialización adaptativa
//==============================================================================================

SynthDef(\salida, {
	|in 0, out 0, amp 0, amp4 0, gate 1|
    var inp, sines, mod, env, energy, phase, spatialRate;
	inp = In.ar(in, 1);
    energy = In.kr(\systemEnergy.kr(0), 1);
	env = EnvGen.kr(Env.asr(3, 1, 4, 1), gate, doneAction: 2);
	spatialRate = Lag.kr(energy.linexp(0, 1, 0.5, 2), 3.0); //Velocidad de espacialización suavizada
	sines = 8.collect { |i|
		SinOsc.ar(rrand(0.01, 0.1) * spatialRate, rrand(0, pi), rrand(0.1, 0.2) * (1 + (energy * 0.5)))};
	mod = inp * sines;
    Out.ar(out, inp * env * amp);
    Out.ar(~output, mod * amp4 * env);
}).add;

// ANÁLISIS GLOBAL
//==============================================================================================

SynthDef(\globalAnalysis, {
    |inAnalysis = 0, inFeedback, updateRate = 20|
    var sigIn, sigFB, fftIn, fftFB, rms, centroid, flatness, zcr, caos, energia, fbCentroid, fbFlatness, spectralDivergence;
    sigIn = In.ar(inAnalysis, 1);
	sigFB = In.ar(inFeedback, 1);
	fftIn = FFT(LocalBuf(512), sigIn, 0.5, 0);
	fftFB = FFT(LocalBuf(512), sigFB, 0.5, 0);
    rms = Amplitude.kr(sigIn, 0.02, 0.2).max(0.0001);
    centroid = SpecCentroid.kr(fftIn).linlin(20, 20000, 0, 1);
    flatness = SpecFlatness.kr(fftIn);
    zcr = ZeroCrossing.ar(sigIn).linlin(0, 1000, 0, 1);
    fbCentroid = SpecCentroid.kr(fftFB).linlin(20, 20000, 0, 1);
    fbFlatness = SpecFlatness.kr(fftFB);
    spectralDivergence = ((fbCentroid - centroid).abs + (fbFlatness - flatness).abs).clip(0, 1);
    spectralDivergence = Lag.kr(spectralDivergence, 1.0);
	caos = ((zcr*0.3) + (flatness*0.3) + (rms.linlin(0.0001, 0.5, 0, 0.2)) + (spectralDivergence*0.2)).clip(0, 1);
    energia = ((rms * 1.5) + (Amplitude.kr(sigFB, 0.02, 0.2) * 0.5)).clip(0, 1);
    Out.kr(\globalRMS.kr(0), rms);
    Out.kr(\globalCentroid.kr(0), centroid);
    Out.kr(\globalFlatness.kr(0), flatness);
    Out.kr(\systemChaos.kr(0), caos);
	Out.kr(\systemEnergy.kr(0), energia);
}).add;

SynthDef(\fbCopy, {
    |in = 0, out = 0|
    var sig;
    sig = In.ar(in, 1);
    Out.ar(out, sig); // copia sin procesamiento
}).add;
)














