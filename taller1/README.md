# Taller de análisis de imágenes por software

## Propósito

Introducir el análisis de imágenes/video en el lenguaje de [Processing](https://processing.org/).

## Tareas

Implementar las siguientes operaciones de análisis para imágenes/video:

* Conversión a escala de grises.
* Aplicación de algunas [máscaras de convolución](https://en.wikipedia.org/wiki/Kernel_(image_processing)).
* (solo para imágenes) Despliegue del histograma.
* (solo para imágenes) Segmentación de la imagen a partir del histograma.
* (solo para video) Medición de la [eficiencia computacional](https://processing.org/reference/frameRate.html) para las operaciones realizadas.

Emplear dos [canvas](https://processing.org/reference/PGraphics.html), uno para desplegar la imagen/video original y el otro para el resultado del análisis.

## Integrantes

Complete la tabla:

| Integrante                       | github nick   |
|----------------------------------|---------------|
| Luis Fernando Castro Peralta     | Moimolcp      |
| Wilson Andres Piravaguen Serrano | wapiravaguens |

## Discusión

####Actividades realizadas:

Se crearon dos canvas utilizando la clase PGraphics, en uno se muestra la imagen o video original y en el otro la imagen o video transformada, también se implementó una clase button para la creación de botones que permiten alternar entre las distintas operaciones que realiza el programa.

* **Escala de grises:** Para la conversión de la imagen a escala de grises se calculó el promedio de rgb para cada pixel en la imagen o video.

* **Máscaras de convolución:** Se aplicaron cuatro diferentes máscaras de convolución, Edge Detection, Sharpen, Box Blur y Gaussian Blur.

* **Histograma:** Se implementó el histograma utilizando un arreglo de tamaño 256 donde se guarda la frecuencia de cada valor de gris de la imagen en escala de grises, este histograma es dibujado debajo de la imagen haciendo uso de la función line() para representar cada valor.

* **Segmentación:** La segmentación se implementó utilizando las funciones mousePressed() y mouseReleased(), así con tan solo un clic y arrastre se demarca la franja del histograma en la que se desea hacer la segmentación, esta segmentación es mostrada tanto en la imagen o video original como en la imagen o video transformada.

* **Medición de eficiencia computacional:** Este se calcula utilizando la variable de Processing frameRate, a partir de este valor se calcula el porcentaje al que está corriendo el programa en cada momento a partir de un frameRate base de 60 frames.

####Resultados:

Aunque las máscaras de convolución obtienen buenos resultados, al aplicarlas en tiempo real sobre un clip de vídeo el rendimiento se ve notablemente afectado al ser una operación demasiado costosa

## Entrega

* Hacer [fork](https://help.github.com/articles/fork-a-repo/) de la plantilla. Plazo: 28/4/19 a las 24h.
* (todos los integrantes) Presentar el trabajo presencialmente en la siguiente sesión de taller.
