DataCollection

Para la recolección de datos se realizó una aplicación web en R utilizando el paquete Shainy el cual nos brinda un conjunto de funciones para realizar la aplicación.

Como utilizar la aplicación:

Para pasar a llenar los datos del diario es necesario definir la hora de inicio del día (horas y minutos), así como el tiempo que se demoró en realizar la actividad(este tiempo se encuentra expresado en minutos), para esto se debe mover la barra que se encuentra a la izquierda llamada "time to action", en caso de no seleccionar esta última los datos no se guardaran, la hora de inicio del día se selecciona como se muestra en la figura en el costado izquierdo de esta, donde podemos observar que por default la hora de inicio del día es las 4 am,

![](./images/Captura de Pantalla 2022-02-11 a la(s) 4.59.16 p.m..png)



una vez seleccionada la hora inicial, se puede seleccionar la actividad que se realizó, presionando sobre esta como se muestra en la siguiente figura

![](./images/Captura de Pantalla 2022-02-11 a la(s) 4.59.23 p.m..png)

, una vez hecho esto se puede pasar a apretar el botón de agregar la actividad, esta pasará a agregarse a una lista de actividades que se han realizado hasta el momento en el día, en la cual se guarda la actividad con su hora de inicio y de fin, como se observa en la siguiente foto,

![](./images/Captura de Pantalla 2022-02-11 a la(s) 4.59.33 p.m..png)

una vez agregadas todas las actividades realizadas en el día, se presiona el botón de guardar el reporte del día y estos datos pasarán a ser guardados en un archivo DataOutput.csv él el cual contendrá todos los datos recogidos por la aplicación hasta el momento, estos datos pueden ser visualizados en la sección de la aplicación llamada Tabla de Datos como se muestra en la imagen,

![](./images/Captura de Pantalla 2022-02-11 a la(s) 4.59.58 p.m..png)

estos datos pueden ser ordenados y filtrados para una mejor visualización, (como expansión en un futuro se pudiera agregar que estos datos sean enviados a un servidor para estos ser procesados)

Detalles para el cliente:

Para que la aplicación sea lo más extensible posible se encuentra un archivo Activities.csv donde se pueden modificar las categorías y las actividades que pertenecen a estas categorías, para que en un futuro se puedan agregar nuevas actividades diarias a la aplicación sin tener que modificar el código de esta. El archivo Activities.csv tiene un formato de tabla donde el primer elemento de cada columna representa la categoría y los demás elementos de esta serian las actividades disponibles para esa categoría, como se muestra en la siguiente imagen.

![](./images/Captura de Pantalla 2022-02-11 a la(s) 5.00.46 p.m..png)

También se realizó un paginado para mostrar estas categorías para en caso de existir muchas de estas y no ser capaz de poder mostrarlas todas en la pantalla, poder y mostrándolas toadas de poco en poco. Cuando una actividad es guarda en la lista de actividades diarias hasta el momento esta es guardada en el almacenamiento local hasta que se envíe todo el reporte diario, la cual pasa a formar parte del archivo donde se encuentran todos los datos que se han generado hasta ahora DataOutput.csv, este archivo tiene la forma siguiente.

![](./images/Captura de Pantalla 2022-02-11 a la(s) 5.01.06 p.m..png)

La primera columna contiene un identificador "ID" el cual representa de forma única a cada día en la medición donde iguales ID significa que la actividad pertenece al mismo día, la segunda columna contiene las actividades "Activitie" donde se guardan todas las actividades realizadas, la tercera y la cuarta columna guardan la hora de inicio "StartTime" y la hora final "EndTime" respectivamente. En caso de que desee limpiar esta tabla, es decir que se borren los datos almacenados hasta ahora, esta debe mantener el formato descrito anteriormente, (manteniendo la primera fila de la siguiente manera "ID","Activitie","StartTime","EndTime").
