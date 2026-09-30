# Reporte · Base de pobreza municipal 2020

**Archivo:** `Pobreza_Municipal_2020_Limpia.xlsx` · **Fuente:** CONEVAL, *Medición de la pobreza,
Estados Unidos Mexicanos, 2010-2020. Indicadores de pobreza por municipio*.

## 1. Resumen

- **Unidad de observación:** el municipio. Hay una fila por municipio: **2,469 municipios** de las
  **32 entidades**.
- **Variables:** **51**, que se dividen así:
  - 4 de identificación (claves y nombres);
  - la población de 2020;
  - los **16 indicadores de pobreza** de la medición multidimensional, con todas sus medidas: 14
    indicadores traen porcentaje, personas y carencias promedio, y 2 traen solo porcentaje y
    personas.
- **Año:** solo **2020**. El original también trae 2010 y 2015; esas columnas se excluyeron.
- **Faltantes:**
  - 3 municipios no tienen estimación en 2020.
  - Además hay 6 celdas vacías en variables de carencias promedio.
  - En total son 147 celdas vacías de 125,919 (0.12%).
  - Los 2,466 municipios restantes están completos en porcentajes y personas.
- **Veracruz** (`cve_ent == "30"`):
  - 212 municipios, sin ningún faltante.
  - 60.8% de su población está en pobreza y 16.0% en pobreza extrema.
  - La media municipal es de 69.7% en pobreza.
- **Fidelidad:** comparé celda por celda las 2,469 × 51 celdas de la base limpia con el original.
  Todas coinciden, salvo los códigos `n.d.`/`n.a.`, que se convirtieron en celdas vacías.

## 2. Contenido del archivo Excel

La hoja `datos` va primero, así que `read_excel()` la lee por defecto.

| Hoja | Contenido | Dimensión |
|---|---|---|
| `datos` | **La base para análisis.** Una fila por municipio y una columna por variable, sin títulos, celdas combinadas ni notas. Los faltantes son celdas vacías. | 2,469 × 51 |
| `diccionario` | Una fila por variable con: descripción, grupo, medida, unidad, tipo, n válidos, n faltantes (`n.d.` y `n.a.`), mínimo, media, máximo, y la columna y el encabezado originales de donde proviene. | 51 × 15 |
| `glosario` | Definiciones de los conceptos de la medición (pobreza, carencias, líneas de pobreza, medidas, códigos de faltantes). | 23 × 2 |
| `estatal_2020` | Los mismos indicadores 2020 para las 32 entidades, tomados de la hoja *Concentrado estatal* del original. Tiene las mismas columnas que `datos`, sin `cve_mun` ni `municipio`. Sirve de referencia para comparar un municipio con su estado. | 32 × 49 |
| `notas_coneval` | Título, fuente y notas al pie originales del CONEVAL, sin cambios. | 17 × 1 |

## 3. Proceso de limpieza

El script `script/limpiar_pobreza_2020.R` reproduce estos pasos a partir de
`original/Concentrado_indicadores_de_pobreza_2020.xlsx`:

1. **Lectura por rango fijo** de la hoja *Concentrado municipal*, celdas `B9:EP2477`:
   - se omiten las filas de título y el encabezado de dos niveles (filas 1-8);
   - se omiten las 14 filas de notas al pie (2480-2493);
   - se omite la columna A, que está vacía.
2. **Claves como texto** (`cve_ent`, `cve_mun`) para conservar los ceros a la izquierda (`"01"`, `"01001"`).
3. **Faltantes:** los textos `n.d.` y `n.a.` se convierten en valores faltantes (NA) y las 47 columnas
   de cifras quedan numéricas.
4. **Selección de 2020:** se toman las 4 columnas de identificación y las 47 columnas cuyo encabezado
   corresponde a 2020 (población y los 16 indicadores).
5. **Nombres cortos** con la forma `<indicador>_<medida>`, sin año (ver `Diccionario_Variables.md`).
6. **Verificación automática:**
   - el script compara cada nombre asignado con el encabezado original (indicador, medida y año);
   - comprueba que las claves sean únicas y coherentes;
   - comprueba que la población municipal sume la estatal en las 32 entidades.
7. **Escritura** del Excel con las cinco hojas descritas arriba.

No se imputó, recodificó, redondeó ni eliminó ningún valor. Los números conservan la precisión
completa del original.

## 4. Cobertura por entidad

| Clave | Entidad | Municipios | Sin estimación 2020 | Población 2020 | Pobreza estatal (%) | Pobreza extrema estatal (%) | Pobreza, media municipal (%) |
|---|---|---|---|---|---|---|---|
| 01 | Aguascalientes | 11 | 0 | 1,373,242 | 27.5 | 2.7 | 36.7 |
| 02 | Baja California | 6 | 0 | 3,742,465 | 23.1 | 1.7 | 25.6 |
| 03 | Baja California Sur | 5 | 0 | 885,465 | 27.4 | 3.5 | 29.1 |
| 04 | Campeche | 12 | 1 | 978,797 | 48.5 | 11.9 | 61.3 |
| 05 | Coahuila de Zaragoza | 38 | 0 | 3,139,003 | 23.6 | 2.3 | 26.2 |
| 06 | Colima | 10 | 0 | 786,016 | 27.8 | 2.7 | 33.5 |
| 07 | Chiapas | 124 | 1 | 5,586,615 | 74.4 | 28.3 | 80.5 |
| 08 | Chihuahua | 67 | 0 | 3,892,117 | 25.5 | 3.2 | 35.8 |
| 09 | Ciudad de México | 16 | 0 | 8,721,320 | 34.2 | 4.7 | 32.8 |
| 10 | Durango | 39 | 0 | 1,852,264 | 37.6 | 4.4 | 50.7 |
| 11 | Guanajuato | 46 | 0 | 6,045,151 | 44.5 | 5.5 | 48.2 |
| 12 | Guerrero | 81 | 0 | 3,661,640 | 65.6 | 26.9 | 73.2 |
| 13 | Hidalgo | 84 | 0 | 3,054,428 | 45.7 | 7.2 | 52.4 |
| 14 | Jalisco | 125 | 0 | 8,387,145 | 32.6 | 3.5 | 40.7 |
| 15 | México | 125 | 0 | 18,136,090 | 50.8 | 8.3 | 57.2 |
| 16 | Michoacán de Ocampo | 113 | 0 | 4,748,742 | 45.6 | 8.4 | 52.2 |
| 17 | Morelos | 36 | 0 | 2,036,707 | 52.6 | 9.6 | 61.0 |
| 18 | Nayarit | 20 | 0 | 1,340,427 | 30.5 | 4.1 | 39.4 |
| 19 | Nuevo León | 51 | 0 | 5,460,396 | 19.7 | 1.5 | 22.1 |
| 20 | Oaxaca | 570 | 0 | 4,134,039 | 63.8 | 24.3 | 77.3 |
| 21 | Puebla | 217 | 0 | 6,497,223 | 63.4 | 13.8 | 76.3 |
| 22 | Querétaro | 18 | 0 | 2,155,802 | 32.9 | 3.7 | 47.0 |
| 23 | Quintana Roo | 11 | 0 | 1,811,370 | 44.8 | 9.5 | 55.9 |
| 24 | San Luis Potosí | 58 | 0 | 2,874,932 | 44.6 | 9.5 | 63.0 |
| 25 | Sinaloa | 18 | 0 | 3,111,958 | 28.3 | 3.0 | 38.0 |
| 26 | Sonora | 72 | 0 | 3,136,574 | 31.2 | 4.4 | 34.2 |
| 27 | Tabasco | 17 | 0 | 2,504,927 | 53.0 | 14.0 | 57.4 |
| 28 | Tamaulipas | 43 | 0 | 3,746,179 | 35.8 | 3.8 | 50.4 |
| 29 | Tlaxcala | 60 | 1 | 1,367,993 | 58.3 | 8.8 | 62.5 |
| **30** | **Veracruz de Ignacio de la Llave** | **212** | 0 | 8,343,850 | 60.8 | 16.0 | 69.7 |
| 31 | Yucatán | 106 | 0 | 2,259,381 | 47.8 | 11.4 | 67.4 |
| 32 | Zacatecas | 58 | 0 | 1,636,983 | 43.8 | 3.8 | 50.7 |
| | **Total** | **2,469** | **3** | **127,409,241** | | | |

*Pobreza estatal* viene de la hoja `estatal_2020` y equivale a ponderar por población. *Media
municipal* es el promedio simple de los municipios. En todas las entidades excepto la
Ciudad de México, la media municipal es mayor que la estatal porque los municipios pequeños suelen
ser más pobres.

## 5. Valores faltantes

### 5.1 Municipios sin estimación en 2020 (`n.d.` en las 47 variables numéricas)

| Clave | Municipio | Entidad | Motivo según el CONEVAL |
|---|---|---|---|
| 04012 | Seybaplaya | Campeche | Municipio de nueva creación; muestra del Censo 2020 insuficiente |
| 07125 | Honduras de la Sierra | Chiapas | Municipio de nueva creación; muestra del Censo 2020 insuficiente |
| 29048 | La Magdalena Tlaltelulco | Tlaxcala | Muestra del Censo 2020 insuficiente |

Estas filas se conservan en la base con sus claves y nombres para no perder municipios del marco
geográfico. Para analizar, filtra `!is.na(pobreza_pct)`, que deja **2,466 municipios**.

### 5.2 Celdas vacías sueltas

| Clave | Municipio | Variable | Código original | Explicación |
|---|---|---|---|---|
| 20151 | San Francisco Teopan (Oax.) | `vul_car_carpro` | n.a. | 0 personas vulnerables por carencias; no hay promedio que calcular |
| 20521 | Santo Domingo Tonaltepec (Oax.) | `vul_car_carpro` | n.a. | Ídem |
| 20442 | Santa María Yalina (Oax.) | `car_alim_carpro` | n.a. | 0 personas con carencia por alimentación |
| 20488 | Santiago Tepetlapa (Oax.) | `car_alim_carpro` | n.a. | Ídem |
| 26034 | Huépac (Son.) | `pobreza_ext_carpro` | n.a. | 0 personas en pobreza extrema |
| 23011 | Puerto Morelos (Q. Roo) | `car_vivienda_carpro` | n.d. | **Inconsistencia del original:** el municipio sí tiene 4,437 personas con esta carencia (`car_vivienda_pers`), pero el CONEVAL no publicó su promedio. Se dejó vacío, como en la fuente. |

Resumen: 3 × 47 = 141 celdas por municipios sin estimación, más 6 celdas sueltas, dan 147 celdas
vacías. Ninguna está en porcentajes ni en personas de los 2,466 municipios con estimación.

## 6. Validaciones de consistencia

Todas las identidades de la metodología se cumplen, salvo diferencias de redondeo.

| Verificación | Resultado |
|---|---|
| Claves de municipio únicas, de 5 dígitos, que empiezan con la clave de su entidad | Cumple (2,469 de 2,469) |
| Suma de la población municipal = población estatal (hoja estatal) | Cumple en las 32 entidades; total nacional 127,409,241 |
| Suma de personas municipales = personas estatales, en los 16 indicadores | Diferencia máxima de 8 personas (0.004%) |
| Pobreza = pobreza extrema + pobreza moderada | Diferencia máxima de 0.04 puntos porcentuales |
| Pobreza + vul. carencias + vul. ingresos + no pobre ni vulnerable = 100% | Entre 99.72 y 100.00 |
| Al menos una carencia = pobreza + vulnerables por carencias | Diferencia máxima de 0.18 puntos |
| Ingreso < LPI = pobreza + vulnerables por ingresos | Diferencia máxima de 0.03 puntos |
| Ingreso < LPEI ≥ pobreza extrema | Cumple en todos los municipios |
| Personas = porcentaje × población / 100 | Diferencia máxima de 0.5 personas (redondeo) |
| Porcentajes dentro de [0, 100] | Cumple (0.0 a 100.0) |
| Carencias promedio dentro de [0, 6] | Cumple (0.71 a 4.77) |
| Carencias promedio ≥ 3 en pobreza extrema y en tres o más carencias | Cumple (mínimos 3.03 y 3.04) |

## 7. Panorama nacional 2020

La columna *Nacional ponderado* es el agregado de la base: suma de personas entre suma de población.
Las demás columnas describen la distribución de los 2,466 municipios con estimación, donde cada
municipio pesa lo mismo.

| Indicador | Variable | Nacional ponderado (%) | Personas | Media municipal | DE | Mín | Mediana | Máx |
|---|---|---|---|---|---|---|---|---|
| Pobreza | `pobreza_pct` | 44.5 | 56,647,995 | 62.0 | 21.9 | 5.5 | 62.7 | 99.6 |
| Pobreza extrema | `pobreza_ext_pct` | 9.0 | 11,529,369 | 17.2 | 15.3 | 0.0 | 12.5 | 84.4 |
| Pobreza moderada | `pobreza_mod_pct` | 35.4 | 45,118,650 | 44.8 | 12.3 | 5.2 | 46.0 | 85.0 |
| Vulnerable por carencias sociales | `vul_car_pct` | 26.3 | 33,572,248 | 25.1 | 13.9 | 0.0 | 24.3 | 77.6 |
| Vulnerable por ingresos | `vul_ing_pct` | 7.7 | 9,835,076 | 3.9 | 3.7 | 0.0 | 2.7 | 23.6 |
| No pobre y no vulnerable | `no_pobre_no_vul_pct` | 21.5 | 27,353,924 | 9.0 | 9.7 | 0.0 | 5.4 | 57.4 |
| Rezago educativo | `rezago_edu_pct` | 16.3 | 20,809,873 | 25.7 | 10.0 | 2.9 | 25.2 | 61.4 |
| Carencia: servicios de salud | `car_salud_pct` | 28.2 | 35,925,540 | 25.1 | 12.5 | 1.1 | 23.2 | 83.9 |
| Carencia: seguridad social | `car_segsoc_pct` | 56.7 | 72,256,994 | 72.4 | 14.8 | 22.0 | 76.5 | 97.0 |
| Carencia: calidad y espacios de la vivienda | `car_vivienda_pct` | 9.4 | 11,916,746 | 16.3 | 12.3 | 0.8 | 12.8 | 76.7 |
| Carencia: servicios básicos en la vivienda | `car_servbas_pct` | 18.0 | 22,961,395 | 40.1 | 29.9 | 0.1 | 35.1 | 100.0 |
| Carencia: alimentación | `car_alim_pct` | 20.8 | 26,497,563 | 23.0 | 11.6 | 0.0 | 21.3 | 75.7 |
| Al menos una carencia | `car_1omas_pct` | 70.8 | 90,220,238 | 87.1 | 12.6 | 38.8 | 91.6 | 100.0 |
| Tres o más carencias | `car_3omas_pct` | 21.5 | 27,376,108 | 34.4 | 19.7 | 1.2 | 31.7 | 89.9 |
| Ingreso < línea de pobreza | `ing_inf_lp_pct` | 52.2 | 66,483,059 | 65.9 | 20.1 | 7.2 | 66.9 | 99.9 |
| Ingreso < línea de pobreza extrema | `ing_inf_lpe_pct` | 20.3 | 25,887,058 | 33.0 | 20.5 | 1.1 | 28.6 | 97.5 |

Observaciones:

- **Los agregados vienen de la serie municipal.** La pobreza nacional que resulta de esta base
  (44.5%) no es idéntica a la cifra nacional oficial que el CONEVAL publicó para 2020 (43.9%). Para
  cifras nacionales o estatales oficiales, cita la medición nacional y estatal del CONEVAL.
- **Los municipios difieren mucho entre sí.** La pobreza va de 5.5% en San Pedro Garza García (N.L.)
  a 99.6% en San Simón Zahuatlán (Oax.). La carencia de servicios básicos va de 0.1% a 100%.
- **Hay muchos municipios pequeños.** 665 municipios tienen menos de 5,000 habitantes y 132 menos de
  1,000; el más pequeño tiene 81.

## 8. Veracruz de Ignacio de la Llave (`cve_ent == "30"`)

Veracruz tiene **212 municipios**, todos con estimación completa en 2020, y **8,343,850 habitantes**.
Es la tercera entidad con más municipios, después de Oaxaca y Puebla.

| Indicador | Variable | Estatal (%) | Personas (estatal) | Media municipal | DE | Mín | Mediana | Máx |
|---|---|---|---|---|---|---|---|---|
| Pobreza | `pobreza_pct` | 60.8 | 5,076,908 | 69.7 | 16.0 | 30.0 | 71.5 | 97.1 |
| Pobreza extrema | `pobreza_ext_pct` | 16.0 | 1,337,710 | 20.7 | 13.0 | 3.4 | 18.2 | 64.8 |
| Pobreza moderada | `pobreza_mod_pct` | 44.8 | 3,739,198 | 49.0 | 8.3 | 26.5 | 48.8 | 71.8 |
| Vulnerable por carencias sociales | `vul_car_pct` | 21.7 | 1,807,106 | 19.8 | 8.7 | 2.8 | 20.2 | 49.8 |
| Vulnerable por ingresos | `vul_ing_pct` | 5.6 | 464,864 | 3.8 | 3.6 | 0.0 | 2.6 | 15.1 |
| No pobre y no vulnerable | `no_pobre_no_vul_pct` | 11.9 | 994,971 | 6.7 | 6.9 | 0.0 | 4.2 | 32.1 |
| Rezago educativo | `rezago_edu_pct` | 25.6 | 2,136,751 | 31.1 | 8.2 | 9.0 | 31.7 | 53.5 |
| Carencia: servicios de salud | `car_salud_pct` | 31.0 | 2,582,919 | 27.8 | 10.7 | 3.2 | 28.3 | 52.0 |
| Carencia: seguridad social | `car_segsoc_pct` | 67.7 | 5,649,889 | 74.9 | 13.6 | 35.3 | 78.4 | 94.7 |
| Carencia: calidad y espacios de la vivienda | `car_vivienda_pct` | 15.0 | 1,247,804 | 17.2 | 10.6 | 2.4 | 14.5 | 68.1 |
| Carencia: servicios básicos en la vivienda | `car_servbas_pct` | 37.8 | 3,151,742 | 49.0 | 25.6 | 3.0 | 45.7 | 99.3 |
| Carencia: alimentación | `car_alim_pct` | 23.2 | 1,931,613 | 24.8 | 10.2 | 3.4 | 22.9 | 57.8 |
| Al menos una carencia | `car_1omas_pct` | 82.5 | 6,884,015 | 89.5 | 10.1 | 55.6 | 92.9 | 99.9 |
| Tres o más carencias | `car_3omas_pct` | 35.5 | 2,958,073 | 41.9 | 16.9 | 9.3 | 41.3 | 81.2 |
| Ingreso < línea de pobreza | `ing_inf_lp_pct` | 66.4 | 5,541,772 | 73.5 | 13.5 | 34.9 | 74.0 | 97.1 |
| Ingreso < línea de pobreza extrema | `ing_inf_lpe_pct` | 30.9 | 2,575,742 | 37.7 | 16.2 | 10.6 | 35.0 | 79.3 |

Los municipios veracruzanos son en promedio más pobres que el estado en su conjunto: su media
municipal es de 69.7% frente a 60.8% estatal. Casi todos los grupos de pobreza y carencia tienen una
media municipal mayor que la cifra estatal. Las excepciones son las categorías de no pobreza
(vulnerables por carencias o por ingresos y no pobre y no vulnerable) y la carencia de servicios de
salud (27.8% frente a 31.0% estatal).

**Distribución de municipios por porcentaje de pobreza:**

| Rango | < 25% | 25-50% | 50-75% | 75-90% | ≥ 90% |
|---|---|---|---|---|---|
| Veracruz (212) | 0 | 29 | 94 | 68 | 21 |
| Nacional (2,466) | 140 | 629 | 868 | 542 | 287 |

**Los 10 municipios con mayor porcentaje de pobreza:**

| Clave | Municipio | Población | Pobreza (%) | Pobreza extrema (%) |
|---|---|---|---|---|
| 30159 | Tehuipango | 30,722 | 97.1 | 64.8 |
| 30147 | Soledad Atzompa | 25,435 | 96.2 | 62.5 |
| 30025 | Ayahualulco | 34,625 | 95.9 | 24.2 |
| 30127 | La Perla | 29,244 | 95.3 | 55.6 |
| 30067 | Filomeno Mata | 21,232 | 94.9 | 49.0 |
| 30103 | Mecatlán | 13,246 | 94.7 | 50.1 |
| 30020 | Atlahuilco | 11,981 | 94.6 | 53.7 |
| 30057 | Chiconquiaco | 18,160 | 94.1 | 27.8 |
| 30110 | Mixtla de Altamirano | 12,548 | 94.0 | 52.4 |
| 30184 | Tlaquilpa | 8,210 | 93.9 | 47.6 |

**Los 10 municipios con menor porcentaje de pobreza:**

| Clave | Municipio | Población | Pobreza (%) | Pobreza extrema (%) |
|---|---|---|---|---|
| 30011 | Alvarado | 52,648 | 30.0 | 3.5 |
| 30118 | Orizaba | 110,536 | 32.2 | 3.4 |
| 30028 | Boca del Río | 132,289 | 35.1 | 4.0 |
| 30087 | Xalapa | 460,146 | 38.3 | 4.5 |
| 30191 | Ursulo Galván | 27,591 | 39.4 | 4.9 |
| 30065 | Emiliano Zapata | 85,403 | 39.5 | 6.5 |
| 30105 | Medellín | 94,064 | 39.8 | 7.1 |
| 30208 | Carlos A. Carrillo | 20,472 | 39.9 | 4.4 |
| 30193 | Veracruz | 560,020 | 41.0 | 5.3 |
| 30190 | Tuxtilla | 2,337 | 41.8 | 5.2 |

Los cuatro municipios más poblados (Veracruz, Xalapa, Coatzacoalcos y Córdoba) tienen entre 38% y 47%
de pobreza. En cambio, San Andrés Tuxtla, el quinto más poblado (188,949 habitantes), tiene 79.3%.

## 9. Correlaciones entre carencias

Correlación de Pearson entre los porcentajes municipales de las seis carencias y el de ingreso
inferior a la línea de pobreza.

**Nacional (2,466 municipios):**

| | Rezago edu. | Salud | Seg. social | Vivienda | Serv. básicos | Alimentación | Ingreso < LPI |
|---|---|---|---|---|---|---|---|
| **Rezago edu.** | 1.00 |  |  |  |  |  |  |
| **Salud** | -0.08 | 1.00 |  |  |  |  |  |
| **Seg. social** | 0.59 | 0.08 | 1.00 |  |  |  |  |
| **Vivienda** | 0.60 | -0.14 | 0.46 | 1.00 |  |  |  |
| **Serv. básicos** | 0.63 | -0.13 | 0.53 | 0.78 | 1.00 |  |  |
| **Alimentación** | 0.27 | 0.05 | 0.31 | 0.41 | 0.46 | 1.00 |  |
| **Ingreso < LPI** | 0.58 | -0.07 | 0.63 | 0.65 | 0.73 | 0.42 | 1.00 |

**Veracruz (212 municipios):**

| | Rezago edu. | Salud | Seg. social | Vivienda | Serv. básicos | Alimentación | Ingreso < LPI |
|---|---|---|---|---|---|---|---|
| **Rezago edu.** | 1.00 |  |  |  |  |  |  |
| **Salud** | -0.32 | 1.00 |  |  |  |  |  |
| **Seg. social** | 0.72 | -0.09 | 1.00 |  |  |  |  |
| **Vivienda** | 0.39 | -0.35 | 0.49 | 1.00 |  |  |  |
| **Serv. básicos** | 0.54 | -0.23 | 0.60 | 0.75 | 1.00 |  |  |
| **Alimentación** | 0.30 | -0.06 | 0.26 | 0.42 | 0.52 | 1.00 |  |
| **Ingreso < LPI** | 0.71 | -0.29 | 0.80 | 0.62 | 0.61 | 0.35 | 1.00 |

Lectura:

- **Vivienda y servicios básicos** son las carencias más asociadas entre sí (0.78 nacional, 0.75
  Veracruz).
- En Veracruz, **seguridad social** se asocia fuertemente con el ingreso (0.80) y con el rezago
  educativo (0.72).
- **Salud se comporta distinto al resto.** Su correlación con las demás carencias es casi nula a
  nivel nacional y negativa en Veracruz (hasta -0.35). Los municipios con más carencia de salud no
  son necesariamente los más pobres en las otras dimensiones.
- **Alimentación** tiene correlaciones moderadas con las demás carencias (sin contar salud) y con el ingreso: de 0.26 a 0.52.

## 10. Consideraciones para el análisis

1. **Los porcentajes están en escala 0-100.** Para modelos que esperan proporciones, divide entre 100.
2. **Ponderar o no ponderar.** El promedio simple de municipios no es el porcentaje de la población:
   para cifras poblacionales, pondera por `poblacion` o usa las columnas `_pers`.
3. **Variables compositivas y redundantes.** Estas identidades implican dependencia lineal casi
   perfecta; no incluyas en un mismo modelo todas las variables de cada identidad:
   - pobreza = extrema + moderada;
   - los cuatro grupos de la clasificación suman 100;
   - al menos una carencia = pobreza + vulnerables por carencias;
   - ingreso < LPI = pobreza + vulnerables por ingresos.
4. **Usa `_pct` para comparar municipios.** Las columnas `_pers` dependen sobre todo del tamaño del
   municipio y se correlacionan con la población.
5. **Son estimaciones de modelo.** Las cifras municipales combinan la muestra del Censo 2020 con el
   Modelo Estadístico 2020 del MCS-ENIGH y se ajustan a los totales estatales. En municipios muy
   pequeños tienen más incertidumbre, y la base no trae errores estándar.
6. **Nivel de análisis.** Si unes esta base con datos individuales (por ejemplo, una encuesta), cada
   persona recibe los indicadores de su municipio. Las conclusiones sobre municipios no deben
   trasladarse a individuos (falacia ecológica), y conviene considerar modelos multinivel o errores
   agrupados por municipio. La llave de unión es `cve_mun`, de 5 dígitos y en texto.
7. **La población no es la del INEGI.** `poblacion` está calibrada para la medición de pobreza y
   puede diferir del Censo 2020 o de CONAPO.

## 11. Cómo leer la base

En R:

```r
library(readxl)
ruta <- "Base Pobreza/Pobreza_Municipal_2020_Limpia.xlsx"   # relativo a la raíz del repositorio

pobreza <- read_excel(ruta, sheet = "datos")
diccionario <- read_excel(ruta, sheet = "diccionario")

pobreza_ver <- subset(pobreza, cve_ent == "30")              # Veracruz, 212 municipios
pobreza_ok  <- subset(pobreza, !is.na(pobreza_pct))           # 2,466 municipios con estimación
```

`read_excel` detecta solo los tipos: las claves y los nombres quedan como texto y las 47 columnas de
cifras como numéricas.

En Python: `pd.read_excel(ruta, sheet_name="datos", dtype={"cve_ent": str, "cve_mun": str})`.

## 12. Notas originales del CONEVAL

<details>
<summary>Texto íntegro de las notas al pie del archivo original (también en la hoja <code>notas_coneval</code>)</summary>

> Medición de la pobreza, Estados Unidos Mexicanos, 2010-2020
>
> Indicadores de pobreza por municipio
>
> Fuente: estimaciones del CONEVAL con base en el MCS-ENIGH 2010, la muestra del Censo de Población y Vivienda 2010, el Modelo Estadístico 2015 para la continuidad del MCS-ENIGH, la Encuesta Intercensal 2015, el Modelo Estadístico 2020 para la continuidad del MCS-ENIGH y la muestra del Censo de Población y Vivienda 2020.
>
> Notas: La población presentada en estos cuadros tiene un propósito exclusivamente estadístico: está calibrada para que, en las estimaciones de pobreza, la suma de la población municipal sea igual a la población de cada entidad federativa reportada con base en la información del MCS-ENIGH 2010, MEC del MCS-ENIGH 2015 o MEC del MCS-ENIGH 2020  publicados.
>
> Por lo anterior, estas cifras de población podrían diferir de las reportadas por el INEGI o CONAPO a nivel municipal.
>
> En 2015 para los municipios  de Buenaventura (08010), Carichí (08012), Santa Isabel (08024), Temósachic (08063), Urique (08065) en Chihuahua; San Nicolás de los Ranchos (21138) en Puebla; Matías Romero Avendaño (20057) , Santa María Chimalapa (20407) , San Francisco Chindúa (20140), Santa María Petapa (20427) en Oaxaca y Gral. Plutarco Elías Calles (26070) en Sonora
>
> no se puede generar estimaciones de los indicadores debido a que no se dispone de la información en la Encuesta Intercensal 2015, como lo especifica el INEGI  en http://internet.contenidos.inegi.org.mx/contenidos/productos/prod_serv/contenidos/espanol/bvinegi/productos/nueva_estruc/promo/eic_2015_presentacion.pdf
>
> En 2020 para los municipios de Seybaplaya (04012) en Campeche, Honduras de la Sierra (07125) en Chiapas y La Magdalena Tlaltelulco (29048) en Tlaxcala
>
> no se puede generar estimaciones de los indicadores debido a que la muestra del Censo de Población y Vivienda 2020 es insuficiente, como lo especifica el INEGI  en https://www.inegi.org.mx/contenidos/programas/ccpv/2020/doc/Censo2020_Resultados_complementarios_EUM.pdf
>
> Los municipios de San Quintín (02006) en Baja California; Seybaplaya (04012) en Campeche; El Parral (07122), Emiliano Zapata (07123), Mezcalapa (07124), Capitán Luis Ángel Vidal (07120), Rincón Chamula San Pedro (07121) y Honduras de la Sierra (07125) en Chiapas; Coatetelco (17034), Xoxocotla (17035) y Hueyapan en Morelos; Bacalar (23010) y Puerto Morelos (23011) en Quintana Roo
>
> son de nueva creación, como lo especifica el INEGI en "https://www.inegi.org.mx/contenidos/programas/ccpv/2020/doc/Censo2020_CPV_nuevos_municipios_a.pdf", por lo cual pueden no tener estimaciones 2010, 2015 o 2020.
>
> n.d. hace referencia a los municipios que por ser de nueva creación o por no poseer información suficiente, no cuenta con estimación en algún año.
>
> n.a. hace referencia a los municipios que no cuentan con población en alguno de los distintos indicadores de pobreza, por tanto, no es posible calcular sus carencias promedio.
>
> Las estimaciones municipales de pobreza han sido ajustadas a la información reportada a nivel estatal en el MCS-ENGH 2010, en el MEC del MCS-ENIGH  2015 y en el MEC del MCS-ENIGH 2020 .
>
> Algunas cifras pueden variar por cuestiones de redondeo.
>
> La información relacionada con la medición de pobreza municipal 2010 se actualiza con fecha 18 de diciembre de 2017, toda vez que en la construcción de la carencia por acceso a los servicios de básicos de la vivienda se considera el combustible que se utiliza para cocinar.  Lo anterior ya se hizo del conocimiento de los usuarios de la información para fines presupuestales y de planeación que se llevarán a cabo a partir de 2018.

</details>
