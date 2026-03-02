/* 01_basic_performance.scd
   Canonical performance entry point for the repository.
   Requirements: SuperCollider + MIDI keyboard.
*/

(
if(s.serverRunning.not) { s.boot; };

MIDIClient.init;
MIDIIn.connectAll;

"Gasch Prime Synth: MIDI is required. Play notes after running all blocks.".postln;
"Opening src/GaschPrimeSynth.scd ...".postln;

Document.open(thisProcess.nowExecutingPath.dirname.dirname +/+ "src" +/+ "GaschPrimeSynth.scd");

"Now execute blocks in GaschPrimeSynth.scd top-to-bottom: BUS → PRIME → ULAM → MIDI → GUI".postln;
)
