/* 02_midi_input_validation.scd
   Validates that MIDI note-on events reach SuperCollider.
   This is a controlled check to isolate input-layer failures.
*/

(
MIDIClient.init;
MIDIIn.connectAll;

"Listening for MIDI note-on events... Play your keyboard.".postln;
"If nothing prints, the issue is MIDI routing (not synthesis).".postln;

MIDIdef.noteOn(\gaschMidiCheck, { |vel, num, chan, src|
    ("NOTE ON | note:" ++ num ++ " vel:" ++ vel ++ " chan:" ++ chan).postln;
});

// Stop with: MIDIdef(\gaschMidiCheck).free;
)
