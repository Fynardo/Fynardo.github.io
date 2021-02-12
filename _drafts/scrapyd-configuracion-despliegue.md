---
layout: post
title: Scrapyd&#58; Configuraci&oacute;n y despliegue
category: data
readtime: 8
tags: datos, scrapers, scrapy, scrapyd, python, docker
---


En los proyectos de minería y *scraping* es importante, y complejo, mantener una buena organización de todos los componentes involucrados, ya que son proyectos que tienden a crecer y evolucionar de forma bastante caótica. En esta entrada desglosaré las claves de la configuración y el despliegue de los *scrapers*, utilizando herramientas como **Scrapyd** y **Docker**.

<!-- excerpt-end -->

### Contenido
{: .no_toc}

1. TOC
{:toc}


### Introducción

El *scraping* es un proceso que, en su sentido más general, se utiliza para homogeneizar y centralizar información relativa a un tema concreto pero que se encuentra dispersa por todo Internet (tanto en ubicación como en formato). Entre los múltiples ejemplos o casos de uso donde el *scraping* es aplicable encontramos algunos tan dispares como recolectar información sobre actividades deportivas o el seguimiento de precios a lo largo del tiempo (vivienda, activos financieros, criptomonedas, etc.). Sin ir más lejos, nuestro querido [COVIB](https://t.me/cocasovideogamesbot) se ayuda de *scrapers* para obtener y completar información en algunas categorías. Como siempre, recordad que todo gran poder conlleva una gran responsabilidad, y desde luego el *scraping* no es una excepción, tal es el caso de la PS5 y su falta de *stock* [[1]](#ref-ps5-scalping).

**Scrapy** [[2]](#ref-intro-scrapy) es una de las librerías de *scraping* web más conocidas, implementada en Python bajo licencia *open source* y mantenida principalmente por la empresa [scrapinghub](https://www.scrapinghub.com/). La ventaja principal de utilizar una herramienta como ésta es que nos permite centrarnos exclusivamente en la extracción de los datos, así, podemos delegar toda la gestión de errores, *logs*, *proxies*, balanceo y demás lógica en la propia librería.

Durante la redacción de esta entrada, scrapinghub anunció un [*rebrand*](https://www.zyte.com/blog/scrapinghub-is-now-zyte/), actualizando su nombre e imagen corporativa. Ahora es conocida como [**zyte**](https://www.zyte.com/).
{: .post-info-box}

Si eres un neófito en el mundo del *scraping* y, en concreto, en el funcionamiento de *scrapy*, existen múltiples recursos que quizá te interesen, no te llevará mucho tiempo revisarlos y te darán una buena base ([[3]](#ref-intro-tutorial), [[4]](#ref-intro-quotesbot), [[5]](#ref-intro-intro)).

Recuerda que es muy importante respetar lo máximo posible aquellas webs que vamos a *scrapear*, acatando siempre las restricciones impuestas, como por ejemplo timeouts, secciones restringidas y otras condiciones similiares. Normalmente éstas están definidas en el fichero **robots.txt**.
{: .post-alert-box}

En las siguientes secciones vamos a ver como crear un proyecto de *scrapy* listo para ser desplegado en *scrapyd*, así
como la configuración y *dockerización* de este último.

### Scrapy

Por descontado, el primer requisito para un despliegue es tener algo que desplegar. La forma más cómoda de crear un proyecto en el caso de *scrapy* (llamémosle *myproject*) es utilizar la opción **startproject**, que crea e inicializa todos los ficheros necesarios para que el proyecto sea totalmente funcional.

```Console
scrapy startproject myproject
```
{: .post-code-chunk}

La estructura resultante será similar a la siguiente:

<pre>
 myproject/
    scrapy.cfg
    myproject/
       __init__.py
       items.py
       middlewares.py
       pipelines.py
       settings.py
       spiders/
          __init__.py
</pre>

Dentro del directorio raíz *myproject* encontramos el fichero *scrapy.cfg*, utilizado para la configuración de despliegue (lo trataremos en la sección de [empaquetado](#empaquetado)), y el subdirectorio *myproject*, que contiene todo el código de las *spiders*, así como las *pipelines*, *middlewares* y demás componentes compartidos del proyecto. Es una estructura muy común en Python, donde es habitual que el proyecto y el directorio que contiene el código tengan el mismo nombre [[6]](#ref-proj-struct).


### Scrapyd

**Scrapyd** es un servicio que permite alojar y ejecutar nuestras *spiders*, expone un API JSON [[7]](#ref-scrapyd-api) mediante el cual podremos controlarlo. La instalación sigue el mismo proceso que cualquier otra librería de Python,

```Console
pip install scrapy
```
{: .post-code-chunk}

y su ejecución es directa con un simple

```Console
scrapyd
```
{: .post-code-chunk}

Existe otra posibilidad para desplegar *spiders*, **scrapy cloud** [[8]](#ref-scrapy-cloud), un servicio de pago ofrecido por ScrapingHub (ahora zyte), la empresa que mantiene scrapy. Un detalle interesante de este servicio es que la configuración utilizada en scrapyd es totalmente compatible con scrapy-cloud.
{: .post-info-box}

Por defecto, *scrapyd* se lanza en el puerto 6800, donde además de encontrar el API podemos acceder a una interfaz web que nos permite monitorizar el estado de los proyectos y consultar *logs* de ejecuciones pasadas. La Figura 1 muestra una captura de ejemplo de esta interfaz.

<figure>
  <img src="{{ site.url }}/assets/2021-02-12/scrapyd.png" class="post-content-image"/>
  <figcaption>Figura 1: Ejemplo de la interfaz web de scrapyd.</figcaption>
</figure>
{: .post-content-image-caption #fig-1}

#### API
En la Figura 1 también puede verse como la propia web avisa de que su funcionalidad no es completa, limitándose a proveer un servicio de monitorización básica, es decir, admite un subconjunto de las peticiones GET del API. El resto de peticiones habrá que realizarlas a mano, en la documentación hay ejemplos para todos los *endpoint* detallados utilizando [**curl**](https://curl.se/), dejo a continuación algunos casos de uso habituales:

* **addversion**: Añade un nuevo proyecto (o una nueva versión de un proyecto ya existente):

```Console
curl http://localhost:6800/addversion.json -F project=myproject -F version=r23 -F egg=@myproject.egg
```
{: .post-code-chunk}

* **schedule**: Ejecuta un nuevo trabajo de *scraping*

```Console
curl http://localhost:6800/schedule.json -d project=myproject -d spider=myspider
```
{: .post-code-chunk}

* **listjobs**: Devuelve la lista de trabajos, organizados en función de su estado (pendientes, ejecutando y finalizados)

```Console
curl http://localhost:6800/listjobs.json?project=myproject
```
{: .post-code-chunk}

* **listprojects**: Devuelve la lista de proyectos registrados en el servicio

```Console
curl http://localhost:6800/listprojects.json
```
{: .post-code-chunk}


Sin ninguna sorpresa, con las peticiones GET solicitamos información y con las peticiones POST la añadimos (quizá en el caso de *schedule* esta afirmación sea un poco más difusa, si bien es cierto que este es un motivo de discusión habitual sobre
REST, donde los métodos HTTP no siempre son capaces de adaptarse a la perfección a la naturaleza de la operación que se
realiza [[9]](#ref-rest-1), [[10]](#ref-rest-2)). Fíjate también en que todas las peticiones tienen como destino
*localhost*, si planteas desplegar *scrapyd* en otra máquina (un VPS, NAS o similar) recuerda apuntar a la dirección
correcta. Veremos como configurar *scrapyd* en [configuración](#configuración).

#### Scrapyd-client

Para facilitar un poco las tareas, tanto las peticiones al API como el empaquetado y despliegue de los proyectos, o si no os lleváis bien con *curl*, es posible utilizar **scrapyd-client**
[[11]](#ref-scrapyd-client). Se trata de una sencilla librería mantenida por la comunidad de *scrapy* (aunque, si se me permite la observación, un poco abandonada) que implementa las llamadas al API y permite ejecutarlas mediante una interfaz en línea de comandos.

#### Empaquetado

Independientemente de la forma de trabajar preferida de cada uno, *addversion* involucra el uso de un fichero **.egg** [[12]](#ref-python-egg), un formato de distribución para paquetes de Python, similar a lo que sería *jar* en *Java*. No son difíciles de generar si el proyecto está bien formado (cosa que tenemos garantizada al haber utilizado *startproject* antes) y disponemos de un fichero [*setup.py*](https://docs.python.org/3/distutils/setupscript.html). Sin embargo, si ya pensábamos utilizar *scrapyd-client* no hay mayor problema, ya que éste incluye la utilidad **scrapyd-deploy**, que además de generar el fichero *.egg*, realizará la petición correspondiente al API (*addversion*) para subir la nueva versión del proyecto de forma automática.

Bien, para que *scrapyd-deploy* funcione, debe ser ejecutado desde el directorio raíz del proyecto (al mismo nivel que el fichero *scrapy.conf* que
vimos en la [introducción](#scrapy)). Esto se debe a que, entre otras cosas, de ese fichero leerá la URL donde está
alojado *scrapyd* (localhost:6800 por defecto) y el nombre del proyecto que vamos a desplegar. Si *scrapyd* está en
otro lugar, es decir, una máquina o puerto distinto, es necesario realizar los cambios pertinentes en el fichero de
configuración del proyecto.

#### Configuración

Por último, la configuración de *scrapyd* se gestiona mediante el fichero *scrapyd.conf* [[13]](#ref-scrapyd-conf), el
cual es necesario crear si queremos sobreescribir alguna de las propiedades por defecto. Es posible configurar multitud
de parámetros pero quizá los más habituales son los siguientes:

* **http\_port**: Puerto TCP donde el servicio escucha (6800 por defecto)
* **bind\_address**: Interfaz en la que el servicio escucha (localhost por defecto)
* **max\_proc**: Número máximo de procesos simultáneos de *scrapy* (0 por defecto, lo que significa que utiliza 1
  proceso por CPU)
* **egs\_dir**: Ruta del directorio donde se almacenarán los ficheros .egg de cada proyecto
* **logs\_dir**: Ruta del directorio donde se almacenarán los logs de las ejecuciones

Los valores por defecto de todos los campos pueden consultarse en la
[documentación](https://scrapyd.readthedocs.io/en/stable/config.html#example-configuration-file), donde podemos ver
que, además de estos y otros parámetros, es posible especificar servicios personalizados para cada uno de los
*endpoints* del API.


### Scrapyd y Docker

Como todo servicio que se precie, siempre es interesante *dockerizarlo* para ganar un poco de fluidez. En el caso de
*scrapyd* es fácil de conseguir, realmente no tiene dependencias. Lo único que debemos hacer es instalar Python,
instalar el propio *scrapyd* y copiar el fichero de configuración al contenedor. Por ejemplo, podríamos escribir un
Dockerfile como el siguiente:


```Docker
FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y python3-dev python3-pip
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip3 install scrapyd

COPY ./scrapyd.conf /etc/scrapyd/

EXPOSE 6800
CMD ["scrapyd"]
```
{: .post-code-chunk}

Puedes dejar los valores por defecto de *scrapyd.conf* sin problema, pero recuerda configurar el *bind\_address* a la
dirección 0.0.0.0 para que *docker* pueda conectarse con *scrapyd*.
{: .post-info-box}

Con esto, el proceso para arrancar el contenedor es el habitual:

```Console
docker build --pull --rm -t fynardo:scrapyd .
docker run -p 6800:6800 fynardo:scrapyd
```
{: .post-code-chunk}


### Conclusión

En esta entrada hemos visto cómo utilizar y configurar *scrapyd*, un servicio que nos permite centralizar la gestión y ejecución de
todos nuestros proyectos de *scraping*. Además hemos visto cómo desplegarlo utilizando *docker*.

### Referencias
[1] An analysis of the $143 million PS5 Scalping Market, [dev.to](https://dev.to/driscoll42/an-analysis-of-the-143-million-ps5-scalping-market-414d)
{: #ref-ps5-scalping}
[2] web oficial scrapy , [scrapy.org](https://scrapy.org)
{: #ref-intro-scrapy}
[3] tutorial scrapy, [docs.scrapy.org](https://docs.scrapy.org/en/latest/intro/tutorial.html)
{: #ref-intro-tutorial}
[4] scrapy quotesbot, [github.com](https://github.com/scrapy/quotesbot)
{: #ref-intro-quotesbot}
[5] Introduction to scrapy, [pythongasm.com](https://www.pythongasm.com/introduction-to-scrapy/)
{: #ref-intro-intro}
[6] Structuring Your Project, [python-guide.org](https://docs.python-guide.org/writing/structure/)
{: #ref-proj-struct}
[7] Scrapyd API Docs, [readthedocs.io](https://scrapyd.readthedocs.io/en/stable/api.html)
{: #ref-scrapyd-api}
[8] Scrapy Cloud, [zyte.com](https://www.zyte.com/scrapy-cloud/)
{: #ref-scrapy-cloud}
[9] What are the drawbacks of REST?, [wisdomofganesh.com](http://wisdomofganesh.blogspot.com/2013/05/what-are-drawbacks-of-rest.html)
{: #ref-rest-1}
[10] REST API and POST method, [stackoverflow.com](https://stackoverflow.com/questions/19843480/s3-rest-api-and-post-method/19844272#19844272)
{: #ref-rest-2}
[11] Scrapyd-Client [github.com](https://github.com/scrapy/scrapyd-client)
{: #ref-scrapyd-client}
[12] Python egg, [wiki.python.org](https://wiki.python.org/moin/egg)
{: #ref-python-egg}
[13] Scrapyd Configuration file, [readthedocs.io](https://scrapyd.readthedocs.io/en/stable/config.html)
{: #ref-scrapyd-conf}
