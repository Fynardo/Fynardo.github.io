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
Todo el código está disponible en el [repositorio]({{ site.url }}/assets/ruleta-draft/ruleta.R)

### Tipos de ruleta
<!-- TODO Foto de una ruleta (de la wikipedia supongo) -->
<!-- TODO Diferencias entre americana / europea (0 vs 00) -->



### Cálculo de probabilidades teóricas

Podemos calcular las probabilidades de acertar la tirada utilizando la regla de LaPlace [[1]](#ref-laplace)
<!-- Tabla de LaPlace para todas las apuestas -->

|Tipo de Apuesta | Favorables | Posibles | Prob. de ganar|
|:--------------:|:----------:|:--------:|:-------------:|
|Color           | 18         | 37       | 48,65%        |
|Par/Impar       | 18         | 37       | 48,65%        |
| ...     | ...         | ...       | ...        |
{: .post-table}


<!-- Tabla de esperanza matemática -->




### La ruleta europea en R

```R
# Definición de la ruleta. 18 números rojos, 18 números negros y 1 número verde (0).
ruleta = c('V', rep(c('R','N'),18))
```
{: .post-code-chunk}


### Simulación

<figure>
  <img src="{{site.url}}/assets/ruleta-draft/tiradas.png"/>
  <figcaption>Figura 1: Resultados tras 5000 tiradas a color.</figcaption>
</figure>
{: .post-content-image #fig-1}


### Simulación vs Teoría
### ¿Qué ocurre en otras ruletas?
### Conclusión
### Referencias

[1] Regla de LaPlace, [Wikipedia](https://es.wikipedia.org/wiki/Regla_de_sucesi%C3%B3n).
{: #ref-laplace}
[2] Esperanza Matemática, [Wikipedia](https://es.wikipedia.org/wiki/Esperanza_matem%C3%A1tica).
{: #ref-esperanza}


