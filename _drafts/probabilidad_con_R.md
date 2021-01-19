---
layout: post
title: Estudiando juegos de azar con R&#58; La Ruleta
category: estadistica
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
  <img src="{{ site.url }}/assets/ruleta-draft/ruleta.jpg"/>
  <figcaption>Figura 1: Ruleta Europea (fuente: <a href="https://es.wikipedia.org/wiki/Ruleta">Wikipedia</a>).</figcaption>
</figure>
{: .post-content-image #fig-1}


A lo largo de esta entrada estudiaremos el funcionamiento de la ruleta desde el punto de vista probabilístico e intentaremos dar respuesta a esta pregunta, comprobaremos si es viable o no ganar a largo plazo. Además, implementaremos una ruleta que nos permita realizar simulaciones y comparar los resultados con la teoría. Todo el código mostrado está disponible en el [repositorio]({{ site.url }}/assets/ruleta-draft/ruleta.R).

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

Esta tabla nos permite extraer 2 conclusiones principales. La primera es que todas las jugadas tienen esperanza negativa, es decir, **todas harán que perdamos dinero**. La segunda es que aquello que es negativo para el jugador es positivo para la banca, esto significa que ese 2.7% sobre lo apostado es el **margen de beneficio** que se asegura el propietario de la ruleta.


<!-- Enlazar aquí algo de Bernoulli y la binomial -->

, esto las convierte en lo que se conoce como **experimentos de Bernoulli** [[3]](#ref-bernoulli).


### La ruleta europea en R

Vamos a definir una ruleta sencilla en R que nos permita simular jugadas a color 

```R
# Definición de la ruleta. 18 números rojos, 18 números negros y 1 número verde (0).
ruleta = c('V', rep(c('R','N'),18))
```
{: .post-code-chunk}


### Simulación

<figure>
  <img src="{{site.url}}/assets/ruleta-draft/tiradas.png"/>
  <figcaption>Figura 2: Resultados tras 5000 tiradas a color.</figcaption>
</figure>
{: .post-content-image #fig-1}


### Simulación vs Teoría
### ¿Qué ocurre en otras ruletas?
### Conclusión
### Referencias

[1] Regla de LaPlace, [Wikipedia](https://es.wikipedia.org/wiki/Probabilidad#Regla_de_Laplace).
{: #ref-laplace}
[2] Esperanza Matemática, [Wikipedia](https://es.wikipedia.org/wiki/Esperanza_matem%C3%A1tica).
{: #ref-esperanza}
{3] Experimento de Bernoulli. [Wikipedia](https://es.wikipedia.org/wiki/Ensayo_de_Bernoulli).
{: #ref-bernoulli}
