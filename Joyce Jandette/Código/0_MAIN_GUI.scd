// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Ecosistemas en resonancia >>>>>>>>>>>>>>>>>>>>>>>>
// por Joyce Jandette
// 2025/12

// Sección: MAIN GUI

s.options.sampleRate_(48000); // Ajusta la frecuencia de muestreo
s.boot // Iniciar el servidor

// --------------------------------------------------------------------------------------------------------
// Buses & Grupos
(
// BUSES DE AUDIO
// Entrada desde hardware
~inBus = Bus.audio(s, 1);

// Buses de feedback
~fbBus1 = Bus.audio(s, 1);  // Bus 1 de procesamiento
~fbBus2 = Bus.audio(s, 1);  // Bus 2 de procesamiento

// Buses de análisis (copia limpia para análisis)
~analysisBus = Bus.audio(s, 1);
~fbAnalysisBus = Bus.audio(s, 1);

~outBus = 0; // Bus de salida al transductor
~output = 2; // Bus de salida a sala (octofónica)

// BUSES DE CONTROL (para comunicación entre synths)
~ctrlBuses = (
    globalRMS: Bus.control(s, 1),
    globalCentroid: Bus.control(s, 1),
    globalFlatness: Bus.control(s, 1),
    systemChaos: Bus.control(s, 1),
    systemEnergy: Bus.control(s, 1)


);
// GRUPOS DE EJECUCIÓN

~inputGroup    = Group.head(s);           // 1. Captura de entrada
~analysisGroup = Group.after(~inputGroup); // 2. Análisis de señal
~fbGroup       = Group.after(~analysisGroup); // 3. Procesamiento feedback
~copyGroup     = Group.after(~fbGroup);   // 4. Copia para análisis
~outGroup      = Group.tail(s);           // 5. Salidas finales
"Buses y grupos inicializados".postln;
)

// ----------------------------------------------------------------------------------------------GUI CENTRAL
// Ventana principal con GUI's unificadas en una sóla vista

(
// Variables
var mainWin, sf, testis;
// Carga de patches y definiciones de síntesis
// ------------------------------------------------------------
// Ajustar la dirección de los archivos con tu propia dirección arrastrando los archivos aquí y agregando .load

"4_FB_SYNTHDEFS.scd".loadRelative;// SynthDefs para feedback
"1_SF_GUI.scd".loadRelative;// Interfaz de procesamiento resonante
"2_TESTIS_GUI.scd".loadRelative;// Interfaz Testimonios
"3_MANOS_LIBRES_ROUTINE.scd".loadRelative; // Modulo/Rutina de feedback
//"ias.scd".loadRelative; // Modulo/Rutina inspirada en Alvin Lucier: NO APARECE EN EL REPOSITORIO
// Ventana principal
mainWin = Window("Voces Resurgentes", Rect(265, 60, 1180, 820), false);
mainWin.background = Color.fromHexString("#141827");
mainWin.alpha = 0.97;
mainWin.front;
// Sección superior (módulo SF)
sf = CompositeView(mainWin, Rect(40, 0, 1180, 360));

// Sección inferior (módulo Testimonios)
testis = CompositeView(mainWin, Rect(40, 400, 1180, 500));
testis.decorator = FlowLayout(testis.bounds, 10@10, 10@10);

~makeGUI_SF.(sf);
~makeGUI_Testimonios.(testis);

// SYNTHS DE SISTEMA
// Ejecutar Synth copia para Análisis
~fbCopySynth = Synth(\fbCopy, [\in, ~fbBus1, \out, ~fbAnalysisBus], target: ~copyGroup);

// Ejecutar Synth Análisis Global
~globalAnalysis = Synth(\globalAnalysis, [
	\inAnalysis, ~analysisBus, // Señal de entrada
	\inFeedback, ~fbAnalysisBus, // Señal de feedback
	\updateRate, 20,
	// Control buses
	\globalRMS, ~ctrlBuses.globalRMS,
	\globalCentroid, ~ctrlBuses.globalCentroid,
	\globalFlatness, ~ctrlBuses.globalFlatness,
	\systemChaos, ~ctrlBuses.systemChaos,
	\systemEnergy, ~ctrlBuses.systemEnergy
], target: ~analysisGroup);

//Ejecutar Synth de salida a transductor
~outSynth = Synth(\outPut, [\in, ~fbBus1, \out, ~outBus], target: ~outGroup, addAction: \addToHead);

// Función de limpieza para "rutina manos" libres
~limpiarManosLibres = {
    var rel = 5;
    ~manosLibresRunning = false;
    if(~manosLibresActivos.notNil) {
        ~manosLibresActivos.do { |synth|
            if(synth.notNil) {
                synth.set(\gate, 0);
            };
        };
        SystemClock.sched(rel, {
            ~manosLibresActivos.do { |synth|
                if(synth.notNil) {
                    synth.free;
                };
            };
            ~manosLibresActivos.clear;
            nil;
        });
    };
};
)


// SE PUEDE AGREGAR UN BOTON PARA ENCENDER Y APAGAR OUTPUT
MIDIdef.cc(\outToggle, { |val, cnum|
    if (cnum == 44 and: { val == 127 }) {  // solo responde a CC44 con valor 127
        {
            if (~outSynth.notNil) {
                ~outSynth.free;    // apaga
                ~outSynth = nil;
            } {
            }
        }.defer;
    }
});

// Monitoreo de niveles (ejecutar después de inicializar)
(
~monitorLevels = {
    var rms, centroid, caos, energia;
    loop {
        rms = ~ctrlBuses.globalRMS.getSynchronous;
        centroid = ~ctrlBuses.globalCentroid.getSynchronous;
        caos = ~ctrlBuses.systemChaos.getSynchronous;
        energia = ~ctrlBuses.systemEnergy.getSynchronous;

        // ALERTA si valores exceden umbrales
        if (rms > 0.95) { "RMS ALTO: %".format(rms.round(0.01)).warn };
        if (energia > 0.95) { "ENERGIA ALTA: %".format(energia.round(0.01)).warn };
        if (caos > 0.95) { "CAOS ALTO: %".format(caos.round(0.01)).warn };

        0.5.wait;
    }
}.fork;

// Para detener el monitor:
// ~monitorLevels.stop;
)





