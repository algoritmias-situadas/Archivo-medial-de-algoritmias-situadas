//FUNCIÓN QUE INICIALIZAN SISTEMA//

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

postln("inicio.scd cargado");