/*
GRABACION DE AUDIO EN SUPERCOLLIDER

SuperCollider permite grabar directamente la salida de audio del servidor.
Para hacerlo, el servidor debe estar encendido y debe existir algún proceso sonoro en reproducción.

Algunas fromas de grabar archivos son:

1. s.record
El método .record inicia la grabación de la salida principal del servidor.
De manera predeterminada, SuperCollider guarda el archivo dentro de la carpeta usuario/musica/SuperCollider Recordings.
*/

(
{Saw.ar(freq: [320, 330],mul: 0.2)}.play;
s.record; //Iniciar grabación del servidor
)

s.stopRecording; //Detener y guardar la grabación

//.record también posee más argumentos que podemos explorar:

s.record(
    path: , //cambiar la ruta de almacenamiento
    bus: , //grabar una salida específica
    numChannels: , //número de canales a registrar (por defecto 2)
    node: , //identificador del nodo a registrar
    duration: //duración de la grabación a registrar (por defecto inf)
);

/*
2. s.makeGui
El método .makeGui abre una ventana con controles gráficos asociados al servidor. Desde esta ventana podemos encender o apagar el servidor, observar sus niveles y controlar la grabación mediante los botones correspondientes.
*/
(
{Pulse.ar(freq: [320, 330],mul: 0.2)}.play;
s.makeGui;
 //Desplegar ventana e iniciar grabación desde esa interfaz
)

/*
3. Grabación desde SuperCollider IDE
También es posible iniciar y detener una grabación desde la barra de estado del servidor ubicada en la parte inferior de SuperCollider IDE.
*/

{SinOsc.ar(freq: [320, 330],mul: 0.2)}.play;