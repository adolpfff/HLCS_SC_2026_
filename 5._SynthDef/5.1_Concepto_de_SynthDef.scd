/*
Hasta ahora hemos estado utilizando funciones para generar sonido.


El servidor, sin embargo, no entiende funciones, necesita información de cómo generar audio en un formato especial de instrucciones llamado 'byte code' .

El bytecode es un conjunto de instrucciones intermedias entre el lenguade del cliente y el lenguaje del servidor.
*/

{SinOsc.ar()}.def.dumpByteCodes;
{5*5}.def.dumpByteCodes;

The server application uses synth definitions as templates for creating Synth nodes. (Methods such as Function: -play, etc. are simply conveniences which automatically create such a def.) The SynthDef class encapsulates the client-side representation of a given def, and provides methods for creating new defs, writing them to disk, and streaming them to a server.

Los sintetizadores en el servidor, son procesos computacionales que generan o procesan señales de sonido o control, representando un sintetizador en el servidor. Si se asigna este objeto a una variable se puede controlar su comprtamiento de varias maneras.


La clase SynthDef representa del lado de lenguaje los parámetros de un nodo de síntesis en el servidor.
More often, you will want to send the corresponding byte code to the server app without immediately creating a synth. The great advantage of this is that you can play any number of copies of the SynthDef without the overhead of compiling or sending a network of unit generators. In almost all cases, use 'add', as in the next example below.

The core of a def is its unit generator graph function. This is an instance of Function which details how the def's unit generators are interconnected, its inputs and outputs, and what parameters are available for external control. In a synth based on the def, arguments to the function will become instances of Control. These can have default values, or can be set at the time the synth is created. After creation they will be controllable through Node's set and setn methods, or the n_set and n_setn OSC messages.

Once the server has a synth definition, it can very efficiently use it to make a number of synths based on it. Synths on the server are basically just things that make or process sound, or produce control signals to drive other synths.

Una vez que el servidor recibe una SynthDef, puede usarla de manera muy eficiente para crear varios sintetizadores basados en ella.



When we use function-dot-play, SC not only creates a SynthDef and Synth in the background
but also adds a few conveniences. If our function does not include a gated envelope, SC creates one automatically, with an argument named “gate.” The release method, when applied to a
Synth, assumes there is a “gate” argument used to control a sustaining envelope. Additionally,
SC adds an Out UGen if one does not already exist.
When using SynthDef and Synth ourselves, no such conveniences are applied. Instead, we
get exactly what we specify. If we don’t include an amplitude envelope, the release method will
have no effect. Similarly, if we don’t include an output UGen, the Synth will not make any sound.


Like a good recipe book, a SynthDef
should be maximally flexible, so that it can be used to spawn a maximally diverse collection of
tangible results. If a SynthDef is poorly designed (i.e., with a limited set of recipes), the sounds
that can be produced will be similarly limited. Flexible SynthDef design primarily involves
declaring plenty of arguments, so that numerous UGen parameters can be customized and
controlled.

A fin de tener un control más detallado de la creación y reproducción de sonido en SC, tenemos clase SynthDef, la cual nos facilita la traducción de instrucciones de SuperCollider a byte code. Una SynthDef representa información de los generadores de unidades (UGens) de una función y  de la forma en cómo están interconectados.

Once a SynthDef has been added, it will remain available as long as the SC environment re-
mains open and the server remains booted. If you want to make changes to the SynthDef, you
can re-evaluate the code, and the new definition will overwrite the old one. There can only be
one SynthDef with a specific name, so if you have multiple SynthDefs, be sure to give them
unique names.
Cada que una función se ejecuta repite este proceso de nuevo, mientras que un synthdef ya está preparado en el servidor listo para usarse.

It is important to understand that although a single def can provide a great deal of flexibility through its arguments, etc., it is nevertheless a static entity. A def's UGen graph function (and the SC code within it) is evaluated only when the def is created. Thus statements like while, do, collect etc. will have no further effect at the time the def is used to create a Synth, and it is important to understand that a UGen graph function should not be designed in the same way as functions in the language, where multiple evaluations can yield different results. It will be evaluated once and only once.

Un synth es un módulo de procesamiento de señales basado en una definición de sinetizador. Una definición de sintetizador es una serie de instrucciones para diseñar un synth.

We can execute a SynthDef algorithm by instantiating a Synth. At minimum, the Synth needs
to know the name of the SynthDef to be used. If we assign the Synth to a variable, we can com-
municate with it at a point in the future (see Code Example 2.30). Note that we don’t need to
explicitly “play” a Synth; simply creating a Synth puts it in an active state on the audio server.



This is more efficient than repeatedly calling play on the same Function, as it saves the effort of evaluating the Function, compiling the byte code, and sending it multiple times. In many cases this saving in CPU usage is so small as to be largely insignificant, but when doing things like 'mass producing' synths, this can be important.
Synth understands some methods which allow you to change the values of args after a synth has been created. For now we'll just look at one, 'set'. Synth-set takes pairs of arg names and values.

Both Function-play and SynthDef-play return another type of object, a Synth, which represents a synth on the server. If you store this object by assigning it to a variable you can control it's behaviour in various ways.

Comunmente es conveniente mandar el byte code al servidor sin crear inmediatamente el synth. Debido a que una función debe primero convertirse a una SynthDef y repetir este proceso cada que se reproduce, es mejor en cuestión de optimización de recursos utilizar synthdefs sobre funciones. Por otra parte, la estructura de funciones ofrece una mayor flexibilidad

Una vez instanciado un Synth y habiendo almacenado su reproducción en una variable, el método .set recibe como argumentos pares de nombres de argumentos y valores.


Cuando utilizamos un método de reproducción de sonido con una función, sin que nostros lo veamos se crea una SynthDef con el byte code necesario para generar la señal deseada en el servidor.

For short examples and quick tests, function-dot-play is convenient and saves time.
However, in cases where reuse and flexibility of signal algorithms are of greater importance,
it’s preferable to use SynthDef and Synth. In fact, using Synth and SynthDef is the only way
to create sound in SuperCollider. When we invoke function-dot-play, a SynthDef and Synth
are created for us in the background.







Estructura básica de una synthDef:
*/

SynthDef.new(\nombre,{
	|frec = 220, amp = 0.5|
	var sig;
	sig = SinOsc.ar(440,mul: 0.5);
	Out.ar(0,sig);
}).dumpByteCodes;

Synth(\nombre);

/*
Una de las diferencias principales entre una función con el método .play y una SynthDef, es la clase Out al final de la función de la cual se compone una synthDef. Out toma dos argumentos: (1) el número de índex del bus o buses por los que saldrá la señal de audio o control (0 y 1 a menudo son los canales izquierdo y derecho respectivamente), (2) un UGen o arreglo de Ugens.

 Finally, we close the SynthDef.new en-
closure, and use the add method to make the SynthDef available to the audio server. Code
Example 2.29 depicts the result of this process.


*/

x = { SinOsc.ar(660, 0, 0.2) }.play;
y = SynthDef.new("tutorial-SinOsc", { |out| Out.ar(out, SinOsc.ar(440, 0, 0.2)) }).play;
x.free;    // free just x
y.free;    // free just y

s.makeGui

/*

