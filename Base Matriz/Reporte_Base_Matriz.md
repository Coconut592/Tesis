# Reporte · Base matriz municipal 2020

**Archivos:** `Base_Matriz_Municipal_2020.xlsx` (sin geometría) y `Base_Matriz_Municipal_2020.gpkg`
(con polígonos) · **Script:** `script/construir_base_matriz.R`

## 1. Resumen

- **Universo.** Los **2,469 municipios** del Marco Geoestadístico 2020. No se eliminó ninguno.
- **Muestra final.** **2,457 municipios** (`muestra_final == 1`) tienen las tres fuentes
  estadísticas: CONEVAL, ILMM e ITER.
  - Salen 12 municipios: 11 por no tener ILMM y 3 por no tener CONEVAL; 2 de ellos no tienen
    ninguna de las dos.
  - Juntos suman 273,808 habitantes, el 0.22% de la población.
- **Variables.** **186**, agrupadas así:

  | Grupo | Número |
  |---|---|
  | Identificación | 5 |
  | Control del universo | 5 |
  | Territorio | 4 |
  | CONEVAL | 18 |
  | ILMM | 16 |
  | ITER, tal como se publica | 67 |
  | Porcentajes calculados del ITER | 53 |
  | Indicador de calidad del Censo | 1 |
  | Localidades | 17 |

- **Llave.** `CVEGEO`, en texto de 5 dígitos. Coincide en las cuatro fuentes y no hay claves
  duplicadas.
- **Fidelidad.** Comparé la base final celda por celda con los archivos originales:
  - 0 diferencias en las 165,423 celdas del ITER, en las 36,870 de la ILMM y en todas las de CONEVAL;
  - los porcentajes, la población urbana y la localidad principal se reproducen de forma
    independiente.

## 2. Fuentes

Las fuentes de INEGI se descargaron del sitio oficial. Comprobé que son **los mismos archivos que
tienes en tu computadora**:

- el ITER mide exactamente lo mismo que tu `ITER_NALCSV20.csv` (149,660,864 bytes);
- el zip del Marco mide lo mismo que tu `MG_2020_Integrado.zip` (257,527,530 bytes);
- `municipios.csv`, `00mun.dbf`, `00mun.prj` y `00mun.cpg` tienen el mismo checksum MD5 que las copias
  de tu Drive.

| Fuente | Archivo | Qué se usa |
|---|---|---|
| Marco Geoestadístico 2020 integrado (INEGI) | `MG_2020_Integrado/conjunto_de_datos/00mun.shp` y `catalogos/municipios.csv` | Claves, nombres, polígonos, superficie y centroides |
| ILMM 2020-1T (INEGI) | `ILMM/conjunto_de_datos/conjunto_de_datos_ilmm_2020_1t.csv` | PEA, ocupados e informales con sus 5 estimadores |
| CONEVAL 2020 | `Base Pobreza/Pobreza_Municipal_2020_Limpia.xlsx` | 17 indicadores y la población calibrada |
| Censo 2020, ITER (INEGI) | `ITER_NALCSV20.csv` | 67 variables del total municipal (`LOC = 0000`) y los registros de las 189,432 localidades |

## 3. Universo: qué municipios se quedan y cuáles salen

| Fuente | Municipios |
|---|---|
| Marco Geoestadístico 2020 | 2,469 |
| ITER 2020 (total municipal, `LOC = 0000`) | 2,469 |
| CONEVAL 2020 (con estimación) | 2,466 |
| ILMM 2020-1T | 2,458 |
| **Las tres fuentes (muestra final)** | **2,457** |

**Municipios que salen de la muestra final:**

| CVEGEO | Entidad | Municipio | CONEVAL | ILMM | ITER | Población 2020 | Motivo |
|---|---|---|---|---|---|---|---|
| 02006 | Baja California | San Quintín | Sí | **No** | Sí | 117,568 | Sin estimación ILMM 2020. |
| 04012 | Campeche | Seybaplaya | **No** | **No** | Sí | 15,297 | Sin estimación CONEVAL 2020. Sin estimación ILMM 2020. |
| 07120 | Chiapas | Capitán Luis Ángel Vidal | Sí | **No** | Sí | 4,315 | Sin estimación ILMM 2020. |
| 07121 | Chiapas | Rincón Chamula San Pedro | Sí | **No** | Sí | 8,718 | Sin estimación ILMM 2020. |
| 07122 | Chiapas | El Parral | Sí | **No** | Sí | 15,587 | Sin estimación ILMM 2020. |
| 07123 | Chiapas | Emiliano Zapata | Sí | **No** | Sí | 10,783 | Sin estimación ILMM 2020. |
| 07124 | Chiapas | Mezcalapa | Sí | **No** | Sí | 23,847 | Sin estimación ILMM 2020. |
| 07125 | Chiapas | Honduras de la Sierra | **No** | **No** | Sí | 11,650 | Sin estimación CONEVAL 2020. Sin estimación ILMM 2020. |
| 17034 | Morelos | Coatetelco | Sí | **No** | Sí | 11,347 | Sin estimación ILMM 2020. |
| 17035 | Morelos | Xoxocotla | Sí | **No** | Sí | 27,805 | Sin estimación ILMM 2020. |
| 17036 | Morelos | Hueyapan | Sí | **No** | Sí | 7,855 | Sin estimación ILMM 2020. |
| 29048 | Tlaxcala | La Magdalena Tlaltelulco | **No** | Sí | Sí | 19,036 | Sin estimación CONEVAL 2020. |
| | | **Total** | | | | **273,808** (0.22% de la población) | |

**Por qué faltan:**

- **ILMM (11 municipios).** Son los municipios de nueva creación que también señala la nota del
  CONEVAL. El ILMM no los incluye; todo indica que usa la división municipal anterior a su creación.
  Por eso conviene tomar con cautela el dato del ILMM para los municipios de los que se separaron: puede
  referirse al territorio anterior a la división. Por ejemplo, San Quintín se separó de Ensenada.
  No hay un catálogo de correspondencias que permita confirmarlo.
- **CONEVAL (3 municipios).** Seybaplaya, Honduras de la Sierra y La Magdalena Tlaltelulco. Según
  el CONEVAL, la muestra del Censo 2020 fue insuficiente para estimarlos. En La Magdalena
  Tlaltelulco, además, el 92% de las viviendas no tiene características captadas (sección 6).
- **Siguen en los archivos.** Los 12 municipios permanecen en el Excel y en el GeoPackage con sus
  datos del Marco y del ITER, para que el mapa y la matriz W no tengan huecos si decides usarlos.

## 4. Cómo se construyó cada bloque

### 4.1 Marco Geoestadístico: territorio

- **Claves y nombres.** El catálogo `municipios.csv` y el shapefile `00mun.shp` tienen las mismas
  2,469 claves y los mismos nombres. Todos los polígonos son válidos; 84 municipios tienen más de
  una parte (islas o territorios separados).
- **Proyección.** El `.prj` trae "MEXICO_ITRF_2008_LCC" sin código EPSG. Sus parámetros son
  idénticos a **EPSG:6372** (Lambert cónica conforme, ITRF2008), así que se le asignó ese código
  para que QGIS, R y Python lo reconozcan. Se comprobó que proyectan igual.
- **`area_km2`.**
  - La Lambert del Marco es conforme: conserva formas, pero no áreas. Medir ahí desvía la superficie
    entre −1.1% y +1.4% según el municipio.
  - Por eso el área se calcula en una **Albers equivalente** (de igual área) sobre el elipsoide
    GRS80, con los mismos paralelos estándar del Marco (17.5° y 29.5° N).
  - El total nacional es de **1,965,083 km²**.
- **`densidad_pob`.** Es `POBTOT / area_km2`.
- **Centroides.** `lon_centroide` y `lat_centroide` son el centroide geométrico en grados
  decimales. En los municipios con islas puede caer fuera del polígono.

### 4.2 ILMM: informalidad laboral

- **Estructura original.** El archivo trae 5 filas por municipio, una por tipo de estimador. Según
  el catálogo `est.csv`: 1 es el valor, 2 el error estándar, 3 y 4 los límites del intervalo de
  confianza al 90% y 5 el coeficiente de variación (%).
- **Transformación.** Se pasó a una fila por municipio con 15 columnas (`ilmm_*`). Se quitaron los
  totales nacional y estatales (`ent = 0` o `mun = 0`).
- **Precisión.** `ilmm_informales_precision` aplica el criterio de los metadatos del ILMM: alta si
  el CV es menor que 15, moderada de 15 a 30 y baja de 30 en adelante. **Los 2,457 municipios de la
  muestra tienen precisión alta**; el CV máximo de la informalidad es 13.4%.
- **Techo en 100%.** **188 municipios** de la muestra tienen informalidad estimada de exactamente
  100%, y 67 tienen 100% de ocupados. En esos casos INEGI publica el límite superior del intervalo
  como 99.99x, apenas debajo del valor. Es un efecto del límite de 100, no un error. Para el
  análisis, la variable tiene una acumulación en el techo que conviene considerar al modelarla.
- **Unidades.** `ilmm_pea` es porcentaje de la población de **15 años y más**. La `PEA` del Censo
  usa como base a la población de **12 años y más**, así que no son comparables directamente.

### 4.3 CONEVAL: pobreza

- **Variables.** Las 17 que indicaste, sin cambios, tomadas de la base limpia de `Base Pobreza`.
- **Población de ponderación.** La población calibrada se renombró como `pob_coneval`, para no
  confundirla con `POBTOT`.
- **`pob_coneval` frente a `POBTOT`.**
  - Suman 127.4 millones contra 126.0 millones del Censo.
  - Por municipio, el cociente va de 0.71 a 1.43.
  - En 323 municipios la diferencia es mayor que ±10%.
  - Úsala solo para ponderar indicadores de CONEVAL. Para densidad y porcentajes del Censo usa
    `POBTOT`.

### 4.4 ITER: Censo 2020

- **Tipos de registro.** `ENTIDAD = 00` es el total nacional, `MUN = 000` el total estatal y
  `LOC = 0000` el **total municipal**. Las variables municipales salen de estos últimos.
- **Datos reservados.** En los totales municipales no hay datos reservados (`*`) ni no disponibles
  (`N/D`); solo `TAMLOC` vale `*` porque no aplica a un municipio. Algunos números vienen con
  espacios a la izquierda y se limpian.
- **Porcentajes (`pct_*`).** Se calculan con el denominador que corresponde al universo de cada
  variable según el diccionario del ITER:

  | Variables | Denominador |
  |---|---|
  | Las 31 `VPH_*` | `VIVPARH_CV` |
  | Personas de 15 años y más | `P_15YMAS` |
  | `P18YM_PB` | `P_18YMAS` |
  | `PEA` y `PE_INAC` | `P_12YMAS` |
  | `POCUPADA` y `PDESOCUP` | `PEA` |
  | `P3YM_HLI` | `P_3YMAS` |
  | `HOGJEF_F` | `TOTHOG` |
  | Las demás de población | `POBTOT` |

- **Localidades.** Son los registros con `LOC` distinto de 0000.
  - Los códigos **9998 y 9999** son resúmenes de las localidades de una y de dos viviendas, que ya
    aparecen una por una. Incluirlos duplicaría 397,479 personas, así que se excluyen. Sin ellos,
    la suma de las localidades es **exactamente igual a `POBTOT`** en los 2,469 municipios.
  - **Población urbana.** `pct_pob_urbana` usa el criterio de INEGI: localidades de 2,500 habitantes
    o más (`TAMLOC >= 5`, según el catálogo `tam_loc`). A nivel nacional da 78.6%. En la muestra,
    807 municipios no tienen ninguna localidad urbana y 24 son totalmente urbanos.
  - **Umbral alterno.** `pct_pob_loc_15mil` usa localidades de 15,000 habitantes o más, como prueba
    de robustez.
- **Coordenadas.**
  - Vienen en grados, minutos y segundos (`102°17'45.768" W`) y se convirtieron a grados decimales,
    con el oeste negativo.
  - La altitud de las localidades bajo el nivel del mar viene como `-006` o `00-2` y se leyó como
    −6 y −2 metros.
  - Se dan para dos localidades de cada municipio:
    - la **más poblada** (`loc_principal_*`);
    - la **0001** (`loc0001_*`), que por convención de INEGI suele ser la cabecera.
  - Esas dos localidades difieren en 364 municipios. Francisco León (Chis.) y Villa de Arista
    (S.L.P.) no tienen localidad 0001.

## 5. Correcciones a la lista original de variables

Revisé cada mnemónico en el diccionario oficial del ITER:

- **`VPH_NDEAED`** no es "sin agua entubada". Son las viviendas que **no tienen energía eléctrica,
  agua entubada ni drenaje**, es decir, ninguno de los tres servicios. La conservé con su
  descripción correcta y **agregué `VPH_AGUAFV`**, que sí es "no disponen de agua entubada".
- **`VPH_PISODT`** es piso firme (material diferente de tierra) y **`VPH_PISOTI`** es piso de tierra.
- **`PDER_SS`** es afiliación a **servicios de salud**, no a seguridad social.
- **Agregué `P_3YMAS`** como denominador de `P3YM_HLI`.
- **Claves y nombres del ITER.** `ENTIDAD`, `NOM_ENT`, `MUN` y `NOM_MUN` no se duplican, porque
  coinciden con el Marco. `LATITUD`, `LONGITUD` y `ALTITUD` no existen en el total municipal; se
  tomaron de las localidades (sección 4.4).

## 6. Calidad de la información censal

En algunos municipios, parte de las viviendas no tiene características captadas; INEGI las cuenta
como "sin información de ocupantes". Normalmente INEGI **imputa** sus características, pero en
algunos municipios quedan como **no especificadas**. Como siguen contando en el denominador, los
porcentajes de vivienda salen **subestimados**. Pasa lo mismo con las variables de población por
edad y afiliación.

La variable **`pct_viv_no_esp`** mide ese problema: es el porcentaje de viviendas sin dato de
electricidad. Con los demás servicios, la edad y la afiliación a salud da prácticamente lo mismo
(correlación de 0.99 o más entre municipios). La mediana es 0%; 36 municipios superan el 1% y 7
superan el 5%:

| CVEGEO | Entidad | Municipio | Viviendas no especificadas (%) | Internet (%) | ¿En la muestra final? |
|---|---|---|---|---|---|
| 29048 | Tlaxcala | La Magdalena Tlaltelulco | 91.8 | 4.1 | No |
| 20407 | Oaxaca | Santa María Chimalapa | 22.0 | 11.1 | Sí |
| 07096 | Chiapas | Tila | 14.7 | 1.6 | Sí |
| 20427 | Oaxaca | Santa María Petapa | 10.1 | 20.3 | Sí |
| 20265 | Oaxaca | San Miguel Chimalapa | 8.0 | 6.2 | Sí |
| 07013 | Chiapas | Bochil | 7.3 | 14.9 | Sí |
| 12073 | Guerrero | Zirándaro | 5.9 | 22.1 | Sí |

Tila, por ejemplo, aparece con 1.6% de viviendas con internet porque el 14.7% no tiene dato.
**Recomendación:** como prueba de robustez, repite los modelos excluyendo los municipios con
`pct_viv_no_esp > 5` (6 en la muestra).

## 7. Validaciones

| Verificación | Resultado |
|---|---|
| Catálogo del Marco = atributos del shapefile (claves y nombres) | 2,469 de 2,469 |
| Polígonos válidos | 2,469 de 2,469 |
| Proyección del `.prj` = EPSG:6372 | Coinciden (diferencia < 0.000001 m) |
| Totales municipales en el ITER | 2,469, sin claves duplicadas ni datos reservados |
| Suma de localidades (sin 9998/9999) = `POBTOT` municipal | 2,469 de 2,469 |
| `TAMLOC` coherente con el `POBTOT` de cada localidad | 189,432 de 189,432 |
| `POBFEM + POBMAS = POBTOT` y `POCUPADA + PDESOCUP = PEA` | Exacto en todos |
| ILMM: 5 estimadores por municipio; CV = 100 × EE / valor | Sí (diferencia ≤ 0.002) |
| ILMM: valor dentro de su intervalo al 90% | Sí, salvo los estimados en 100% (sección 4.2) |
| Claves de CONEVAL = claves del Marco | 2,469 de 2,469 |
| Base final = fuentes (ITER, ILMM, CONEVAL) | 0 diferencias |
| GeoPackage: geometrías válidas, EPSG:6372, mismas áreas que el Excel | Sí |

## 8. Descriptivos de la muestra final (2,457 municipios)

Cada municipio pesa lo mismo.

| Variable | Descripción | Media | DE | Mín | Mediana | Máx |
|---|---|---|---|---|---|---|
| `pobreza_pct` | Pobreza (%) | 61.9 | 21.9 | 5.5 | 62.6 | 99.6 |
| `pobreza_ext_pct` | Pobreza extrema (%) | 17.2 | 15.3 | 0.0 | 12.5 | 84.4 |
| `ilmm_informales` | Informalidad laboral, ILMM (%) | 77.0 | 16.3 | 21.6 | 79.0 | 100.0 |
| `ilmm_pea` | PEA, ILMM (% de 15+) | 57.9 | 3.7 | 43.0 | 58.0 | 73.0 |
| `pct_pob_urbana` | Población urbana (%) | 42.3 | 36.1 | 0.0 | 43.3 | 100.0 |
| `densidad_pob` | Densidad (hab/km²) | 307 | 1,225 | 0 | 55 | 17,523 |
| `area_km2` | Superficie (km²) | 785 | 1,849 | 2 | 233 | 32,060 |
| `POBTOT` | Población total | 51,176 | 147,322 | 81 | 13,552 | 1,922,523 |
| `GRAPROES` | Escolaridad promedio (años) | 7.8 | 1.5 | 3.4 | 7.7 | 14.6 |
| `pct_vph_inter` | Viviendas con internet (%) | 27.2 | 17.8 | 0.0 | 24.2 | 92.0 |
| `pct_vph_pc` | Viviendas con computadora (%) | 18.0 | 12.8 | 0.0 | 15.0 | 85.1 |
| `pct_vph_cel` | Viviendas con celular (%) | 74.0 | 18.3 | 2.4 | 80.4 | 96.9 |
| `pct_vph_sintic` | Viviendas sin ninguna TIC (%) | 7.3 | 8.8 | 0.0 | 3.9 | 61.0 |
| `pct_p3ym_hli` | Hablantes de lengua indígena (% de 3+) | 17.9 | 29.1 | 0.0 | 1.6 | 99.2 |
| `pct_psinder` | Sin afiliación a servicios de salud (%) | 24.1 | 10.8 | 1.0 | 22.6 | 83.9 |
| `pct_pdesocup` | Desocupación, Censo (% de la PEA) | 2.2 | 2.7 | 0.0 | 1.6 | 40.8 |

**Correlaciones de Pearson entre municipios:**

| | Pobreza | Informalidad | % urbana | Internet | Escolaridad | Car. seg. social | Lengua indígena |
|---|---|---|---|---|---|---|---|
| **Pobreza** | 1.00 |  |  |  |  |  |  |
| **Informalidad** | 0.75 | 1.00 |  |  |  |  |  |
| **% urbana** | -0.36 | -0.58 | 1.00 |  |  |  |  |
| **Internet** | -0.69 | -0.70 | 0.63 | 1.00 |  |  |  |
| **Escolaridad** | -0.70 | -0.72 | 0.62 | 0.79 | 1.00 |  |  |
| **Car. seg. social** | 0.71 | 0.70 | -0.43 | -0.63 | -0.66 | 1.00 |  |
| **Lengua indígena** | 0.60 | 0.44 | -0.28 | -0.45 | -0.52 | 0.30 | 1.00 |

La informalidad (ILMM) y la pobreza (CONEVAL) tienen una correlación de 0.75. Ambas se asocian
negativamente con el acceso a internet y con la escolaridad (entre −0.69 y −0.72).

## 9. Notas para el análisis

1. **Matriz W.** Usa el GeoPackage.
   - Con contigüidad tipo reina (polígonos que se tocan en al menos un punto), **ningún municipio de
     la muestra queda aislado**. El mínimo es 1 vecino y el promedio 5.84; 8 municipios tienen un
     solo vecino.
   - INEGI advierte huecos y traslapes de hasta 1 metro entre polígonos, y hay 1,501 pares con
     traslapes mínimos. Por eso la contigüidad tipo torre "exacta" falla. Construye W con tolerancia,
     por ejemplo `spdep::poly2nb(mapa, queen = TRUE, snap = 1)`, que equivale a 1 metro en EPSG:6372.
   - Si armas W solo con la muestra final, los 12 excluidos dejan huecos pequeños, pero ningún
     municipio pierde a todos sus vecinos.
2. **Luces nocturnas (NTL).** Los rásters VIIRS vienen en grados (EPSG:4326). Reproyecta el
   GeoPackage con `st_transform(mapa, 4326)` antes de extraer, por ejemplo con `exactextractr`.
3. **Ponderación.**
   - Las medias simples de municipios no son promedios poblacionales.
   - Para indicadores del Censo, pondera con `POBTOT`.
   - Para CONEVAL, con `pob_coneval`.
4. **Variables que se suman entre sí.** Evita meter juntas en un modelo variables que dependen
   linealmente unas de otras. En CONEVAL:
   - pobreza = extrema + moderada;
   - los cuatro grupos de la clasificación suman 100.

   En el Censo, parejas como `VPH_C_ELEC` y `VPH_S_ELEC` suman casi el total.
5. **Informalidad con techo.** 188 municipios están en 100%. Para esos casos considera modelos para
   variables acotadas o una prueba de robustez sin ellos.
6. **Tres niveles de medición.** Todo está a nivel municipio y las fuentes tienen distinta
   naturaleza:
   - el ITER es censal;
   - el ILMM y el CONEVAL son estimaciones para áreas pequeñas, con error de estimación.
