---
layout: post
title: Arduino Task Timer
date: 2017-08-13
category: embed
tags: task-timer, timer, prescaler
---


En mi día a día me suele costar bastante controlar cuánto tiempo he dedicado a una tarea en concreto, cuánto tiempo llevo sin tomar un pequeño descanso, o en cuántas tareas distintas he trabajado en una jornada. Más que complicado, llevar cuenta de este tipo de cosas suele ser aburrido y pesado. ¿Solución? ¡Que lo haga otro! Es una tarea repetitiva perfecta para una máquina. Los requisitos que me he planteado para ello son los siguientes:

* *Visual*, un simple vistazo debería ser suficiente.
* Poco intrusivo, tiene que permitirme seguir trabajando como si no existiese.
* Cómodo y automatizado, se trata de que ahorre trabajo, no debería generar más.

La solución que se me ha ocurrido pasa por utilizar un Arduino, una pantalla LCD y un par de LEDs. La idea es que la LCD muestre la tarea en la que estoy trabajando en cada momento y un contador de tiempo. Además, los LEDs permitirán generar *alarmas* que me permitan gestionar el tiempo de trabajo y descanso, por ejemplo, para avisar cuando llevo 2 horas de trabajo para descansar unos 10 o 15 minutos. 


### Funcionamiento
Básicamente, el sistema recibe el nombre de una tarea, cuenta el tiempo que se trabaja en ella (en segundos) y, cuando llegue una nueva tarea, reporta el tiempo trabajado en la anterior. Además, para aportar funcionalidad, dispone de 2 LEDs que avisan si llega el momento de tomar un descanso (tras 2 horas de trabajo) o si por el contrario ese descanso se ha alargado y uno no se ha dado cuenta (15 minutos). Para que resulte cómodo pasar del *modo trabajo* al *modo tiempo libre* he colocado un pulsador que hará que los contadores se reinicien, los LED se apaguen y se cambie de modo. Añadir que, cuando el sistema está en *modo tiempo libre*, éste sigue registrando el tiempo transcurrido, para ello utiliza una tarea concreta llamada **freetime**, la cual reportará como otra tarea cualquiera cuando se cambie de modo activando el pulsador.

### Diagrama de conexión hardware
El cableado es bastante directo ya que no hay ningún componente muy particular, simplemente acordarse de colocar resistencias en los LED, asegurarse de trabajar con la lógica correcta del pulsador y conectar de forma ordenada los pines de la pantalla LCD al Arduino para que funcione correctamente.

<img src="{{ site.url }}/assets/2017-13-08/diagrama.png" class="post-content-image"/> 

### Un vistazo al código
Por supuesto, el código está disponible en [github](https://github.com/Fynardo/task-timer). No se trata de un código complejo, de hecho, es probable que lo más engorroso sea trabajar con la pantalla LCD, pero la librería **LiquidCrystal** simplifica mucho el trabajo. El otro componente principal del sistema, además de la pantalla, es la gestión del tiempo. Lo más común es trabajar con las interrupciones de tiempo a través de funciones ya implementadas como *millis* o *delay*, pero cuando se necesita un control más fino es necesario trabajar directamente con los registros. 

Hagamos un pequeño inciso en este tema porque me parece muy interesante. Antes de nada, comentar que existen recursos en Internet bastante completos sobre el tema como por [este](http://www.instructables.com/id/Arduino-Timer-Interrupts/) por ejemplo, aunque siempre recomiendo ir directamente al *datasheet* ya que los de AVR están bastante completos y bien explicados. Bueno, básicamente, Arduino dispone de una serie de registros contadores, en el caso de Arduino UNO son Timer0 (8 bits), Timer1 (16 bits) y Timer2 (8 bits), los cuales actualizan su valor en cada *tick* del reloj. Cada vez que estos registros alcanzan su valor máximo (255 para los de 8 bits y 65535 para el de 16 bits) vuelven al 0. Sabiendo que la frecuencia de reloj a la que trabaja el AVR es de 16MHz, es posible contar cuanto tiempo pasa hasta que cierto registro alcanza un valor arbitrario. Además, cada registro *timer* dispone de una serie de opciones adicionales de configuración, una de las más interesantes es el *prescaler*. El *prescaler* actúa como divisor del reloj, es decir, dicta la frecuencia de actualización del *timer*. La frecuencia real de actualización de un *timer* se calcula como la frecuencia del reloj (16MHz) entre el valor del *prescaler* escogido (los valores válidos son 1, 8, 64, 256 y 1024). 

Pongamos un ejemplo suponiendo que el *prescaler* es igual a 1024. El *timer* se actualizará 16.000.000 / 1024 = 15.625 veces por segundo. Esto significa que cada vez que el valor del timer sea 15.624 sabemos que ha pasado un segundo. La forma de decirle a Arduino que en este justo instante necesitamos que nos avise mediante una interrupción del reloj es configurando un registro de comparación de valores, entonces, más que atender a la interrupción de *overflow* del registro, nos centramos en la generada cuando el *timer* alcanza ese valor. Viendo esto en la práctica, la función **set\_timer** del código hace básicamente esto, configura el Timer1 para conseguir una interrupción cada segundo. 

Se que no es la explicación más exhaustiva del mundo, pero espero que de una idea de como funciona el tema para construir e investigar a partir de ella. 

### Almacenando los datos 
Que alguien lleve la cuenta de cuanto trabajamos en un día y en que tareas se va dicho tiempo no vale de nada si no conservamos dicha información. He creado un pequeño script en bash encargado de enviar al Arduino el nombre de las tareas en las que voy trabajando y recoger la información de tiempo de las demás. El procesado de los datos como por ejemplo el tiempo total de cada tarea o cuantos días se ha trabajado en una tarea concreta está actualmente en estado *WIP*, pero espero rematarlo y crear una nueva entrada en breve.

**Nota**. Si os fijais en el código, cada vez que se ejecuta el script se inicia la conexión serie, esto lo hago para no mantenerla abierta y evitar así el consumo de CPU que conlleva. El detalle importante aquí es que Arduino tiende a reiniciarse cada vez que se abre una conexión serie (esto se debe a cierto comportamiento relativo a la carga de los programas, ya que el pin DST está *puenteado* al reset del Arduino), entonces, para que el script funcione es necesario evitarlo. La forma más sencilla que he encontrado es colocar un condensador entre los pines **GND** y **Reset**. 














