---
layout: post
title: ¿Por qué realicé un <em>fork</em> de scrapyd-deploy?
category: data
date: 2021-03-24
date: 2021-03-24
readtime: 4
tags: datos, scrapers, scrapy, scrapyd, scrapyd-client, python
---

En mis proyectos de *scraping*, como [COVIB](https://t.me/cocasovideogamesbot) por ejemplo, necesito flexibilidad a la hora de desplegar las *spiders* y así simplificar el proceso de desarrollo e integración. Las herramientas existentes son útiles, pero algunas no parecen recibir la atención suficiente por parte de sus *maintainers*. En esta entrada relataré qué necesidades tenía, cómo las solventé y por qué considero que a veces el software libre falla. **Disclaimer**: Se viene chapa.

<!-- excerpt-end -->

<!-- Faltan 200 links -->

### Contenido
{: .no_toc}

1. TOC
{:toc}


### Introducción

Siempre que tengo ocasión, me gusta recalcar lo fan que me considero del software libre, de la comunidad que lo rodea y de muchos de sus ideales, que tan bien resumidos encuentro en este extracto del manifiesto de GNU [[1]](#ref-manifest): **The fundamental act of friendship among programmers is the sharing
of programs**.

Sin embargo, bien es sabido que *&laquo;un gran poder, conlleva una gran responsabilidad&raquo;* [[2]](#ref-pparker). En el mundo del software
libre solemos hablar de responsabilidades en lo relativo al mantenimiento de los proyectos. En ocasiones, este
mantenimiento es insuficiente y puede llevar a consecuencias catastróficas [[3]](#ref-heartbleed). En nuestro podcast, **Salvados por la Computación**[[4]](#ref-SC), hablamos sobre qué pasa cuando el software libre no funciona, qué problemas genera, qué retos debemos solucionar y qué consecuencias puede tener, dejo el link por [aquí.](https://www.youtube.com/watch?v=QZAa_1BEaz0)

Volviendo al tema, en una [entrada anterior]({{site.url}}/data/2021/02/12/scrapyd-configuracion-despliegue.html), describí cuál es la forma de trabajar con **scrapy** que mejor se adapta a mis necesidades.
Entre otras cosas, utilizo **scrapyd-client**, una librería que simplifica mucho la comunicación y el manejo de **scrapyd** (el servidor de ejecución de *spiders*).
En general, las utilidades relativas a **scrapy** están mantenidas por la gente de Zyte pero, al parecer, no todas reciben la misma atención y **scrapyd-client** parece estar en el saco de las olvidadas.

### Scrapyd-client, flexibilidad y ficheros de configuración

Resumiendo, una de las opciones que me interesa tener en cuenta a la hora de desplegar *spiders* es la propia configuración
del proyecto (definida en el fichero *settings.py*). Por ejemplo, disponer de configuraciones distintas en función de si voy a desplegar en un entorno de desarrollo o de producción me es de gran utilidad, porque de esta forma
puedo especificar distintos parámetros para áreas como manejo de logs, *proxies*, notificaciones, etc.

Como **scrapyd-client** no implementa esta casuística y dado que tengo acceso al código en el repositorio
correspondiente [[5]](#ref-scrapyd-gh) nada me impide realizar las modificaciones pertinentes, esa es la grandeza del
código abierto.

Total, me puse manos a la obra, realicé el *fork* correspondiente, modifiqué el código necesario [[6]](#ref-fork-gh) y me quedé feliz.
Ya sólo me faltaba un detalle, que estos cambios se reflejen en el repo original y así cerrar el círculo. Como siempre
ocurre (creo que debería ser aceptado como refrán), si se te ocurre algo útil, sea lo que sea, lo habitual es que no seas el
primero en haberlo pensado. Este caso no es diferente, de hecho, el apartado de *pull requests* de **scrapyd-client** está repleto de propuestas con cambios similares al mío, algunos incluso con años de antigüedad. ¿Que por qué siguen ahí? Pues porque hace años que ninguno de estos *pull request* (ni las *issues*, todo sea dicho) es atendido.
    Este tipo de situaciones siempre me producen una sensación de lástima, de abandono. Peronsalmente no me parece muy
distinto de la sensación que podemos tener al ver cosas como inmuebles antiguos también desatendidos (molinos, cabañas
de cazadores y pastores, cosas del estilo). Como todo, al final es cuestión de matices, un repo abandonado puede ser
una oportunidad para que un nuevo *dueño* tome las riendas, un nuevo proyecto lo sustituya o se pase página de alguna
otra manera, siempre se puede ver la luz al final del túnel.


### Conclusión

Para cerrar, dejo una serie de dudas recurrentes: ¿Qué podemos hacer en estos casos? ¿Es un fork suficiente garantía de continuidad para un proyecto? ¿Sería interesante pedir ayuda a la comunidad y buscar nuevos
*maintainers*? ¿Qué sentido tiene que varias personas realicen/mos los mismos cambios una y otra vez sobre la misma
*codebase* para conseguir los mismos objetivos? ¿Podría hacer yo, como miembro de la comunidad, algo más en favor de un
proyecto como este?

Debo reconocer también que mi intención original para esta entrada era otra, darle otro enfoque, uno más técnico, más centrado en la propia librería, código y los cambios llevados a cabo, pero por alguna razón me vi en la necesidad de soltar el discurso. Además, los cambios tampoco tienen un grandísimo interés desde el punto de vista computacional.



### Referencias
[1] GNU Manifesto [gnu.org](https://www.gnu.org/gnu/manifesto.html)
{: #ref-manifest}
[2] Principio Peter Parker [wikipedia.org](https://es.wikipedia.org/wiki/Un_gran_poder_conlleva_una_gran_responsabilidad)
{: #ref-pparker}
[3] Heartbleed [heartbleed.com](https://heartbleed.com/)
{: #ref-heartbleed}
[4] Salvados por la Computación [twitch.tv](https://twitch.tv/cocasodev)
{: #ref-SC}
[5] Scrapyd-client Repo [github.com](https://github.com/scrapy/scrapyd-client)
{: #ref-scrapyd-gh}
[6] Scrapyd-client fork [github.com](https://github.com/Fynardo/scrapyd-client)
{: #ref-fork-gh}
