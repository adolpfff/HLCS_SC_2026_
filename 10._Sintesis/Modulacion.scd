//Modulación.
//En terminos generales se refiere a controlar algun parametro de una señal con otra señal.

//El concepto es muy basto y las tecnicas que le inluyen tambien.
//Las mas conocidas son:
/*///////////////////////////////
//Modulación de anillo (RM)//////
//Modulación de amplitud (AM)////
//Modulación de frecuencia (FM)//
*////////////////////////////////

//En todo caso de modulación se consideran dos señales.
/*
1. Señal moduladora (mod): Quien se encarga de modificar.

2. Señal portadora (car): Quien será modificado.

**Se pueden generar arreglos muy complejos de señales modulando señales en serie -- y paralelo ||.
*/

//Revisemos antes algunos ejemplos de modulación con UGens de baja frecuencia. (LF).

//Tremolo
(
{
	var sig, mod; //Definimos dos variables, una para la señal portadora (sig) y otra para la moduladora (mod).
	mod = SinOsc.ar(10, 0, 1).range(0,1); // La señal moduladora es una onda sinoide.
	sig = Pulse.ar([110,111], mul: mod); //la señal portadora es una cuadrada.
	sig = sig * 0.1;
}.play;
);

//Vibrato
(
{
	var sig, mod;
	mod = SinOsc.ar(1,0,1).bipolar(0.5);
	sig = SinOsc.ar([220,221] * mod.midiratio);
	sig = sig * 0.1;
}.play
)


//Wah-Wah.
(
{
	var sig, mod;
	mod = SinOsc.ar(2, 0).range(0,3000);
	sig = Saw.ar([90,91]);
	sig = LPF.ar(sig, 200 + mod); //La modulación se aplica a la frecuencia de un filtro.
	sig = sig * 0.1;
}.play;
)

//El sonido del mar?
(
{
	var sig, mod;
	mod = SinOsc.ar(5.reciprocal,(3pi/2),1).range(0,1);
	sig = PinkNoise.ar(mod * 0.1);
	sig = sig!2;
}.play;
)

//¿Como se ve la Fase?
(
{
	4.collect{|i|SinOsc.ar(100, (90*i).degrad).range(0,1)};
}.plot
);

(
var x,y;
x = (90*3).degrad;
y = 3pi/2;
[x,y].postln;
)

//Cascada de modulación.
(
{
	var sig, mod1, mod2;
	mod2 = LFNoise0.kr(1).exprange(0.5,3); //mod2 modula la frecuencia de mod1.
	mod1 = SinOsc.kr(mod2, 3pi/2, 1).range(0,3000); //mod1 modula la frecuencia del LPF.
	sig = Saw.ar([110,111]);
	sig = LPF.ar(sig, 200 + mod1);
	sig = sig * 0.1;
}.play;
)

/*/////////////////////////
//Modulación de amplitud //
*//////////////////////////

//Se refiere a la modulación provocada cuando una señal moduladora (mod) afecta la amplitud de una señal portadora.

            [mod]
              |
[car : frec, amp]

//Una modulación de baja frecuencia < 20Hz provoca un efecto de "Tremolo".
//Cuando la frecuencia moduladora aumenta > 20Hz suceden modificaciones en el espectro armonico.

//AM : amplitud modulation
( //Del Tremolo al AM.
{
	var sig, mod;
	mod = SinOsc.ar(XLine.kr(1,220,10)).range(0,1);
	sig = SinOsc.ar(440) * mod;
	sig!2 * 0.3;
}.scope;
FreqScope.new;
)
//Los componentes armonicos adicionales se conocen como bandas laterales o "sidebands"

//RM : ring modulation
//Cuando el rango de modulación del modulador es de -1 a +1 es que se le llama Modulación de anillo o Ring Modulation.
(
{
	var sig, mod;
	mod = SinOsc.ar(XLine.kr(1,220,10)).range(-1,1);
	sig = SinOsc.ar(440) * mod;
	sig!2 * 0.3;
}.scope;
FreqScope.new;
)

//¿Cual es la diferencia?

//En el segundo caso, la frecuencia fundamental desaparece.

//¿Cual es la relación entre la frecuencia del modulador y la frecuencia del portador.?

//Una forma comun de trabajar con modulación es buscar expresar parametros en termino de otros.
/*
En el ejemplo siguiente la frecuencia del modulador es el resultado de multiplicar la frecuencia del portador (car) por un valor [1-20]. De esta manera ya no estamos pensando en 2 frecuencias, sino en una con un indice de cualidad.

*/
(
{
	var car, mod, freq, modFreq;

	modFreq = MouseX.kr(1,20).poll;
	freq = MouseY.kr(100,2000,1);
	mod = SinOsc.ar(freq * modFreq).range(0,1);
	car = SinOsc.ar(freq) * mod;
	car = car!2 * 0.1;
}.scope;
FreqScope.new;
)

/*//////////////////////////
//Modulación de frecuencia//
*///////////////////////////

//La FM es el producto de modular la frecuencia de una señal mediante otra señal.

          [mod : modFreq, modAmp]
            |
[car : freq + , amp]

//Ejemplo.
(
{
	var carFreq, modFreq, car, mod;

	carFreq = 220; //Frecuencia del portador.
	modFreq = XLine.kr(1, 2000, 10); //Frecuencia del modulador

	mod = SinOsc.ar(modFreq).range(110,880); //En este caso el rango de la modulación no es entre 0 y 1 sino entre dos valores en el rango de frecuencia.
	car = SinOsc.ar(carFreq + mod); //Aplicamos el modulador al portador.
	car = car!2 * 0.1;
}.play;
FreqScope.new;
)

//
(
{
	var car, carFreq;
	var mod, modFreq, modAmp;

	carFreq = 220; //frecuencia portadora estática.

	modFreq = MouseX.kr(80,2000,1); //frecuencia moduladora.
	modAmp = MouseY.kr(1, carFreq * 4, 1); //rango de modulación.
	[modFreq,modAmp].poll; //reporta valores del mouse.

	mod = SinOsc.ar(modFreq,mul: modAmp); //modulador

	car = SinOsc.ar(carFreq + mod); //portador.
	car = car!2 * 0.1;
}.play;

FreqScope.new;
)

// Indice de modulación.  (mi)
(
{
	arg cf, mf, mi;
	var car, mod;

	cf = 220;
	// mf = 440;
	mf = MouseY.kr(0, 10) * cf; //Expresamos la frecuencia de modulación en terminos de la frecuencia del portador.

	mi = MouseX.kr(0,10) * mf; //expresamos el indice de modulación en terminos de la ffrecuencia de modulación.

	mod = SinOsc.ar(mf) * mi;
	car = SinOsc.ar(cf + mod);
}.play;
FreqScope.new;
)

//El ejemplo anterior se trata de un "Operador". El bloque fundacional de lo que se conoce como FM compuesta.
//Existen varios diseños, aquí van algunos ejemplos.

/*
1. Aditivo de portadores con moduladores independientes.
2. Aditivo de portadores con un solo modulador.
3. Un portador con moduladores en paralelo.
4. Un portador con moduladores en serie.
5. Portador automodulante.
*/

//1.Aditivo de portadores con moduladores independientes.
(PathName.new(thisProcess.nowExecutingPath).parentPath +/+ "media/add_car_mod_in.png").openOS;

(
s.newBusAllocators;

~grp = Group.new; //Grupo de fuentes sonoras.
~fxGrp = Group.after(~grp); //Grupo de efectos.

~fxBus = Bus.audio(s,2); //bus de ruteo para conectar fuentes con efectos,

~tempo = TempoClock.new; //un Tempo

SynthDef(\fmA, {
	arg fc1 = 110, fc2 = 150, fm1 = 2, fm2 = 3, mi1 = 3, mi2 = 5, amp = 0.5, atk = 0.1, rel = 1, bus = 0;
	var car1, car2, mod1, mod2, env, sig;

	env = EnvGen.ar(Env.perc(atk,rel),doneAction: 2); //envolvente de amplitud.

	fm1 = fc1 * fm1; //frecuencia moduladora 1 relacionada a la portadora 1
	fm2 = fc2 * fm2; //frecuencia moduladora 2 relacionada a la portadora 2
	mi1 = fm1 * mi1; //Indice de modulación 1 relacionado a la frecuencia moduladora 1
	mi2 = fm2 * mi2; //Indice de modulación 2 relacionado a la frecuencia moduladora 2

	mod1 = SinOsc.ar(fm1) * mi1; //modulador 1
	mod2 = SinOsc.ar(fm2) * mi2; //modulador 2

	car1 = SinOsc.ar(fc1 + mod1); //portador 1
	car2 = SinOsc.ar(fc2 + mod2); //portador 2

	sig = car1 + car2; //suma de señales.
	sig = sig * amp * env; //Aplicación de envolvente y factor de amplitud.

	Out.ar(0,sig!2 * -6.dbamp); //Envío a la salida principal
	Out.ar(bus, sig!2); //Envío a la salida de efectos.
}).add;

//Podemos probar el Synth con el siguiente bloque.
/*(
Synth(
	defName: \fmA,
	args: [
		\fc1, 110, \fc2, 112,
		\fm1, 2,\fm2, 3,
		\mi1, 3, \mi2, 5,
		\atk, 0.1, \rel, 1,
		\amp, 0.5,
		\bus, ~fxBus,
	],
	target: ~grp
)
);*/

///////////////////////////////////////////fx

SynthDef(\fx,{ //SynthDef para efectos.
	arg in, room = 10, rev = 3, amp = 0.33;
	var sig;
	sig = In.ar(in,2) * amp; //Objeto in permite ingresar sonido de algun punto de SC.
	sig = GVerb.ar(sig, room, rev); //GVerb es una reverberación.
	Out.ar(0,sig); //Salida principal.
}).add;

//Con la siguiente linea activamos el Synth en el grupo adecuado y el bus de entrada adecuado.
~fxNode = Synth(
	\fx,
	args:[\in, ~fxBus],
	target: ~fxGrp
);

//Controlamos el synth mediante una secuencia de eventos, con Pbind.

~p = Pbind(
	\instrument, \fmA, //Invocamos al instrumento.
	\group, ~grp, //Indicamos el grupo al cual pertenece.
	\dur, Plprand(0.01,0.5).round(1/16), //Indicamos duración entre eventos. Plprand elige valores inferiores.
	//
	\fc1, Pseq([60,62,64,67,69].midicps,inf), //Secuenciamos una serie de valores ojo con .midicps
	\fc2, Pshuf([60,62,64,67,69].midicps,inf) * Prand([1,0.5,2],inf), //multiplicamos un patron por otro.
	\fm1, Prand([2,3,5,7,11],inf),
	\fm2, Prand([2,3,5,7,11],inf) * Pwhite(0.9,1.1),
	\mi1, Pwhite(1,10),
	\mi2, Pwhite(1,10),
	//
	\amp, Pxrand([0,-3,-6,-12].dbamp,inf),
	\atk, 0.01,
	\rel, Pkey(\dur), //el releas del envolvente es igual a la duración del evento.
	\bus, ~fxBus //indicamos el bus para completar el ruteo al synth de efectos.
);
)

~q = ~p.play(~tempo); //guardamos en ~q la reproducción.

~fxNode.set(\amp, 0.1, \room, 4, \rev, 1.5) //podemos modificar algunos argumentos del synth de efectos.
~tempo.tempo = 60/60; //podemos modificar el tempo.
~q.stop; //detenemos la reproducción.

//Con el siguiente bloque cualquier modificación que hagamos del Pbind la podemos incluir al stream.
(
~q.stream = Pbind(
	\instrument, \fmA,
	\group, ~grp,
	\dur, Plprand(0.01,0.5).round(1/16) * 5,
	\fc1, Pshuf([60,62,64,67,69].midicps,inf) * 0.5,
	\fc2, Pkey(\fc1) * Prand([0,1,1.5,2].midiratio,inf),
	\fm1, Prand([2,3,5,7,11],inf),
	\fm2, Prand([2,3,5,7,11],inf),
	\mi1, Pwhite(1,10) * 1,
	\mi2, Pwhite(1,10) * 1,
	\amp, Pxrand([0,-3,-6,-12].dbamp,inf) * 0.2,
	\atk, Pkey(\dur) * Pwhite(0.5,0.7),
	\rel, Pkey(\dur) - Pkey(\atk) * 4,
	\bus, ~fxBus,
).asStream;
)


// 2. Aditivo de portadores con un solo modulador.
(PathName.new(thisProcess.nowExecutingPath).parentPath +/+ "media/add_car_mod.png").openOS;

(
s.newBusAllocators;

~grp = Group.new; //Grupo de fuentes sonoras.
~fxGrp = Group.after(~grp); //Grupo de efectos.

~fxBus = Bus.audio(s,2); //bus de ruteo para conectar fuentes con efectos,

~tempo = TempoClock.new; //un Tempo

SynthDef(\fmB, {
	arg fc1 = 110, fc2 = 150, fm1 = 2, mi1 = 3, amp = 0.5, atk = 0.1, rel = 1, bus = 0;
	var car1, car2, mod1, env, sig;

	env = EnvGen.ar(Env.perc(atk,rel),doneAction: 2); //envolvente de amplitud.

	fm1 = fc1 * fm1; //frecuencia moduladora 1 relacionada a la portadora 1
	mi1 = fm1 * mi1; //Indice de modulación 1 relacionado a la frecuencia moduladora 1

	mod1 = SinOsc.ar(fm1) * mi1; //modulador 1

	car1 = SinOsc.ar(fc1 + mod1); //portador 1
	car2 = SinOsc.ar(fc2 + mod1); //portador 2

	sig = car1 + car2; //suma de señales.
	sig = sig * amp * env; //Aplicación de envolvente y factor de amplitud.

	Out.ar(0,sig!2 * -6.dbamp); //Envío a la salida principal
	Out.ar(bus, sig!2); //Envío a la salida de efectos.
}).add;

//Podemos probar el Synth con el siguiente bloque.
/*(
Synth(
	defName: \fmB,
	args: [
		\fc1, 110, \fc2, 112,
		\fm1, 4,
		\mi1, 1,
		\atk, 0.1, \rel, 1,
		\amp, 0.5,
		\bus, ~fxBus,
	],
	target: ~grp
)
);*/

///////////////////////////////////////////fx

SynthDef(\fx,{ //SynthDef para efectos.
	arg in, delTime = 0.3, decayTime = 1, amp = 0.1;
	var sig;
	sig = In.ar(in,2) * amp;
	sig = CombC.ar(sig, 1, delTime, decayTime);
	Out.ar(0,sig);
}).add;

~fxNode = Synth(
	\fx,
	args:[\in, ~fxBus],
	target: ~fxGrp
);

~p = Pbind(
	\instrument, \fmB,
	\group, ~grp,
	\dur, Plprand(0.01,3).round(1/16),

	\fc1, Pseq([60,62,64,67,69].midicps,inf) * Prand([1,0.5,2],inf),
	\fc2, Pshuf([60,62,64,67,69].midicps,inf) * Prand([1,0.5,2],inf),
	\fm1, Prand([2,3,5,7,11],inf),
	\mi1, Pwhite(1,10),
	//
	\amp, Pxrand([0,-3,-6,-12].dbamp,inf),
	\atk, 0.1,
	\rel, Pkey(\dur),
	\bus, ~fxBus
);
)

~q = ~p.play(~tempo);

~fxNode.set(\amp, 0.1, \delayTime, 0.5, \decayTime, 2) //podemos modificar algunos argumentos del synth de efectos.
~tempo.tempo = 20/60; //podemos modificar el tempo.
~q.stop; //detenemos la reproducción.


// 3. Un portador con moduladores en paralelo.
(PathName.new(thisProcess.nowExecutingPath).parentPath +/+ "media/car_mod_par.png").openOS;

(
SynthDef(\fmC, {
	|
	fc1 = 110,
	fm1 = 2, fm2 = 2,
	mi1 = 3, mi2 = 3,
	amp = 0.5, atk = 0.1, rel = 1, bus = 0
	|
	var car1, mod1, mod2, env, sig;

	env = EnvGen.ar(Env.perc(atk,rel),doneAction: 2); //envolvente de amplitud.

	fm1 = fc1 * fm1;
	fm2 = fc1 * fm2;
	mi1 = fm1 * mi1;
	mi2 = fm2 * mi2;

	mod1 = SinOsc.ar(fm1) * mi1; //modulador 1
	mod2 = SinOsc.ar(fm2) * mi2; //modulador 2

	car1 = SinOsc.ar(fc1 + mod1 + mod2); //portador 1

	sig = car1;

	sig = sig * amp * env; //Aplicación de envolvente y factor de amplitud.

	Out.ar(0,sig!2 * -6.dbamp); //Envío a la salida principal
	Out.ar(bus, sig!2); //Envío a la salida de efectos.
}).add;

~p = Pbind(
	\instrument, \fmC,
	/*\group, ~grp,*/
	\dur, 1/16,
	\fc1, Pseq([60,62,64,67,69].midicps,inf),
	\fm1, Prand([2,3,5,7,11],inf),
	\fm2, Prand([2,3,5,7,11],inf),
	\mi1, Pwhite(1,10),
	\mi2, Pwhite(1,10),
	//
	\amp, Pxrand([0,-3,-6,-12].dbamp,inf),
	\atk, 0.01,
	\rel, Pkey(\dur),
	/*\bus, ~fxBus*/
);
)

~q = ~p.play;