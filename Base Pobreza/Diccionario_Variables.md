# Diccionario de variables · Pobreza municipal 2020

Base: `Pobreza_Municipal_2020_Limpia.xlsx`, hoja **`datos`**. Tiene **2,469 filas** (una por municipio) y
**51 columnas**. Todas las cifras corresponden al **año 2020**, por lo que los nombres no llevan año.

Fuente: CONEVAL, *Medición de la pobreza, Estados Unidos Mexicanos, 2010-2020. Indicadores de pobreza
por municipio* (archivo original en `original/Concentrado_indicadores_de_pobreza_2020.xlsx`).

## Cómo se forman los nombres

Cada indicador usa la forma `<indicador>_<medida>`.

| Sufijo | Medida | Unidad |
|---|---|---|
| `_pct` | Porcentaje de la población del municipio en esa condición | 0 a 100 (no 0 a 1) |
| `_pers` | Número estimado de personas en esa condición | Personas |
| `_carpro` | Número promedio de carencias sociales de las personas en esa condición | 0 a 6 carencias |

| Prefijo | Indicador | Grupo |
|---|---|---|
| `pobreza` | Población en situación de pobreza | Pobreza |
| `pobreza_ext` | Población en situación de pobreza extrema | Pobreza |
| `pobreza_mod` | Población en situación de pobreza moderada | Pobreza |
| `vul_car` | Población vulnerable por carencias sociales | Vulnerabilidad y no pobreza |
| `vul_ing` | Población vulnerable por ingresos (sin `_carpro`) | Vulnerabilidad y no pobreza |
| `no_pobre_no_vul` | Población no pobre y no vulnerable (sin `_carpro`) | Vulnerabilidad y no pobreza |
| `rezago_edu` | Rezago educativo | Carencias sociales |
| `car_salud` | Carencia por acceso a los servicios de salud | Carencias sociales |
| `car_segsoc` | Carencia por acceso a la seguridad social | Carencias sociales |
| `car_vivienda` | Carencia por calidad y espacios de la vivienda | Carencias sociales |
| `car_servbas` | Carencia por acceso a los servicios básicos en la vivienda | Carencias sociales |
| `car_alim` | Carencia por acceso a la alimentación | Carencias sociales |
| `car_1omas` | Población con al menos una carencia social | Privación social |
| `car_3omas` | Población con tres o más carencias sociales | Privación social |
| `ing_inf_lp` | Población con ingreso inferior a la línea de pobreza por ingresos | Bienestar económico |
| `ing_inf_lpe` | Población con ingreso inferior a la línea de pobreza extrema por ingresos | Bienestar económico |

**Valores faltantes.** Las celdas vacías (NA) provienen de dos códigos del original:
- **n.d.** (no disponible): el municipio no tiene estimación en 2020.
- **n.a.** (no aplica): el grupo tiene 0 personas, así que no existe su promedio de carencias.

El detalle está en el reporte (`Reporte_Base_Pobreza_2020.md`).

La columna **Col. original** indica la columna de la hoja *Concentrado municipal* del archivo del
CONEVAL de donde proviene cada variable. La columna **Mín – Máx** muestra los valores observados en
los 2,466 municipios con estimación.

## Variables

| # | Variable | Descripción | Unidad | Válidos | Faltantes (n.d. / n.a.) | Mín – Máx | Col. original |
|---|---|---|---|---|---|---|---|
| 1 | `cve_ent` | Clave de la entidad federativa (INEGI, 2 dígitos, texto) | Texto | 2,469 | 0 / 0 |  | B |
| 2 | `entidad` | Nombre de la entidad federativa | Texto | 2,469 | 0 / 0 |  | C |
| 3 | `cve_mun` | Clave del municipio (INEGI, 5 dígitos = entidad + municipio, texto) | Texto | 2,469 | 0 / 0 |  | D |
| 4 | `municipio` | Nombre del municipio | Texto | 2,469 | 0 / 0 |  | E |
| 5 | `poblacion` | Población total del municipio en 2020 estimada por el CONEVAL para la medición de pobreza | Número de personas | 2,466 | 3 / 0 | 81 – 1,913,345 | H |
| 6 | `pobreza_pct` | Porcentaje de la población en situación de pobreza | Porcentaje (0-100) | 2,466 | 3 / 0 | 5.5 – 99.6 | K |
| 7 | `pobreza_pers` | Personas en situación de pobreza | Número de personas | 2,466 | 3 / 0 | 55 – 816,934 | N |
| 8 | `pobreza_carpro` | Número promedio de carencias sociales de la población en situación de pobreza | Número de carencias (0-6) | 2,466 | 3 / 0 | 1.21 – 3.93 | Q |
| 9 | `pobreza_ext_pct` | Porcentaje de la población en situación de pobreza extrema | Porcentaje (0-100) | 2,466 | 3 / 0 | 0.0 – 84.4 | T |
| 10 | `pobreza_ext_pers` | Personas en situación de pobreza extrema | Número de personas | 2,466 | 3 / 0 | 0 – 126,672 | W |
| 11 | `pobreza_ext_carpro` | Número promedio de carencias sociales de la población en situación de pobreza extrema | Número de carencias (0-6) | 2,465 | 3 / 1 | 3.03 – 4.26 | Z |
| 12 | `pobreza_mod_pct` | Porcentaje de la población en situación de pobreza moderada | Porcentaje (0-100) | 2,466 | 3 / 0 | 5.2 – 85.0 | AC |
| 13 | `pobreza_mod_pers` | Personas en situación de pobreza moderada | Número de personas | 2,466 | 3 / 0 | 47 – 700,991 | AF |
| 14 | `pobreza_mod_carpro` | Número promedio de carencias sociales de la población en situación de pobreza moderada | Número de carencias (0-6) | 2,466 | 3 / 0 | 1.20 – 3.59 | AI |
| 15 | `vul_car_pct` | Porcentaje de la población vulnerable por carencias sociales | Porcentaje (0-100) | 2,466 | 3 / 0 | 0.0 – 77.6 | AL |
| 16 | `vul_car_pers` | Personas vulnerable por carencias sociales | Número de personas | 2,466 | 3 / 0 | 0 – 728,225 | AO |
| 17 | `vul_car_carpro` | Número promedio de carencias sociales de la población vulnerable por carencias sociales | Número de carencias (0-6) | 2,464 | 3 / 2 | 1.17 – 3.39 | AR |
| 18 | `vul_ing_pct` | Porcentaje de la población vulnerable por ingresos | Porcentaje (0-100) | 2,466 | 3 / 0 | 0.0 – 23.6 | AU |
| 19 | `vul_ing_pers` | Personas vulnerable por ingresos | Número de personas | 2,466 | 3 / 0 | 0 – 215,576 | AX |
| 20 | `no_pobre_no_vul_pct` | Porcentaje de la población no pobre y no vulnerable | Porcentaje (0-100) | 2,466 | 3 / 0 | 0.0 – 57.4 | BA |
| 21 | `no_pobre_no_vul_pers` | Personas no pobre y no vulnerable | Número de personas | 2,466 | 3 / 0 | 0 – 615,131 | BD |
| 22 | `rezago_edu_pct` | Porcentaje de la población con rezago educativo | Porcentaje (0-100) | 2,466 | 3 / 0 | 2.9 – 61.4 | BG |
| 23 | `rezago_edu_pers` | Personas con rezago educativo | Número de personas | 2,466 | 3 / 0 | 16 – 319,095 | BJ |
| 24 | `rezago_edu_carpro` | Número promedio de carencias sociales de la población con rezago educativo | Número de carencias (0-6) | 2,466 | 3 / 0 | 1.36 – 4.40 | BM |
| 25 | `car_salud_pct` | Porcentaje de la población con carencia por acceso a los servicios de salud | Porcentaje (0-100) | 2,466 | 3 / 0 | 1.1 – 83.9 | BP |
| 26 | `car_salud_pers` | Personas con carencia por acceso a los servicios de salud | Número de personas | 2,466 | 3 / 0 | 12 – 637,666 | BS |
| 27 | `car_salud_carpro` | Número promedio de carencias sociales de la población con carencia por acceso a los servicios de salud | Número de carencias (0-6) | 2,466 | 3 / 0 | 1.93 – 4.77 | BV |
| 28 | `car_segsoc_pct` | Porcentaje de la población con carencia por acceso a la seguridad social | Porcentaje (0-100) | 2,466 | 3 / 0 | 22.0 – 97.0 | BY |
| 29 | `car_segsoc_pers` | Personas con carencia por acceso a la seguridad social | Número de personas | 2,466 | 3 / 0 | 52 – 955,642 | CB |
| 30 | `car_segsoc_carpro` | Número promedio de carencias sociales de la población con carencia por acceso a la seguridad social | Número de carencias (0-6) | 2,466 | 3 / 0 | 1.23 – 3.96 | CE |
| 31 | `car_vivienda_pct` | Porcentaje de la población con carencia por calidad y espacios de la vivienda | Porcentaje (0-100) | 2,466 | 3 / 0 | 0.8 – 76.7 | CH |
| 32 | `car_vivienda_pers` | Personas con carencia por calidad y espacios de la vivienda | Número de personas | 2,466 | 3 / 0 | 5 – 130,963 | CK |
| 33 | `car_vivienda_carpro` | Número promedio de carencias sociales de la población con carencia por calidad y espacios de la vivienda | Número de carencias (0-6) | 2,465 | 4 / 0 | 1.76 – 4.62 | CN |
| 34 | `car_servbas_pct` | Porcentaje de la población con carencia por acceso a los servicios básicos en la vivienda | Porcentaje (0-100) | 2,466 | 3 / 0 | 0.1 – 100.0 | CQ |
| 35 | `car_servbas_pers` | Personas con carencia por acceso a los servicios básicos en la vivienda | Número de personas | 2,466 | 3 / 0 | 1 – 220,919 | CT |
| 36 | `car_servbas_carpro` | Número promedio de carencias sociales de la población con carencia por acceso a los servicios básicos en la vivienda | Número de carencias (0-6) | 2,466 | 3 / 0 | 1.51 – 4.38 | CW |
| 37 | `car_alim_pct` | Porcentaje de la población con carencia por acceso a la alimentación | Porcentaje (0-100) | 2,466 | 3 / 0 | 0.0 – 75.7 | CZ |
| 38 | `car_alim_pers` | Personas con carencia por acceso a la alimentación | Número de personas | 2,466 | 3 / 0 | 0 – 515,767 | DC |
| 39 | `car_alim_carpro` | Número promedio de carencias sociales de la población con carencia por acceso a la alimentación | Número de carencias (0-6) | 2,464 | 3 / 2 | 1.73 – 4.58 | DF |
| 40 | `car_1omas_pct` | Porcentaje de la población con al menos una carencia social | Porcentaje (0-100) | 2,466 | 3 / 0 | 38.8 – 100.0 | DI |
| 41 | `car_1omas_pers` | Personas con al menos una carencia social | Número de personas | 2,466 | 3 / 0 | 75 – 1,220,637 | DL |
| 42 | `car_1omas_carpro` | Número promedio de carencias sociales de la población con al menos una carencia social | Número de carencias (0-6) | 2,466 | 3 / 0 | 1.19 – 3.92 | DO |
| 43 | `car_3omas_pct` | Porcentaje de la población con tres o más carencias sociales | Porcentaje (0-100) | 2,466 | 3 / 0 | 1.2 – 89.9 | DR |
| 44 | `car_3omas_pers` | Personas con tres o más carencias sociales | Número de personas | 2,466 | 3 / 0 | 6 – 303,656 | DU |
| 45 | `car_3omas_carpro` | Número promedio de carencias sociales de la población con tres o más carencias sociales | Número de carencias (0-6) | 2,466 | 3 / 0 | 3.04 – 4.23 | DX |
| 46 | `ing_inf_lp_pct` | Porcentaje de la población con ingreso inferior a la línea de pobreza por ingresos | Porcentaje (0-100) | 2,466 | 3 / 0 | 7.2 – 99.9 | EA |
| 47 | `ing_inf_lp_pers` | Personas con ingreso inferior a la línea de pobreza por ingresos | Número de personas | 2,466 | 3 / 0 | 56 – 1,020,408 | ED |
| 48 | `ing_inf_lp_carpro` | Número promedio de carencias sociales de la población con ingreso inferior a la línea de pobreza por ingresos | Número de carencias (0-6) | 2,466 | 3 / 0 | 0.72 – 3.93 | EG |
| 49 | `ing_inf_lpe_pct` | Porcentaje de la población con ingreso inferior a la línea de pobreza extrema por ingresos | Porcentaje (0-100) | 2,466 | 3 / 0 | 1.1 – 97.5 | EJ |
| 50 | `ing_inf_lpe_pers` | Personas con ingreso inferior a la línea de pobreza extrema por ingresos | Número de personas | 2,466 | 3 / 0 | 11 – 362,871 | EM |
| 51 | `ing_inf_lpe_carpro` | Número promedio de carencias sociales de la población con ingreso inferior a la línea de pobreza extrema por ingresos | Número de carencias (0-6) | 2,466 | 3 / 0 | 0.71 – 3.95 | EP |

## Glosario

Resumen de los conceptos de la metodología de medición multidimensional de la pobreza del CONEVAL.
Para citar las definiciones exactas en la tesis, usa el documento oficial: CONEVAL, *Metodología para
la medición multidimensional de la pobreza en México* (3.ª ed.), y los *Lineamientos y criterios
generales para la definición, identificación y medición de la pobreza* (DOF, 30/10/2018).

### Clasificación de la población (suma 100%)

| Concepto | Definición |
|---|---|
| **Pobreza** | Población con al menos una carencia social y con un ingreso inferior a la línea de pobreza por ingresos, es decir, insuficiente para adquirir los bienes y servicios alimentarios y no alimentarios que requiere. |
| **Pobreza extrema** | Población con tres o más carencias sociales (de seis) y con un ingreso inferior a la línea de pobreza extrema por ingresos: aun si dedicara todo su ingreso a alimentos, no podría adquirir los nutrientes necesarios para una vida sana. |
| **Pobreza moderada** | Población en pobreza que no está en pobreza extrema. Pobreza = pobreza extrema + pobreza moderada. |
| **Vulnerable por carencias sociales** | Población con al menos una carencia social, pero con un ingreso igual o superior a la línea de pobreza por ingresos. |
| **Vulnerable por ingresos** | Población sin carencias sociales, pero con un ingreso inferior a la línea de pobreza por ingresos. |
| **No pobre y no vulnerable** | Población sin carencias sociales y con un ingreso igual o superior a la línea de pobreza por ingresos. |

Pobreza + vulnerables por carencias + vulnerables por ingresos + no pobre y no vulnerable = 100%.

### Carencias sociales (seis indicadores)

| Carencia | La persona la presenta cuando… |
|---|---|
| **Rezago educativo** | No cuenta con el nivel de educación obligatoria que corresponde a su edad y año de nacimiento (primaria, secundaria o media superior, según su cohorte) y, si está en edad escolar, no asiste a un centro de educación formal. |
| **Acceso a los servicios de salud** | No está afiliada ni tiene derecho a recibir servicios médicos de alguna institución pública (IMSS, ISSSTE, Pemex, Defensa, Marina, Seguro Popular/INSABI, IMSS-Bienestar, etc.) o privada. |
| **Acceso a la seguridad social** | No tiene seguridad social por su trabajo, por contratación voluntaria, por parentesco con alguien que la tenga, ni por ser pensionada; si es adulta mayor, tampoco recibe un programa de pensiones para adultos mayores. |
| **Calidad y espacios de la vivienda** | Habita una vivienda con piso de tierra; techo de lámina de cartón o desechos; muros de embarro, bajareque, carrizo, bambú, palma, lámina de cartón, metálica o asbesto, o material de desecho; o con hacinamiento (más de 2.5 personas por cuarto). |
| **Servicios básicos en la vivienda** | Habita una vivienda sin agua entubada dentro de la vivienda o del terreno; sin drenaje o con desagüe a río, lago, mar, barranca o grieta; sin energía eléctrica; o donde se cocina con leña o carbón sin chimenea. |
| **Acceso a la alimentación** | Su hogar presenta inseguridad alimentaria moderada o severa según la Escala Mexicana de Seguridad Alimentaria. En la metodología de 2018 el indicador se llama *acceso a la alimentación nutritiva y de calidad*. |

### Privación social y bienestar económico

| Concepto | Definición |
|---|---|
| **Al menos una carencia social** | Población con una o más de las seis carencias sociales. |
| **Tres o más carencias sociales** | Población con tres o más de las seis carencias sociales. |
| **Línea de pobreza por ingresos (LPI)** | Valor monetario mensual por persona de la canasta alimentaria más la no alimentaria. Antes se llamaba *línea de bienestar*. |
| **Línea de pobreza extrema por ingresos (LPEI)** | Valor monetario mensual por persona de la canasta alimentaria. Antes se llamaba *línea de bienestar mínimo*. |

### Medidas y otros términos

| Término | Definición |
|---|---|
| **Porcentaje (`_pct`)** | Porcentaje de la población total del municipio en la condición indicada, en escala de 0 a 100. |
| **Personas (`_pers`)** | Número estimado de personas del municipio en la condición indicada. Es igual a `_pct × poblacion / 100` (redondeado). |
| **Carencias promedio (`_carpro`)** | Número promedio de carencias sociales (0 a 6) de las personas en la condición indicada. No existe para vulnerables por ingresos ni para no pobres y no vulnerables, porque por definición no tienen carencias. |
| **Población (`poblacion`)** | Población calibrada por el CONEVAL para que la suma de los municipios coincida con la población estatal del Modelo Estadístico 2020 para la continuidad del MCS-ENIGH. Tiene un propósito estadístico y puede diferir de las cifras de INEGI o CONAPO. |
| **n.d.** | *No disponible.* El municipio no tiene estimación: es de nueva creación o la muestra del Censo 2020 fue insuficiente. |
| **n.a.** | *No aplica.* El grupo no tiene población en el municipio, así que no se puede calcular su promedio de carencias. |
| **Claves INEGI** | `cve_ent` (2 dígitos) y `cve_mun` (5 dígitos: 2 de la entidad y 3 del municipio). Se guardan como texto para conservar los ceros a la izquierda; `cve_mun` equivale a la clave geoestadística municipal (CVEGEO) del INEGI. |
