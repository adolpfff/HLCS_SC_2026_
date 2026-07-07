/*
Para generar sonido, el servidor utiliza definiciones de síntesis y nodos de síntesis.

Los nodos de síntesis en el servidor son procesos computacionales que generan o procesan señales de sonido o control.

Una definición de síntesis representa del lado de lenguaje, los parámetros de un nodo de síntesis del servidor. Es un mapa detallado de interconecciones de generadores de unidades.

La clase SynthDef nos permite trabajar de manera más felxible y especializada con definiciones de síntesis.

La estructura de una definición de síntesis es la siguiente.
*/

(
SynthDef.new(//Clase SynthDef con método .new
	\miPrimerSinte, //Nombre a manera de symbol o string
	{Pulse.ar(220,0.4)} //Función generadora de sonido
).play; //Método: ¿Qué se hace con esta nueva definición de síntesis?

/*
Si queremos reproducir el resultado de la definición de manera inmediata (crear su respectivo nodo de síntesis), usamos el método .play

Si queremos agregar una definición de síntesis al servidor sin crear el nodo de síntesis de manera inmediata, usamos  el método .add

Pero entonces, ¿por qué no obtenemos sonido al evaluar la definición anterior?

La estructura de definiciones y nodos de síntesis es la única forma de producir sonido en superCollider. Aplicado a una función, el método .play crea automáticamente una definción y un nodo de síntesis. Si la función no cuenta con parámetros de envolvente y salida, el método .play añade estos parámetros de manera automática.

Cuando creamos manualmente una definición de síntesis, la envolvente y la salida deben ser especificados manualmente.
*/

(
SynthDef.new(
	\miPrimerSinte,
	{var sig, env; //Agregamos variables para más claridad en el proceso
		sig = Pulse.ar(220,0.4); //Generador de unidades
		env = Env.perc().kr(2); //Envolvente
		sig = sig * env; //Aplicación de la envolvente a la señal de audio
		Out.ar(0,sig) //Especificación de la salida
		}
).play;
)

//Out toma dos argumentos: (1) el número de índex del bus o buses por los que saldrá la señal de audio o control (0 y 1 a menudo son los canales izquierdo y derecho respectivamente), (2) un UGen o arreglo de Ugens.


Once a SynthDef has been added, it will remain available as long as the SC environment re-
mains open and the server remains booted. If you want to make changes to the SynthDef, you
can re-evaluate the code, and the new definition will overwrite the old one. There can only be
one SynthDef with a specific name, so if you have multiple SynthDefs, be sure to give them
unique names.






*/

We can execute a SynthDef algorithm by instantiating a Synth. At minimum, the Synth needs
to know the name of the SynthDef to be used. If we assign the Synth to a variable, we can com-
municate with it at a point in the future (see Code Example 2.30). Note that we don’t need to
explicitly “play” a Synth; simply creating a Synth puts it in an active state on the audio server.


//Con una sola definición, pueden crearse múltiples nodos de síntesis sin compilar la definición en cada ocasión. Esto contribuye a optimizar recursos y presenta una ventaja de procesamiento con el método .play en una función, el cual tiene que compilarse cada vez que se ejecuta.

EJEMPLO

//Si se asigna la reproducción de un nodo de síntetesis a una variable se puede controlar su comprtamiento de varias maneras.

EJEMPLO

It is important to understand that although a single def can provide a great deal of flexibility through its arguments, etc., it is nevertheless a static entity. A def's UGen graph function (and the SC code within it) is evaluated only when the def is created. Thus statements like while, do, collect etc. will have no further effect at the time the def is used to create a Synth, and it is important to understand that a UGen graph function should not be designed in the same way as functions in the language, where multiple evaluations can yield different results. It will be evaluated once and only once.


Like a good recipe book, a SynthDef
should be maximally flexible, so that it can be used to spawn a maximally diverse collection of
tangible results. If a SynthDef is poorly designed (i.e., with a limited set of recipes), the sounds
that can be produced will be similarly limited. Flexible SynthDef design primarily involves
declaring plenty of arguments, so that numerous UGen parameters can be customized and
controlled.



This is more efficient than repeatedly calling play on the same Function, as it saves the effort of evaluating the Function, compiling the byte code, and sending it multiple times. In many cases this saving in CPU usage is so small as to be largely insignificant, but when doing things like 'mass producing' synths, this can be important.
Synth understands some methods which allow you to change the values of args after a synth has been created. For now we'll just look at one, 'set'. Synth-set takes pairs of arg names and values.

Both Function-play and SynthDef-play return another type of object, a Synth, which represents a synth on the server. If you store this object by assigning it to a variable you can control it's behaviour in various ways.

Una vez instanciado un Synth y habiendo almacenado su reproducción en una variable, el método .set recibe como argumentos pares de nombres de argumentos y valores.


Comunmente es conveniente mandar el byte code al servidor sin crear inmediatamente el synth. Debido a que una función debe primero convertirse a una SynthDef y repetir este proceso cada que se reproduce, es mejor en cuestión de optimización de recursos utilizar synthdefs sobre funciones. Por otra parte, la estructura de funciones ofrece una mayor flexibilidad


For short examples and quick tests, function-dot-play is convenient and saves time.
However, in cases where reuse and flexibility of signal algorithms are of greater importance,
it’s preferable to use SynthDef and Synth. In fact, using Synth and SynthDef is the only way
to create sound in SuperCollider. When we invoke function-dot-play, a SynthDef and Synth
are created for us in the background.


