
~inicio = {

    if (s.serverRunning.not) { "Iniciando servidor...".postln; s.bootSync; };


    ~reverbBus = Bus.audio(s, 2);
    s.sync; // espera a que el bus se asigne


    ~master = Group.new(s).debug("Grupo Master creado");
    s.sync;

	~p0Group = Group.head(~master).debug("Grupo p0Group creado");

    ~grupoFX = Group.after(~master).debug("Grupo grupoFX creado");
    s.sync;


    ~reverbSynth = Synth(\reverb, [\inBus, ~reverbBus], target: ~grupoFX);
    s.sync;

    ~t = LinkClock.new.latency_(Server.default.latency);
    ~t.enableMeterSync;
    ~t.tempo = 95/60;


}.fork(AppClock);


~envAutom = { // envolvente para automatización
	arg bus, lvls, times, curve;
	var env = Env( levels: lvls, times: times, curve: curve);
	Out.kr(bus, EnvGen.kr(env, doneAction: 2));
};

~envAutomSim = { // envolvente para automatización simetrica
	arg bus, lvls, time, curve;
	var times = (lvls.size - 1).collect({ arg i; lvls[i] + (time / lvls.size)});
	var env = Env( levels: lvls, times: times, curve: curve);
	Out.kr(bus, EnvGen.kr(env, doneAction: 2));
};

postln("inicio.scd cargado");