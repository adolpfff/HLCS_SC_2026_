//Lista de patrones más comunes para generar secuencias numéricas

/*
Pseq
Da como resultado los valores de un arreglo, respetando el orden del mismo. Puede repetirse y desfazarse por medio de sus argumentos.
*/

~pat_1 = Pseq([1,2,3,4,5,9],2,2);
~sec_1 = ~pat_1.asStream;
~sec_1.next;
~sec_1.reset;

/*
Pwhite
Valores aleatorios de distribución uniforme entre un número mínimo y un número máximo especificados.
*/

~pat_2 = Pwhite(0.23,10,10);
~sec_2 = ~pat_2.asStream;
~sec_2.next.round(0.01);
~sec_2.reset;

/*
Pexprand
Valores aleatorios con distribución exponencial entre un número mínimo y un número máximo especificados.
*/

~pat_3 = Pexprand(0.23,10,inf);
~sec_3 = ~pat_3.asStream;
~sec_3.next.round(0.01);
~sec_3.reset;

/*
Pbrown
Valores aleatorios entre un número mínimo y un número máximo especificados, sin embargo, los nuevos números solo se desvían del anterior por un intervalo máximo especificado.
*/

~pat_4 = Pbrown(1,1000,100,inf);
~sec_4 = ~pat_4.asStream;
~sec_4.next.round(0.01);
~sec_4.reset;

/*
Prand
Secuencia los valores de un array de manera aleatoria
*/

~pat_5 = Prand([\gato,3,5,\perro, \pato,999],inf);
~sec_5 = ~pat_5.asStream;
~sec_5.next;
~sec_5.reset;

/*
Pxrand
Secuencia los valores de un array de manera aleatoria, pero nunca repite el mismo ítem uno después del otro.
*/

~pat_6 = Pxrand([\gato,3,5],inf);
~sec_6 = ~pat_6.asStream;
~sec_6.next;
~sec_6.reset;

/*
Pwrand
Secuencia los valores de un arreglo de manera aleatoria, poniendo más probabilidades a ciertos elementos por medio de un arreglo adicional cuyos valores deben sumar 1;
*/

~pat_7 = Pwrand([\gato,3,5,\perro, \pato,999],[70,100,50,100,60,30].normalizeSum,inf);
~sec_7 = ~pat_7.asStream;
~sec_7.next;
~sec_7.reset;

/*
Pseries
Secuencia una serie aritmética. Se especifica un número inicial y el factor de incremento.
*/

~pat_8 = Pseries(0,3,inf);
~sec_8 = ~pat_8.asStream;
~sec_8.next;
~sec_8.reset;

/*
Pgeom
Secuencia una serie geométrica. Se especifica un número inicial y el factor de multiplicación.
*/

~pat_9 = Pgeom(8,2,inf);
~sec_9 = ~pat_9.asStream;
~sec_9.next;
~sec_9.reset;