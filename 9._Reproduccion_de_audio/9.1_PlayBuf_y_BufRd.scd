/*
REPRODUCCION DE AUDIO

Dentro de SC es posible reproducir y manipular archivos de audio en formato .wav, .aiff, .flac y .mp3 (entre otros).

Para hacer esto, primero es necesario almacenar nuestro archivo de audio en un buffer.

Un buffer es un espacio en la memoria del servidor en donde podemos almacenar información y recuperarla rápidamente. Los Buffers se almacenan en forma de arrays, así que cualquier cosa que pueda representarse como una secuencia de números puede vivir ahí. Lo más común es usarlo para almacenar archivos de audio pero también puede almacenar datos como wavetables y datasets.

Para almacenar un audio en un buffer usamos la clase Buffer y el método .read. Analicemos sus argumentos:

1. server = servidor en dónde cargar el Buffer
2. path = ruta del archivo
3. startFrame = En qué muestra se comenzará a leer el Buffer
4. numFrames = Cuantas muestras se leerán
5. action = una función a ser evaluada cuando termine de leerse el buffer
6. bufnum = Un número específico de Buffer al cual asignar nuestro archivo
*/

//Como servidor, usaremos el servidor por defecto, alamcenado de manera automática por SC en la variable "s"
Buffer.read(server: s);

/*
Para la ruta del archivo se usa un string, el cuál se puede obtener de varias maneras:

1) Arrastrando el archivo de audio desde nuestra computadora a SC, lo cual dará como resultado el string con la ruta del archivo: */

~ruta = ; //Arrastra aquí el archivo
Buffer.read(server: s, path: ~ruta);

//2) Utilizar código para hacer referencia a una ruta relativa de la carpeta que contiene nuestro archivo (y no al directorio de una computadora específica). Para ello utilizamos la siguiente línea de código:

~ruta =  thisProcess.nowExecutingPath.dirname +/+ "media" +/+ "sonidos" +/+ "lluvia_aves.aiff";

/*
thisProcess es una palabra reservada, es decir, tiene un significado especial para el lenguaje de programación. El intérprete la reconoce como parte de la sintaxis del lenguaje y no puede usarse como nombre de una variable, función, clase u otro identificador. Otros ejemplos de palabras reservadas son: var, arg, if, true, false, this, etc.

thisProcess representa el proceso del lenguaje SuperCollider en ejecución.

nowExecutingPath devuelve la ruta exacta del archivo de código que está leyendo el intérprete.

dirname devuelve el directorio que contiene al archivo

++ encadena strings

+/+ encadena strings con un "/" entre ellos.
*/

//Este segundo tipo de sintaxis para rutas de archivos garantiza la compatibilidad entre distintas computadoras y sistemas operativos.

//Luego de almacenar la ruta del archivo en una variable podemos referenciarla como argumento de Buffer.read
Buffer.read(server: s, path: ~ruta);

//Definiremos el frame de inicio como 0 si queremos leer el archivo desde el principio
(
Buffer.read(
	server: s,
	path: ~ruta,
	startFrame: 0)
)

//También podemos hacer la conversión de frames a segundos multiplicando el sampleRate de nuestro archivo por los segundos que deseemos.
(
Buffer.read(
	server: s,
	path: ~ruta,
	startFrame: 44100 * 0.5)
)

//La frecuencia de muestreo la obtendremos con ayuda del navegador de archivos de nuestra computadora o con ayuda de la clase SoundFile y los métodos .openRead y .sampleRate.

SoundFile.openRead(~ruta).sampleRate;

//Podemos usar esta clase diréctamente como argumento de Buffer
(
Buffer.read(
	server: s,
	path: ~ruta,
	startFrame: SoundFile.openRead(~ruta).sampleRate * 0.5)
)

//Posteriormente definiremos numFrames como -1 si queremos leer todos los frames del archivo
(
Buffer.read(
	server: s,
	path: ~ruta,
	startFrame: SoundFile.openRead(~ruta).sampleRate * 0.5,
	numFrames: -1
);
)

//O nuevamente podremos hacer el cálculo de los segundos que querramos con la fórmula: rate de nuestro buffer * segundos
(
Buffer.read(
	server: s,
	path: ~ruta,
	startFrame: SoundFile.openRead(~ruta).sampleRate * 0.5,
	numFrames: SoundFile.openRead(~ruta).sampleRate * 1.33,
);
)

//El siguiente argumento de Buffer consiste en una función que se ejecutará al terminar de cargar el buffer en el servidor. Es opcional (aunque útil en algunas ocasiones)
(
Buffer.read(
	server: s,
	path: ~ruta,
	startFrame: SoundFile.openRead(~ruta).sampleRate * 0.5,
	numFrames: SoundFile.openRead(~ruta).sampleRate * 1.33,
	action: {"Buffer cargado correctamente".postln}
);
)

//SuperCollider asigna un número de buffer automáticamente, aunque también podemos definirlo manualmente.
(
Buffer.read(
	server: s,
	path: ~ruta,
	startFrame: SoundFile.openRead(~ruta).sampleRate * 0.5,
	numFrames: SoundFile.openRead(~ruta).sampleRate * 1.33,
	action: {"Buffer cargado correctamente".postln},
	bufnum: 0
);
)

//Finalmente, almacenamos en una variable para poder hacer referencias posteriores a este buffer en específico.
(
~aves = Buffer.read(
	server: s,
	path: ~ruta,
	startFrame: SoundFile.openRead(~ruta).sampleRate * 0.5,
	numFrames: SoundFile.openRead(~ruta).sampleRate * 1.33,
	action: {"Buffer cargado correctamente".postln},
	bufnum: 0
);
)

/*
Una vez cargado y almacenado en una variable, el buffer responde a los métodos:
.duration (duración del buffer)
.bufnum (número de buffer en el servidor)
.numFrames (número de muestras del buffer)
.numChannels (número de canales del buffer)
.sampleRate (frecuencia de muestreo del buffer)
.query (número de buffer, número de muestras, número de canales y frecuencia de muestreo)
.plot (visualizar el buffer)
.play (reproducir el buffer)
*/

~aves.duration;
~aves.bufnum;
~aves.sampleRate;
~aves.numFrames;
~aves.numChannels;
~aves.query;
~aves.plot;
~aves.play;

/*
Para cargar una carpeta entera de audio el proceso es similar.

Primero definimos la ruta de la carpeta. Terminamos su dirección con un "*"
*/

~rutaCarpeta = thisProcess.nowExecutingPath.dirname +/+ "media" +/+ "sonidos" +/+ "*";

/*
Después utilizaremos la clase SoundFile y el método .collectIntoBuffers. Los argumentos de este método son:
path: la ruta de la carpeta
server: el servidor en donde se alojarán estos buffers.

También agregaremos una variable global con la cuál hacer referencia a esta carpeta
*/

~carpetaSonidos = SoundFile.collectIntoBuffers(~rutaCarpeta,s);

//Después de este proceso obtendremos un arreglo en la variable ~carpetaSonidos. Para referenciar un sonido se usa su índice entre corchetes. Una referencia de este tipo responde a los mismos métodos listados arriba (.query, .play, .sampleRate, etc.)
~carpetaSonidos[3].play;
~carpetaSonidos[3].query;
~carpetaSonidos.size;

//Una vez almacenados los buffers en el servidor, existen dos clases de SuperCollider capaces de reproducirlo: PlayBuf y BufRd. Veamos ambas:

/*
1) PlayBuf
La clase PlayBuff posee los siguientes argumentos:

numChannels: Número de canales del buffer a leer
bufnum = Número de buffer a utilizar (lo llamamos con .bufnum)
rate: Velocidad de reproducción (se pueden usar valores negativos para reproducir en reversa)
trigger: Una señal que al activarse provoque el reinicio de la reproducción
startPos:  En qué muestra se comenzará a reproducir el Buffer
loop:  0 = reproducción en loop activada, 1 = reproducción en loop desactivada
doneAction: acción a realizarse con el nodo cuando el buffer termine de reproducirse
*/

/*
Antes de implementar PlayBuf en una definición de síntesis conviene hacer un pequeño paréntesis referente a la frecuencia de muestreo.

Cuando cargamos un archivo de audio en un buffer, este conserva su frecuencia de muestreo original, la cual puede ser distinta a la frecuencia de muestreo con la que corre nuestro servidor.

El servidor reproduce el buffer muestra por muestra al ritmo de su propio reloj interno. Si las frecuencias no coinciden, el archivo se reproducirá más rápido o más lento de lo esperado, modificando su altura.

Para prevenir o corregir este desfase, existe el generador de unidades llamado BufRateScale, el cual calcula
automáticamente la proporción entre ambas frecuencias con la operación:

frecuencia de muestreo del Buffer / frecuencia de muestreo del servidor

Al utilizar esta proporción en el argumnento "rate" de PlayBuf, garantizamos que el archivo se reproduzca a la velocidad y altura correctas, sin importar con qué frecuencia de muestreo fue grabado originalmente.
*/

~carpetaSonidos[8].sampleRate;

//Sin BufRateScale
(
{
	PlayBuf.ar(
		numChannels: 2,
		bufnum: ~carpetaSonidos[8].bufnum,
		doneAction: 2);
}.play
)

//Con BufRateScale
(
{   var bufnum = ~carpetaSonidos[8].bufnum;
	PlayBuf.ar(
		numChannels: 2,
		bufnum: ~carpetaSonidos[8].bufnum,
		rate: BufRateScale.ir(bufnum),
		doneAction: 2);
}.play
)

//Integremos PlayBuf a una definición de síntesis:
(
SynthDef(\reproductor,{
	arg bufnum = 0, rate = 1, t_trig = -1,  posIn = 0, loop = 0, rel = 1, gate = 1, amp = 0.6;
	var proporcion, sig, env;

	proporcion = BufRateScale.ir(bufnum);

	sig = PlayBuf.ar(
		numChannels: 2,
		bufnum: bufnum,
		rate: proporcion * rate,
		trigger: t_trig,
		startPos: BufFrames.ir(bufnum) * posIn,
		loop: loop,
		doneAction: 2);

	env = EnvGen.ar(
		envelope: Env.asr(
			sustainLevel: 0.6,
			releaseTime: rel),
		gate: gate,
		doneAction: 2
	);

	sig = sig * env * amp;

	Out.ar(0, sig);
}).add;
)
//Ahora probemos usar esta definición de síntesis para reproducir diferentes buffers.
(
~cantoR = Synth(\reproductor,
	[
		\bufnum, ~carpetaSonidos[0].bufnum,
		\posIn, 0
	]
);
)

~cantoR.set(\t_trig, 1);
~cantoR.set(\rel, 3, \gate, 0);

(
~gallinaR = Synth(\reproductor,
	[
		\loop, 1,
		\bufnum, ~carpetaSonidos[1].bufnum
	]
);
)

~gallinaR.set(\amp,1);
~gallinaR.set(\t_trig,1);
~gallinaR.set(\rel, 3, \gate, 0);

(
~miauR = Synth(\reproductor,
	[
		\loop, 1,
		\bufnum, ~carpetaSonidos[6].bufnum
	]
);
)

~miauR.set(\amp,1);
~miauR.set(\rate,-1);
~miauR.set(\gate,0);

/*
2) BufRd
La siguiente clase que podemos usar para reproducir audio es BufRd.

BufRd es un lector de buffers que necesita que especifiquemos un cursor de reproducción, el cuál indicará a BufRd qué muestra leer en cada momento. Este cursor se especifica en el argumento "phase".

Para generar este cursor podemos utilizar Line o Phasor.

Line creará un cursor con un punto de inicio y uno de final.

*/
(
{
var bufnum = ~carpetaSonidos[4].bufnum;

	BufRd.ar(
		numChannels: 2,
		bufnum: bufnum,
		phase: Line.ar(
			start: 0,
			end: BufFrames.ir(bufnum),
			dur: BufDur.ir(bufnum),
			doneAction: 2)
	)
}.play;
)

//El mismo proceso de trayectoria entre dos puntos con el argumento loop = 1 puede realizarse con un Phasor: una rampa que conecta dos valores en determinado tiempo pero al alcanzar al último, se reinicia.
(
~ladrido = {
	arg rate = 1;
	var bufnum, proporcion;

	bufnum = ~carpetaSonidos[4].bufnum;
	proporcion = BufRateScale.ir(bufnum);

	BufRd.ar(
		numChannels: 2,
		bufnum: bufnum,
		phase: Phasor.ar(
			rate: proporcion * rate,
			start: 0,
			end: BufFrames.ir(bufnum)
		),
		loop: 1
	)
}.play;
)

~ladrido.set(\rate, -1000);
~ladrido.release(3);

//La ventaja de BufRd es que podemos utilizar distintos generadores de unidades para controlar la fase, no necesariamente Line o Phasor
(
~ladrido = {
	arg rate = 1, freq = 1;
	var bufnum, proporcion;

	bufnum = ~carpetaSonidos[4].bufnum;
	proporcion = BufRateScale.ir(bufnum);

	BufRd.ar(
		numChannels: 2,
		bufnum: bufnum,
		phase: SinOsc.ar(freq).range(0,BufFrames.ir(bufnum)),
		loop: 1
	)
}.play;
)

~ladrido.set(\freq,5);

/*
Notas finales:

El mayor número de buffers que podemos almacenar en el servidor son 1024. La mayoría del tiempo son suficientes si los administramos correctamente. Si quisiéramos utilizar un número de buffers máximos diferente, podemos cambiarlo en las configuraciones del servidor.
*/

s.options.dump; //Visualizar todas las configuraciones del servidor

s.options.numBuffers; //Visualizar el número de Buffers máximos establecido.

s.options.numBuffers = 333;//Establecer un nuevo número

s.reboot; //Reiniciar el servidor

//Para administrar mejor nuestros recursos, es útil liberar ciertos buffers en el servidor con el método .free
~aves.free;

//O liberarlos todos sin distinción
Buffer.freeAll;

