/*
REPRODUCCION DE AUDIO

Dentro de SC es posible reproducir y manipular archivos de audio en formato .wav, .aiff, .flac y .mp3 (entre otros).

Para hacer esto, primero es necesario almacenar nuestro archivo de audio en un Buffer.

Un Buffer es un espacio en la memoria del servidor en donde podemos almacenar información y recuperarla rápidamente. Los Buffers se almacenan en forma de arrays, así que cualquier cosa que se pueda representar como una secuencia de números puede vivir ahí. Lo más común es usarlo para almacenar archivos de audio pero también puede almacenar datos como wavetables y datasets.

Para almacenar un audio en un buffer usamos la clase Buffer y el método .read. Analicemos sus argumentos:

1. server = servidor en dónde cargar el Buffer
2. path = ruta del archivo
3. startFrame = En qué muestra se comenzará a leer el Buffer
4. numFrames = Cuantas muestras se leerán
5. action = una función a ser evaluada cuando termine de leerse el buffer
6. bufnum = Un número específico de Buffer al cual asignar nuestro archivo
*/

//Como servidor, usaremos el servidor por defecto, alamcenado en la variable s
Buffer.read(server: s);

/*
Para la ruta del archivo se usa un string, el cuál se puede obtener de varias maneras:

1) Arrastrando el archivo de audio desde nuestra computadora a SC, lo cual dará como resultado el string con la ruta del archivo: */

~ruta = ; //Arrastra aquí el archivo
Buffer.read(server: s, path: ~ruta);

//2) También se puede agregar el audio colocándolo en una ruta relativa que haga referencia al archivo de SuperCollider con el que estemos trabajando (y no al directorio individual de una computadora específica). Para ello utilizamos la siguiente línea de código:

~ruta =  thisProcess.nowExecutingPath.dirname +/+ "media" +/+ "sonidos" +/+ "miau.wav";

/*
thisProcess es una palabra reservada, es decir, tiene un significado especial para el lenguaje de programación. El intérprete la reconoce como parte de la sintaxis del lenguaje y no puede usarse como nombre de una variable, función, clase u otro identificador. Otros ejemplos de palabras reservadas son: var, arg, if, true, false, this, etc.

thisProcess representa el intérprete de SuperCollider en ejecución.

nowExecutingPath devuelve la ruta exacta del archivo de código que está leyendo el intérprete.

dirname devuelve el directorio que contiene al archivo

++ encadena strings

+/+ encadena strings con un "/" entre ellos.
*/

//Este segundo tipo de sintaxis para rutas de archivos garantiza la compatibilidad entre distintas computadoras y sistemas operativos.

//Luego de almacenar la ruta del archivo en una variable podemos referenciarla


thisProcess = 4;
~false = 4;

que , y sirve como puerta de entrada a configuración de plataforma, argumentos de línea de comandos, el compilador/intérprete interno, y la comunicación OSC del lenguaje mismo (diferenciándolo del servidor de audio, que se controla mediante el objeto Server, típicamente s o Server.default).


thisProcess se refiere al proceso del lenguaje actual.
Main.thisProcess

Para efectos prácticos en este ejemplo usaremos todos los argumentos predeterminados, especificando únicamente la ruta

 */
~miau =  Buffer.read(path: ~ruta);

~miau.getn(0, 1000, { |array|
    array.postln; // o cualquier otro procesamiento
});

/*
Una vez cargado el buffer, este responde a los métodos:
.plot (visualizar el buffer)
.play (reproducir el buffer)
.free (liberar el buffer)
*/
~miau.postln;
~miau.size;

~miau.plot();
~miau.play;
~miau.free; //(Después de ejecutar esto es necesario volver a cargar el buffer)

/*
También es posible obtener información del buffer con los métodos
.duration (duración del buffer)
.numFrames (número total de muestras contenidas en el Buffer)
.bufnum (número de buffer con el cuál es identificado en el servidor)
.numChannels (número de canales del buffer)
.sampleRate (frecuencia de muestreo del buffer)
.query (Obtener con un solo comando el número de buffer, el número de muestras y canales, y la frecuencia de muestreo)
*/

~miau.duration;
~miau.numFrames;
~miau.bufnum;
~miau.numChannels;
~miau.sampleRate;
~miau.query;

/*
Podemos decidir cargar un archivo a la vez pero muchas veces quisiéramos poder trabajar con una colección de audios. Esto se puede lograr utoilizando la clase SoundFile.collectIntoBuffers de la siguiente manera:

Primero definimos la ruta de una carpeta
*/

~rutaCarpeta = thisProcess.nowExecutingPath.dirname ++ "/sonidos/*";

//Insertamos la ruta en la clase SoundFile.collectIntoBuffers
~carpetaSonidos = SoundFile.collectIntoBuffers(~rutaCarpeta,s);

//Se crea un array en la variable ~carpetaSonidos. Para referenciar un sonido se usa su índice entre corchetes
~carpetaSonidos[2].play;


/*Finalmente pasamos a la creación de un SynthDef que reproduzca el Buffer, en él, utilizaremos el objeto PlayBuff para reproducir el archivo. Los argumentos de playBuf son:
numChannels = Número de canales del buffer a leer (este argumento no es modulable, por lo que hay que tenerlo claro desde el principio)
bufnum = Número de buffer a utilizar (lo llamamos con ~miau.bufnum)
rate = Velocidad de reproducción (se pueden usar valores negativos para reproducir en reversa)
trigger = Una señal que al activarse provoque el reinicio de la reproducción
startPos =  En qué muestra se comenzará a reproducir el Buffer
loop =  0 = reproducción en loop activada, 1 = reproducción en loop desactivada
doneAction = acción a realizarse con el sintetizador cuando el buffer termine de reproducirse
*/

(
SynthDef(\reproduccion,{
	arg bufnum = 0, rate = 1, loop = 0, amp = 0.6, pos = 0, t_trig = 0;
	var sig, env, scale, startPos;

	scale = BufRateScale.kr(~miau); //Con esta línea nos aseguramos que la frecuencia de muestreo de nuestro audio coincida con la de nuestro proyecto
	startPos = BufFrames.kr(bufnum) * pos;

	sig = PlayBuf.ar(numChannels: 2, bufnum: bufnum, rate: scale * rate, trigger: t_trig, startPos: startPos,loop: loop, doneAction: 2);

	sig = sig * amp;

	Out.ar(0, sig);
}).add;
)


~miauP = Synth(\reproduccion, [\bufnum, ~carpetaSonidos[0].bufnum , \pos, 0.8]); //Reproducir una vez (especificar buffer y posición de inicio (del 0 al 1))
~miauP = Synth(\reproduccion,[\loop, 1, \bufnum, ~carpetaSonidos[4].bufnum]); //Reproducir enn loop (especificar buffer)
~miauP.set(\t_trig, 1); //Reiniciar el sonido con un trigger
~miauP.set(\rate, 0.6,\amp, 0.4); //Ajustar parámetros de rate y amplitud
~miauP.set(\loop, 0); //Detener el loop (detiene el sintetizador en cuanto acaba el sonido)

