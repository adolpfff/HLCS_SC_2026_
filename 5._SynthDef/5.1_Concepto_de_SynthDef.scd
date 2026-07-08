/*
Para generar sonido, el servidor utiliza definiciones de síntesis y nodos de síntesis.

Los nodos de síntesis en el servidor son procesos computacionales que generan o procesan señales de sonido o control.

Una definición de síntesis representa del lado del lenguaje, los parámetros de un nodo de síntesis del servidor. Es un mapa detallado de interconecciones de generadores de unidades.

La clase SynthDef nos permite trabajar de manera más felxible y especializada con definiciones de síntesis.

La estructura básica de una definición de síntesis es la siguiente.
*/

(
SynthDef.new(//Clase SynthDef con método .new
	\miPrimerSinte, //Nombre a manera de symbol o string
	{Pulse.ar(220,0.4)} //Función generadora de sonido
).play; //Método: ¿Qué se hace con esta nueva definición de síntesis?
)

/*
Si queremos reproducir el resultado de la definición de manera inmediata (creando de forma automática su respectivo nodo de síntesis), usamos el método .play

Pero entonces, ¿por qué no obtenemos sonido al evaluar la definición anterior?

Hasta ahora hemos estado generando sonido con funciones y el método .play. Sin embargo, la estructura de definiciones y nodos de síntesis es la única forma de producir sonido en SuperCollider. Aplicado a una función, el método .play crea automáticamente una definción y un nodo de síntesis. Si la función no cuenta con parámetros de envolvente y de salida, el método .play los añade de manera automática. Cuando creamos una definición de síntesis personalizada, la envolvente y la salida deben ser especificadas manualmente.
*/

(
SynthDef.new(
	\miPrimerSinte,
	{var sig; //Agregamos variables para más claridad en el proceso
		sig = Pulse.ar(220,0.5,0.4); //Generador de unidades
		Out.ar(0,sig) //EFspecificación de la salida
		}
).play;
)

//Out toma dos argumentos: (1) el número de índice del bus o buses por los que saldrá la señal de audio o control (0 y 1 a menudo son los canales izquierdo y derecho respectivamente), (2) un UGen o arreglo de Ugens.

/*
Los nodos de síntesis activos se pueden consultar en el árbol de nodos. Se puede accesar a esta herramienta desde

1. Barra de herramienta1s > Server > Show Node Tree
2. El atajo de teclado: Ctrl + Alt + T
3. La línea de código: */

NodeTreeView(s).start;

/*
Si queremos agregar una definición de síntesis al servidor sin crear el nodo de síntesis de manera inmediata, usamos  el método .add

Una vez que una definción de síntesis se manda al servidor, permanece disponible mientras el servidor esté inicializado. Para hacer cambios en la definción, hay que declararla de nuevo con los cambios.

Los nombres de cada SynthDef deben ser únicos para evitar referencias cruzadas.
*/

(
SynthDef.new(
	\miPrimerSinte,
	{
		arg freq = 440, amp = 0.4;
		var sig;
		sig = Pulse.ar(freq,0.4,amp); //Argumentos de frecuencia y amplitud
		Out.ar(0,sig) //Especificación de la salida
		}
).add;
)

//Una definción de síntesis añadida al servidor se ejecuta de manera asincrónica con la clase Synth. Como mínimo, Synth necesita el nombre de la definición de síntesis para funcionar.

Synth(\miPrimerSinte);

//Synth también puede especificar argumentos iniciales específicos

Synth(\miPrimerSinte, [\freq, 1000, \amp, 0.8]);

//Si asignamos la reproducción de Synth a una variable, podemos interectuar con ella después del inicio de su reproducción

//Almacenamiento de la reproducción de Synth en la variable global "~nodo1"
~nodo1 = Synth(\miPrimerSinte, [\freq, 150, \amp, 1]);

//Modificación de argumentos con el método .set
~nodo1.set(\freq, 999, \amp, 0.3);

//Parámetros aleatorios de arguementos establecidos con .set

~nodo1.set(\freq, exprand(50,1000), \amp, rrand(0.3,1));

//Liberación del nodo
~nodo1.free;

//Con una sola definición, pueden crearse múltiples nodos de síntesis sin compilar la definición en cada ocasión. Esto contribuye a optimizar recursos y presenta una ventaja de procesamiento con el método .play en una función, el cual tiene que compilarse cada vez que se ejecuta.

(
~nodo1 = Synth(\miPrimerSinte, [\freq, 100, \amp, 1]);
~nodo2 = Synth(\miPrimerSinte, [\freq, 200, \amp, 0.8]);
~nodo3 = Synth(\miPrimerSinte, [\freq, 400, \amp, 0.6]);
~nodo4 = Synth(\miPrimerSinte, [\freq, 800, \amp, 0.4]);
~nodo5 = Synth(\miPrimerSinte, [\freq, 1600, \amp, 0.2]);
)

(
~nodo1.free;
~nodo2.free;
~nodo3.free;
~nodo4.free;
~nodo5.free;
)

//Una definción de síntesis es una entidad estática una vez que se declara, sin embargo, puede llegar a ser bastante flexible por medio de argumentos.

//Para ejemplos cortos y pruebas rápidas, la estructura de función y el método .play puede llegar a ser más conveniente y apropiada que una definición de síntesis. Sin embargo, en proyectos grandes y algoritmos complejos de generación o procesamiento de audio, ua definición e síntesis nos provee de mayor felxibilidad y optimización de recursos.