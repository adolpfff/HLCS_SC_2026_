/*
EXPANSION MULTICANAL

Hasta ahora hemos trabajado con señales de un canal. Pero ¿qué pasaría si quisieramos crear un sonido de dos o incluso más canales? */
(
{SinOsc.ar(mul:0.3)}.play;
s.meter;
)

/*
Una de las formas más sencillas de generar señales multicanal son los arreglos. 

Una función .play con un arreglo de Ugens será una señal de dos canales.
*/
(
{[SinOsc.ar(mul:0.3),PinkNoise.ar(mul:0.4)]}.play;
s.meter;
)

//Supercollider mandará el primer elemento del arreglo, a la primera salida de audio de nuestro dispositivo de sonido, el segundo a la segunda, y así sucesivamente.

//Si queremos mandar la misma señal a dos salidas de un sistema estereo podríamos escribir
(
{[SinOsc.ar(mul:0.3),SinOsc.ar(mul:0.3)]}.play;
s.meter;
)

//Pero tanbién podríamos aplicar el método .dup
(
{SinOsc.ar(mul:0.3).dup}.play;
s.meter;
)

//Sintaxis alternativa
(
{SinOsc.ar(mul:0.3)!2}.play;
s.meter;
)

//Cuando usamos un arreglo para los argumentos de un generador de unidades, SuperCollider lo convierte a un arreglo de Ugens, cada uno con los argumentos especificados
(
{Pulse.ar(freq: [60.midicps,67.midicps], mul: 0.4)}.play;
s.meter;
)

//Cuando efectuamos una operación de arreglos de ugens, se siguen las mismas reglas de operaciones con arreglos. 

//En este ejemplo se aplican las multiplicaciones entre índices identicos de cada uno de los arreglos. 

[5,3,10] * [8,4,5];

(
{
var sig, mod;
sig = SinOsc.ar([200, 800], mul: [0.6,0.1]);
}.play;
s.meter;
)

/*
El sistema anterior solo nos permite colocar la totalidad de un señal en un único altavoz. 

Si lo que queremos es una posición exacta de paneo en un sistema estereo, utilizaremos generadores de unidades diseñados para expandir la señal de entrada a dos o más canales. 

El más común de todos ellos es Pan2. Pan2 recibe una señal de audio de un canal y la posiciona entre dos fuentes estereo.
*/
(
SynthDef.new(
    \panSynth,
    {
        var sig, env, pan, traj;
        sig = Saw.ar(200,0.35);
        env = Line.kr(0.5,0.5,10,doneAction:2);
        sig = sig * env;
        traj = Line.kr(-1,1,10);
        pan = Pan2.ar(in: sig, pos: traj);
        Out.ar(0,pan);
    }
).play; 
s.meter;
)

//Con la sintaxis antes vista (!x) podemos crear de manera sencilla múltiples generadores de unidades con parámetros individuales. Sin embargo, al reproducirlo, solo escucharíamos los primeros dos.
(
{
    var frecs;
    frecs = {rrand(200,300)}!10;
    Saw.ar(freq: frecs, mul: 0.3)
}.play;
)

//Si quisiéramos escuchar el arreglo completo de señales usaríamos Splay, que toma como entrada una señal multicanal y distruibuye sus elementos de manera ordenada y equidistante en el espacio estreo.
(
{
    var frecs, sig;
    frecs = {rrand(200,300)}!10;
    sig = Saw.ar(freq: frecs, mul: 0.3);
    Splay.ar(sig);
}.play;
s.meter;
)

//También sería posible usar Mix, a fin de reducirlo todo a un canal.
(
{
    var frecs, sig;
    frecs = {rrand(200,300)}!10;
    sig = Saw.ar(freq: frecs, mul: 0.1);
    Mix.ar(sig);
}.play;
s.meter;
)

//Para creación sonora de más de dos canales, SuperCollider cuenta con las clases Pan4 para disposición cuadrafónica, PanAz para cualquier número de canales (sin elevación) y VBAP para cualquier número de altavoces equidistantes. También posee soporte para ambisonics de hasta 5to orden por medio de la librería de extensiones de Ambisonic Toolkit