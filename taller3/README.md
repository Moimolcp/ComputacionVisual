# Taller raster

## Propósito

Comprender algunos aspectos fundamentales del paradigma de rasterización.

## Tareas

Emplee coordenadas baricéntricas para:

1. Rasterizar un triángulo.
2. Sombrear su superficie a partir de los colores de sus vértices.
3. (opcional para grupos menores de dos) Implementar un [algoritmo de anti-aliasing](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-practical-implementation) para sus aristas.

Referencias:

* [The barycentric conspiracy](https://fgiesen.wordpress.com/2013/02/06/the-barycentric-conspirac/)
* [Rasterization stage](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-stage)

Implemente la función ```triangleRaster()``` del sketch adjunto para tal efecto, requiere la librería [nub](https://github.com/nakednous/nub/releases).

## Integrantes

Complete la tabla:

| Integrante                       | github nick   |
|----------------------------------|---------------|
| Luis Fernando Castro Peralta     | Moimolcp      |
| Wilson Andres Piravaguen Serrano | wapiravaguens |

## Discusión

Para la rasterización del triángulo lo más importante fue el uso de las coordenadas baricéntricas, a través del uso de la “edgeFunction” podemos determinar de qué lado de una línea(definida por dos vértices) se encuentra un punto en particular, aplicando esto a los tres lados del triángulo se puede determinar si un punto se encuentra dentro o fuera del triángulo(función “inside”), además de esto también nos permite calcular un peso o incidencia respecto a cada vértice para este punto, esto nos permite realizar el sombreado del triángulo asignándole un color a cada vértice.

![Resultados](raster1.png)


### Técnica de antialiasing: multi sampling

Para darle color a cierto píxel este se subdivide en 4 subpixeles y se verifica cuántos de estos están dentro del triángulo, con la proporción de subpixeles dentro se calcula el alpha con el que será rellenado el píxel original, el color se obtiene a través de las coordenadas baricéntricas de dicho pixel.

![Resultados](raster2.png)

## Entrega

* Plazo: ~~2/6/19~~ 4/6/19 a las 24h.
