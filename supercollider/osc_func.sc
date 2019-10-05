n = NetAddr.new("127.0.0.1", 57120);
OSCFunc.trace(true);
o = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln; }, '/goodbye', n);

(
SynthDef.new(\tone, {
  arg freq=40, nharm=12, detune=0.2, gate=0, pan=0, amp=1, out=0;
  var sig, env;
  env = EnvGen.kr(Env.adsr(0.05,0.1,0.5,3), gate);
  sig = Blip.ar(
    freq * LFNoise1.kr(0.2!16).bipolar(detune).midiratio,
    nharm
  );
  sig = sig * LFNoise1.kr(0.5!16).exprange(0.1,1);
  sig = Splay.ar(sig);
  sig = Balance2.ar(sig[0], sig[1], pan);
  sig = sig * env * amp;
  Out.ar(out, sig);
}).add;
)

x = Synth.new(\tone, [\gate, 1])


(
OSCdef.new(
  \freq,
  {
    arg msg, time, addr, port;
    x.set(\freq, msg[1].linexp(0,1,20,400));
  },
  '/freq'
);

OSCdef.new(
  \amp,
  {
    arg msg;
    x.set(\amp, msg[1].linexp(0,1,0.005,1));
  },
  '/amp',
);
)
