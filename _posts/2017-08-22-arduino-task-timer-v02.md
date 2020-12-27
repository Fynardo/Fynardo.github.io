---
layout: post
title: Arduino Task Timer v0.2
date: 2017-08-22
category: embed
tags: task-timer
---

Tras probar el sistema durante unos días en *entorno real*, esto es, en algunas tareas diarias, he visto deficiencias en el planteamiento de varios casos de uso, lo cual me ha llevado a rediseñar alguno de ellos y a mejorar otros. Tras ello, presento la versión v0.2 de **Arduino Task-Timer** con los cambios comentados a continuación.

# Log de cambios

* Se han eliminado todas las comunicaciones iniciadas desde el Arduino cuando se pulsa el switch.
* Ya no se almacenan tiempos relativos a la tarea *freetime* en el modo **FREETIME**.
* El modo **FREETIME** se sigue activando mediante el switch y controla el tiempo para la alarma.
* Se han añadido 2 nuevos modos de funcionamiento: **PAUSE** y **STOP**, de forma que ahora se cuenta con 4 modos distintos.
* Los modos **PAUSE** y **STOP** se activan/desactivan mediante órdenes por el puerto serie.
* La pantalla LCD ahora muestra el estado actual de forma más clara cuando sea necesario.


# Cambios en el funcioniamiento del switch y el modo *FREETIME*

Los mensajes enviados desde el Arduino a través de USB cuando se pulsa el switch no tienen sentido si no se mantiene la conexión abierta (lo más probable es que no se lleguen a recibir o se haga a destiempo). Esto no era un problema cuando hacía las pruebas utilizando el monitor serie del IDE de Arduino, pero ese no es el entorno real esperable. Ahora, pulsar el switch hace que el sistema pase al modo **FREETIME** como antes, pero no reporta la información de la tarea en la que se estaba trabajando, si no que mantiene dicha tarea en espera hasta que se vuelva a pulsar el switch. Lo que sí se mantiene es el contador relativo al tiempo de descanso (15 minutos por defecto), el cual se muestra en la LCD igual que antes.

Por tanto, desaparece esa tarea *freetime* definida por el sistema ya que, tras estas primeras ejecuciones, considero que no tiene relevancia almacenar dicha información. La razón es que el tiempo utilizado en descansar es importante para el usuario, pero no es necesario plasmarla en el seguimiento del proyecto o de la jornada de trabajo, por tanto no necesita ser almacenada ni procesada.

# Nuevos modos implementados

Para dar cabida a varios casos de uso he implementado 2 nuevos modos de funcionamiento en el sistema. 

Por un lado está el modo **PAUSE**, el cual mantiene el sistema en espera, esto es, detiene todos los contadores hasta que se desactive dicho modo. La razón es que si surge algún tipo de imprevisto que requiera retirar la atención de la tarea de forma momentánea (leer o responder a un mail, atender una llamada, una conversación con un compañero, etc.) sólo existían 2 posibilidades, añadir ese tiempo a la tarea o pasar al modo **FREETIME**. Ninguna me parecía viable, la primera aumenta el tiempo de una tarea de forma incorrecta, la otra implica usar el tiempo de descanso de un modo para el cual no ha sido diseñado. El modo **PAUSE** se activa enviando el carácter *','* (coma) por el puerto serie y se desactiva de la misma forma. La LCD también mostrará claramente que el modo está activo y la tarea pausada.

Por otro lado, el sistema presentaba problemas cuando terminaba la última de mis tareas de la jornada y quería almacenar el tiempo empleado y *cerrar*. No existía un caso de uso para ello, para arreglarlo he implementado el modo **STOP**. Este modo se activa enviando el caracter *'.'* (punto) por el puerto serie y se desactiva cuando se inicia una nueva tarea (de hecho es el modo en el que arranca el sistema). Activar el modo **STOP** hace que el sistema devuelva el tiempo de la tarea en la que se estaba trabajando y resetea el sistema a los valores de inicio.


# Conclusiones

Con estos cambios el sistema gana en autonomía, la transición entre modos es más
ágil y se cubren más casos de uso. Tras nuevas jornadas de pruebas veré si es necesario refinar más elementos.











