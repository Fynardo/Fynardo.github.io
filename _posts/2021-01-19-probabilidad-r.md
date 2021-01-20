---
layout: post
title: Estudiando juegos de azar con R&#58; La Ruleta
date: 2021-01-19
category: estadistica
readtime: 7
tags: estadistica, probabilidad, R
---

En esta entrada vamos a estudiar el funcionamiento desde el punto de vista probabilístico de uno de los juegos de azar más populares: <strong>La ruleta</strong>. Además, implementaremos nuestra propia ruleta en R, que nos permitirá realizar simulaciones y experimentos.
<!-- excerpt-end -->


### Contenido
{: .no_toc}

1. TOC
{:toc}


### Introducción
La ruleta es uno de los juegos de azar más conocidos e icónicos de los casinos y salones de juego a lo largo de su
historia, además de ser habituales en todo el mundo. Como todo juego de azar, es posible estudiar sus características y
comportamiento desde el punto de vista matemático, buscando la forma de vencer a la banca. A lo largo del tiempo, se
han planteado multitud de teorías y estrategias que presumen de ser capaces de ganar a la banca de forma consistente,
pero, ¿es realmente posible conseguir tal objetivo?

<figure>
  <img src="{{ site.url }}/assets/2021-01-19/ruleta.jpg" class="post-content-image"/>
  <figcaption>Figura 1: Ruleta Europea (fuente: <a href="https://es.wikipedia.org/wiki/Ruleta">Wikipedia</a>).</figcaption>
</figure>
{: .post-content-image-caption #fig-1}


A lo largo de esta entrada estudiaremos el funcionamiento de la ruleta desde el punto de vista probabilístico e intentaremos dar respuesta a esta pregunta, comprobaremos si es viable o no ganar a largo plazo. Además, implementaremos una ruleta que nos permita realizar simulaciones de un subconjunto de jugadas y comparar los resultados con la teoría. Todo el código mostrado está disponible en el [repositorio]({{ site.url }}/assets/2021-01-19/ruleta.R).

### Tipos de ruleta
Existen 2 variantes principales, conocidas como ruleta europea y americana. Ambas comparten un total de 37 números, divididos en 18 números de color rojo, 18 números de color negro y 1 número de color verde (el 0). La diferenciaentre estos tipos es que la ruleta americana contiene 1 número más que la europea, el 00, sumando 38 números en total.

En esta entrada nos centraremos en la ruleta europea, pero todos los cálculos son extrapolables al caso de la
americana, simplemente adaptando el comportamiento añadido del 00.


### Cálculo de probabilidades teóricas

Empecemos calculando la probabilidad de ganar en una jugada cualquiera, para ello vamos a utilizar la **regla de LaPlace** [[1]](#ref-laplace). Es posible utilizar esta regla porque la ruleta cumple (imperfecciones físicas aparte) el requisito de que cada uno de los experimentos (tiradas) son equiprobables. La siguiente tabla muestra algunos ejemplos de jugadas habituales y sus respectivas probabilidades de victoria.

|Tipo de Apuesta | Favorables | Posibles | Prob. de éxito | Prob. de fracaso |
|:--------------:|:----------:|:--------:|:--------------:|:----------------:|
|Color           | 18         | 37       | 48.65%         | 51.35%           |
|Par/Impar       | 18         | 37       | 48.65%         | 51.35%           |
|Docena          | 12         | 37       | 32.43%         | 67.57%           |
|Columna         | 12         | 37       | 32.43%         | 67.57%           |
|Cuadro          | 4          | 37       | 10.81%         | 89.18%           |
|Pleno           | 1          | 37       | 2.70%          | 97.30%           |
{: .post-table}
Tabla 1. Resumen de probabilidades de victoria para distintas jugadas de la ruleta.
{: .post-table-caption}

Para decidir si alguna de estas jugadas tiene el suficiente potencial, debemos averiguar si estas probabilidades son rentables a largo plazo, es decir, debemos conocer la **esperanza matemática** [[2]](#ref-esperanza) de las jugadas, también conocida como ganancia media esperada. Suponiendo una variable cualquiera, su esperanza se calcula de forma similar a la media aritmética, esto es, como la suma de cada uno de los posibles valores multiplicados por su probabilidad.

Por ejemplo, la esperanza de una apuesta a color sería la siguiente:

$$ P(E) \cdot G - P(F) = (18/37) \cdot 1 - 19/37 = 0.4865 - 0.5135 = -0.027 = -2.7\% $$
{: .post-math}

Donde P(E) y P(F) son las probabilidades de ganar (éxito) o perder (fracaso) la apuesta, tal y como se calcularon en la
Tabla 1 y G la ganancia esperada de la apuesta (en este caso 1 porque la apuesta a color es 1 a 1). El resultado es
claramente desalentador, estamos ante una esperanza negativa, lo que significa que, a la larga, acabaremos perdiendo un
2.7\% de la cantidad apostada. La tabla siguiente muestra la esperanza calculada para otras jugadas.


|Tipo de Apuesta | Ganancia | Esperanza                                |
|:--------------:|:--------:|:----------------------------------------:|
|Color           | 1 a 1    | \\( (18/37) \cdot 1  - 19/37 = -2.7\% \\)|
|Par/Impar       | 1 a 1    | \\( (18/37) \cdot 1  - 19/37 = -2.7\% \\)|
|Docena          | 2 a 1    | \\( (12/37) \cdot 2  - 25/37 = -2.7\% \\)|
|Columna         | 2 a 1    | \\( (12/37) \cdot 2  - 25/37 = -2.7\% \\)|
|Cuadro          | 8 a 1    | \\( (4/37)  \cdot 8  - 33/37 = -2.7\% \\)|
|Pleno           | 35 a 1   | \\( (1/37)  \cdot 35 - 36/37 = -2.7\% \\)|
{: .post-table}
Tabla 2. Resumen de la esperanza matemática de distintas jugadas de la ruleta.
{: .post-table-caption}

Esta tabla nos permite extraer 2 conclusiones principales. La primera es que todas las jugadas tienen esperanza negativa, es decir, **todas harán que perdamos dinero** a la larga. La segunda es que aquello que es negativo para el jugador es positivo para la banca, esto significa que ese 2.7\% sobre lo apostado es el **margen de beneficio** que se asegura el propietario de la ruleta.

Es posible que te preguntes si existe una forma de generalizar el estudio de este tipo de experimentos, estás en lo cierto, cualquier jugada de la ruleta puede incluirse dentro de lo que se conoce como **experimentos de Bernoulli** [[3]](#ref-bernoulli). Cualquier experimento aleatorio en el que haya dos posibles resultados (normalmente denominados éxito y fracaso) entra dentro de esta categoría. Sin embargo, lo realmente interesante es estudiar la repetición de alguno de estos experimentos, que se conoce como **proceso de bernoulli**.
{: .post-info-box}


### La ruleta europea en R

Vamos a definir una ruleta sencilla en R que nos permita simular jugadas a color, lo haremos mediante un vector donde cada posición representa el color del número correspondiente.

```R
# Definición de la ruleta. 18 números rojos, 18 números negros y 1 número verde (0).
ruleta = c(rep(c('R','N'),18), 'V')
```
{: .post-code-chunk}

De esta forma, simular una tirada a la ruleta es trivial utilizando la función *sample* de R. Por ejemplo:

```R
# Simulación de 10 tiradas
sample(ruleta, 10, replace=T)
[1] "R" "R" "N" "R" "N" "R" "N" "N" "V" "R"
```
{: .post-code-chunk}

Obviamente podemos calcular las probabilidaes teóricas que hemos visto utilizando esta estructura para representar la ruleta.

```R
# Regla de LaPlace
prob_rojo = sum(ruleta=='R') / length(ruleta); prob_rojo
[1] 0.4864865
prob_negro = sum(ruleta=='N') / length(ruleta); prob_negro
[1] 0.4864865

# Esperanza matemática
# Juguemos al rojo!
prob_exito = prob_rojo
prob_fracaso = 1 - prob_exito # Fracaso = negro o 0
ganancia = 1; perdida = -1 # 1 € por apuesta
esperanza = prob_exito * ganancia + prob_fracaso * perdida; esperanza
[1] -0.02702703
```
{: .post-code-chunk}

Como es lógico, los resultados obtenidos son los mismos que hemos visto en la sección anterior.

### Simulación

Para llevar a cabo la simulación vamos a empezar definiendo un par de funciones que nos ayuden a encapsular un poco
todo el comportamiento de los experimentos. 

```R
# Simulación de 'n' tiradas
tirar = function(n=1){
    # Realiza un número 'n' de tiradas, por defecto 1.
    return(sample(ruleta, n, replace=TRUE))
}

# Simulación de 'n' apuestas a color
apostar = function(n=1, c='R'){
    # Realiza un número 'n' de apuestas a un color. 
    # Devuelve la cantidad ganada.
    tirada = tirar(n)
    aciertos = sum(tirada == c)
    fallos = sum(tirada != c)
    return(aciertos - fallos)
}
```
{: .post-code-chunk}

Con estas funciones lo que obtenemos es una forma sencilla de generar tiradas y otra de realizar apuestas y comprobar la ganancia obtenida.

<figure>
  <img src="{{site.url}}/assets/2021-01-19/tiradas.png" class="post-content-image"/>
  <figcaption>Figura 2: Resultados tras 5000 tiradas a color.</figcaption>
</figure>
{: .post-content-image-caption #fig-2}

La Figura 2 muestra el reparto en colores obtenido tras realizar 5000 tiradas. El comportamiento es el esperado, los 
números rojos y los negros tienen la misma probabilidad de salir, por tanto las barras son de tamaño similar. El 0 sale
mucho menos, ya que su probabilidad (1/37) es mucho menor.

Simulemos ahora 5000 sesiones de juego distintas donde jugaremos 100 veces en cada sesión. Lo que nos interesa ahora es conocer el
balance de cada una de esas sesiones, es decir cuanto hemos ganado o perdido.

```R
sesiones = replicate(5000, apostar(100))
head(sesiones)
[1] -18 8 -4 2 10 -10
```
{: .post-code-chunk}

<figure>
  <img src="{{site.url}}/assets/2021-01-19/sesiones.png" class="post-content-image"/>
  <figcaption>Figura 3: Balance en 250 sesiones de juego.</figcaption>
</figure>
{: .post-content-image-caption #fig-3}


La Figura 3 muestra parte de estas 5000 sesiones, en verde se marcan aquellas en las que hemos ganado, en rojo aquellas
donde hemos perdido. A simple vista, es complicado ver si ganamos más de lo que perdemos, cosa lógica cuando nuestra
probabilidad de victoria está cercana al 50\%. Sin embargo, podemos utilizar estos datos para calcular la esperanza
matemática resultante.

```R
esperanza_simulada = mean(sesiones); esperanza_simulada
[1] -2.5792
```
{: .post-code-chunk}

El valor obtenido es negativo, esto significa que, tras estas 5000 sesiones, hemos **perdido dinero**. Además, nótese
que obtenemos un valor muy parecido al teórico, no el exacto claro, puesto que la simulación se ve afectada por el azar.

### Conclusión
En esta entrada hemos estudiado el juego de la ruleta desde un punto de vista matemático, definiendo las jugadas como experimentos aleatorios y calculando las probabilidades de cada una. Además, mediante el estudio de la esperanza matemática, hemos visto como, a la larga, no existe forma de jugar a la ruleta y ganar de forma consistente. Por último, hemos realizado un pequeño estudio de simulación que nos ha permitido observar el comportamiento de la ruleta y de múltiples sesiones de juego.


### Referencias

[1] Regla de LaPlace, [Wikipedia](https://es.wikipedia.org/wiki/Probabilidad#Regla_de_Laplace).
{: #ref-laplace}
[2] Esperanza Matemática, [Wikipedia](https://es.wikipedia.org/wiki/Esperanza_matem%C3%A1tica).
{: #ref-esperanza}
{3] Experimento de Bernoulli. [Wikipedia](https://es.wikipedia.org/wiki/Ensayo_de_Bernoulli).
{: #ref-bernoulli}
