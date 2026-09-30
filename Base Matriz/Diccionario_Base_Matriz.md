# Diccionario de variables · Base matriz municipal 2020

Base: `Base_Matriz_Municipal_2020.xlsx`, hoja **`datos`** (el `.gpkg` tiene las mismas columnas más la
geometría). Tiene **2,469 filas**, una por municipio del Marco Geoestadístico 2020, y **186 columnas**.
La llave de unión es **`CVEGEO`**, en texto de 5 dígitos.

## Convenciones

- **Nombres del Marco.** Las claves y los nombres de entidad y municipio vienen del catálogo del
  Marco Geoestadístico. CONEVAL abrevia 31 nombres (por ejemplo "Gral. Bravo") y el ITER escribe 4
  sin acento; las claves coinciden en las cuatro fuentes.
- **ITER sin cambios.** Las variables del ITER conservan su mnemónico oficial en mayúsculas (`POBTOT`,
  `VPH_INTER`…) y su valor tal como lo publica INEGI para el total municipal (`LOC = 0000`).
- **Porcentajes del ITER.** Llevan el prefijo `pct_` y el mnemónico en minúsculas: `pct_vph_inter` =
  100 × `VPH_INTER` / `VIVPARH_CV`. El denominador de cada uno viene del universo que marca el
  diccionario del ITER y aparece en la columna *Denominador*.
- **ILMM.** Sus variables llevan el prefijo `ilmm_`. Sin sufijo es el valor estimado (`est = 1`).
  Los sufijos `_ee`, `_li90`, `_ls90` y `_cv` son el error estándar, los límites del intervalo al
  90% y el coeficiente de variación (`est = 2` a `5`).
- **Escala.** Todos los porcentajes van de 0 a 100.
- **Faltantes.** La columna *Faltantes* cuenta las celdas vacías en los 2,469 municipios. En la
  muestra final (`muestra_final == 1`) no hay faltantes, salvo las 4 variables `loc0001_*` en 2
  municipios que no tienen localidad 0001.

## Variables

### Marco Geoestadístico 2020

| # | Variable | Descripción | Unidad | Denominador | Faltantes | Nota |
|---|---|---|---|---|---|---|
| 1 | `CVEGEO` | Clave geoestadística del municipio: entidad (2) + municipio (3). Llave de unión | Texto |  | 0 |  |
| 2 | `cve_ent` | Clave de entidad federativa | Texto (2 dígitos) |  | 0 |  |
| 3 | `nom_ent` | Nombre de la entidad federativa | Texto |  | 0 |  |
| 4 | `cve_mun` | Clave de municipio dentro de la entidad | Texto (3 dígitos) |  | 0 |  |
| 5 | `nom_mun` | Nombre del municipio | Texto |  | 0 |  |

### Construida

| # | Variable | Descripción | Unidad | Denominador | Faltantes | Nota |
|---|---|---|---|---|---|---|
| 6 | `muestra_final` | 1 si el municipio tiene CONEVAL, ILMM e ITER; 0 si le falta alguna fuente | 0/1 |  | 0 |  |
| 7 | `motivo_exclusion` | Fuentes que le faltan al municipio (vacío si está en la muestra final) | Texto |  | 2457 |  |
| 8 | `fuente_coneval` | 1 si CONEVAL tiene estimación 2020 para el municipio | 0/1 |  | 0 |  |
| 9 | `fuente_ilmm` | 1 si el ILMM 2020-1T tiene estimación para el municipio | 0/1 |  | 0 |  |
| 10 | `fuente_iter` | 1 si el municipio tiene registro de total municipal en el ITER 2020 | 0/1 |  | 0 |  |

### Marco Geoestadístico 2020 (00mun.shp)

| # | Variable | Descripción | Unidad | Denominador | Faltantes | Nota |
|---|---|---|---|---|---|---|
| 11 | `area_km2` | Superficie del polígono municipal, calculada en proyección Albers de igual área (GRS80) | km² |  | 0 |  |

### ITER + Marco

| # | Variable | Descripción | Unidad | Denominador | Faltantes | Nota |
|---|---|---|---|---|---|---|
| 12 | `densidad_pob` | Población total (POBTOT) entre superficie | Habitantes por km² |  | 0 |  |

### Marco Geoestadístico 2020 (00mun.shp)

| # | Variable | Descripción | Unidad | Denominador | Faltantes | Nota |
|---|---|---|---|---|---|---|
| 13 | `lon_centroide` | Longitud del centroide geométrico del polígono | Grados decimales (oeste negativo) |  | 0 | En municipios con varias partes (islas) puede caer fuera del polígono |
| 14 | `lat_centroide` | Latitud del centroide geométrico del polígono | Grados decimales |  | 0 |  |

### CONEVAL 2020

| # | Variable | Descripción | Unidad | Denominador | Faltantes | Nota |
|---|---|---|---|---|---|---|
| 15 | `pob_coneval` | Población calibrada por CONEVAL para la medición de pobreza | Personas |  | 3 | Solo para ponderar; difiere de POBTOT del Censo |
| 16 | `pobreza_pct` | Porcentaje de la población en situación de pobreza | Porcentaje (0-100) |  | 3 | Ver Base Pobreza/Diccionario_Variables.md |
| 17 | `pobreza_ext_pct` | Porcentaje de la población en situación de pobreza extrema | Porcentaje (0-100) |  | 3 | Ver Base Pobreza/Diccionario_Variables.md |
| 18 | `pobreza_mod_pct` | Porcentaje de la población en situación de pobreza moderada | Porcentaje (0-100) |  | 3 | Ver Base Pobreza/Diccionario_Variables.md |
| 19 | `pobreza_pers` | Personas en situación de pobreza | Personas |  | 3 | Ver Base Pobreza/Diccionario_Variables.md |
| 20 | `ing_inf_lp_pct` | Porcentaje de la población con ingreso inferior a la línea de pobreza por ingresos | Porcentaje (0-100) |  | 3 | Ver Base Pobreza/Diccionario_Variables.md |
| 21 | `ing_inf_lpe_pct` | Porcentaje de la población con ingreso inferior a la línea de pobreza extrema por ingresos | Porcentaje (0-100) |  | 3 | Ver Base Pobreza/Diccionario_Variables.md |
| 22 | `rezago_edu_pct` | Porcentaje de la población con rezago educativo | Porcentaje (0-100) |  | 3 | Ver Base Pobreza/Diccionario_Variables.md |
| 23 | `car_salud_pct` | Porcentaje con carencia por acceso a los servicios de salud | Porcentaje (0-100) |  | 3 | Ver Base Pobreza/Diccionario_Variables.md |
| 24 | `car_segsoc_pct` | Porcentaje con carencia por acceso a la seguridad social | Porcentaje (0-100) |  | 3 | Ver Base Pobreza/Diccionario_Variables.md |
| 25 | `car_vivienda_pct` | Porcentaje con carencia por calidad y espacios de la vivienda | Porcentaje (0-100) |  | 3 | Ver Base Pobreza/Diccionario_Variables.md |
| 26 | `car_servbas_pct` | Porcentaje con carencia por acceso a los servicios básicos en la vivienda | Porcentaje (0-100) |  | 3 | Ver Base Pobreza/Diccionario_Variables.md |
| 27 | `car_alim_pct` | Porcentaje con carencia por acceso a la alimentación | Porcentaje (0-100) |  | 3 | Ver Base Pobreza/Diccionario_Variables.md |
| 28 | `car_1omas_pct` | Porcentaje con al menos una carencia social | Porcentaje (0-100) |  | 3 | Ver Base Pobreza/Diccionario_Variables.md |
| 29 | `car_3omas_pct` | Porcentaje con tres o más carencias sociales | Porcentaje (0-100) |  | 3 | Ver Base Pobreza/Diccionario_Variables.md |
| 30 | `vul_car_pct` | Porcentaje de la población vulnerable por carencias sociales | Porcentaje (0-100) |  | 3 | Ver Base Pobreza/Diccionario_Variables.md |
| 31 | `vul_ing_pct` | Porcentaje de la población vulnerable por ingresos | Porcentaje (0-100) |  | 3 | Ver Base Pobreza/Diccionario_Variables.md |
| 32 | `no_pobre_no_vul_pct` | Porcentaje de la población no pobre y no vulnerable | Porcentaje (0-100) |  | 3 | Ver Base Pobreza/Diccionario_Variables.md |

### ILMM 2020-1T (INEGI)

| # | Variable | Descripción | Unidad | Denominador | Faltantes | Nota |
|---|---|---|---|---|---|---|
| 33 | `ilmm_pea` | Población económicamente activa, % de la población de 15 años y más | Porcentaje (0-100) |  | 11 | est = 1 |
| 34 | `ilmm_ocupados` | Población ocupada, % de la PEA | Porcentaje (0-100) |  | 11 | est = 1 |
| 35 | `ilmm_informales` | Población ocupada informal, % de la población ocupada | Porcentaje (0-100) |  | 11 | est = 1 |
| 36 | `ilmm_pea_ee` | Población económicamente activa, % de la población de 15 años y más: error estándar | Porcentaje (0-100) |  | 11 | est = 2 |
| 37 | `ilmm_ocupados_ee` | Población ocupada, % de la PEA: error estándar | Porcentaje (0-100) |  | 11 | est = 2 |
| 38 | `ilmm_informales_ee` | Población ocupada informal, % de la población ocupada: error estándar | Porcentaje (0-100) |  | 11 | est = 2 |
| 39 | `ilmm_pea_li90` | Población económicamente activa, % de la población de 15 años y más: límite inferior del IC al 90% | Porcentaje (0-100) |  | 11 | est = 3 |
| 40 | `ilmm_ocupados_li90` | Población ocupada, % de la PEA: límite inferior del IC al 90% | Porcentaje (0-100) |  | 11 | est = 3 |
| 41 | `ilmm_informales_li90` | Población ocupada informal, % de la población ocupada: límite inferior del IC al 90% | Porcentaje (0-100) |  | 11 | est = 3 |
| 42 | `ilmm_pea_ls90` | Población económicamente activa, % de la población de 15 años y más: límite superior del IC al 90% | Porcentaje (0-100) |  | 11 | est = 4 |
| 43 | `ilmm_ocupados_ls90` | Población ocupada, % de la PEA: límite superior del IC al 90% | Porcentaje (0-100) |  | 11 | est = 4 |
| 44 | `ilmm_informales_ls90` | Población ocupada informal, % de la población ocupada: límite superior del IC al 90% | Porcentaje (0-100) |  | 11 | est = 4 |
| 45 | `ilmm_pea_cv` | Población económicamente activa, % de la población de 15 años y más: coeficiente de variación (%) | Porcentaje (0-100) |  | 11 | est = 5 |
| 46 | `ilmm_ocupados_cv` | Población ocupada, % de la PEA: coeficiente de variación (%) | Porcentaje (0-100) |  | 11 | est = 5 |
| 47 | `ilmm_informales_cv` | Población ocupada informal, % de la población ocupada: coeficiente de variación (%) | Porcentaje (0-100) |  | 11 | est = 5 |
| 48 | `ilmm_informales_precision` | Precisión de ilmm_informales según su CV: Alta (< 15), Moderada (15 a 30), Baja (30 o más) | Texto |  | 11 | Criterio de los metadatos del ILMM |

### Censo 2020, ITER (LOC = 0000)

| # | Variable | Descripción | Unidad | Denominador | Faltantes | Nota |
|---|---|---|---|---|---|---|
| 49 | `POBTOT` | Población total | Personas |  | 0 |  |
| 50 | `POBFEM` | Población femenina | Personas |  | 0 |  |
| 51 | `POBMAS` | Población masculina | Personas |  | 0 |  |
| 52 | `REL_H_M` | Relación hombres-mujeres | Hombres por cada 100 mujeres |  | 0 |  |
| 53 | `POB0_14` | Población de 0 a 14 años | Personas |  | 0 |  |
| 54 | `POB15_64` | Población de 15 a 64 años | Personas |  | 0 |  |
| 55 | `POB65_MAS` | Población de 65 años y más | Personas |  | 0 |  |
| 56 | `P_60YMAS` | Población de 60 años y más | Personas |  | 0 |  |
| 57 | `P_3YMAS` | Población de 3 años y más | Personas |  | 0 | Agregada a la lista original (ver reporte) |
| 58 | `P_12YMAS` | Población de 12 años y más | Personas |  | 0 |  |
| 59 | `P_15YMAS` | Población de 15 años y más | Personas |  | 0 |  |
| 60 | `P_18YMAS` | Población de 18 años y más | Personas |  | 0 |  |
| 61 | `VIVPARH_CV` | Total de viviendas particulares habitadas con características | Viviendas |  | 0 |  |
| 62 | `TVIVPARHAB` | Total de viviendas particulares habitadas | Viviendas |  | 0 |  |
| 63 | `VIVPAR_HAB` | Viviendas particulares habitadas | Viviendas |  | 0 |  |
| 64 | `OCUPVIVPAR` | Ocupantes en viviendas particulares habitadas | Personas |  | 0 |  |
| 65 | `PROM_OCUP` | Promedio de ocupantes en viviendas particulares habitadas | Personas por vivienda |  | 0 |  |
| 66 | `TOTHOG` | Total de hogares censales | Hogares |  | 0 |  |
| 67 | `POBHOG` | Población en hogares censales | Personas |  | 0 |  |
| 68 | `HOGJEF_F` | Hogares censales con persona de referencia mujer | Hogares |  | 0 |  |
| 69 | `VPH_INTER` | Viviendas particulares habitadas que disponen de Internet | Viviendas |  | 0 |  |
| 70 | `VPH_PC` | Viviendas particulares habitadas que disponen de computadora, laptop o tablet | Viviendas |  | 0 |  |
| 71 | `VPH_CEL` | Viviendas particulares habitadas que disponen de teléfono celular | Viviendas |  | 0 |  |
| 72 | `VPH_TELEF` | Viviendas particulares habitadas que disponen de línea telefónica fija | Viviendas |  | 0 |  |
| 73 | `VPH_STVP` | Viviendas particulares habitadas que disponen de servicio de televisión de paga | Viviendas |  | 0 |  |
| 74 | `VPH_SPMVPI` | Viviendas particulares habitadas que disponen de servicio de películas, música o videos de paga por Internet | Viviendas |  | 0 |  |
| 75 | `VPH_CVJ` | Viviendas particulares habitadas que disponen de consola de videojuegos | Viviendas |  | 0 |  |
| 76 | `VPH_RADIO` | Viviendas particulares habitadas que disponen de radio | Viviendas |  | 0 |  |
| 77 | `VPH_TV` | Viviendas particulares habitadas que disponen de televisor | Viviendas |  | 0 |  |
| 78 | `VPH_SINCINT` | Viviendas particulares habitadas sin computadora ni Internet | Viviendas |  | 0 |  |
| 79 | `VPH_SINLTC` | Viviendas particulares habitadas sin línea telefónica fija ni teléfono celular | Viviendas |  | 0 |  |
| 80 | `VPH_SINRTV` | Viviendas particulares habitadas sin radio ni televisor | Viviendas |  | 0 |  |
| 81 | `VPH_SINTIC` | Viviendas particulares habitadas sin tecnologías de la información y de la comunicación (TIC) | Viviendas |  | 0 |  |
| 82 | `GRAPROES` | Grado promedio de escolaridad | Años (grados aprobados) |  | 0 |  |
| 83 | `P15YM_AN` | Población de 15 años y más analfabeta | Personas |  | 0 |  |
| 84 | `P15YM_SE` | Población de 15 años y más sin escolaridad | Personas |  | 0 |  |
| 85 | `P18YM_PB` | Población de 18 años y más con educación posbásica | Personas |  | 0 |  |
| 86 | `P15PRI_IN` | Población de 15 años y más con primaria incompleta | Personas |  | 0 |  |
| 87 | `P15SEC_CO` | Población de 15 años y más con secundaria completa | Personas |  | 0 |  |
| 88 | `PEA` | Población de 12 años y más económicamente activa | Personas |  | 0 |  |
| 89 | `PE_INAC` | Población de 12 años y más no económicamente activa | Personas |  | 0 |  |
| 90 | `POCUPADA` | Población de 12 años y más ocupada | Personas |  | 0 |  |
| 91 | `PDESOCUP` | Población de 12 años y más desocupada | Personas |  | 0 |  |
| 92 | `VPH_PISODT` | Viviendas particulares habitadas con piso de material diferente de tierra | Viviendas |  | 0 |  |
| 93 | `VPH_PISOTI` | Viviendas particulares habitadas con piso de tierra | Viviendas |  | 0 |  |
| 94 | `VPH_1CUART` | Viviendas particulares habitadas con sólo un cuarto | Viviendas |  | 0 |  |
| 95 | `VPH_1DOR` | Viviendas particulares habitadas con un dormitorio | Viviendas |  | 0 |  |
| 96 | `VPH_C_ELEC` | Viviendas particulares habitadas que disponen de energía eléctrica | Viviendas |  | 0 |  |
| 97 | `VPH_S_ELEC` | Viviendas particulares habitadas que no disponen de energía eléctrica | Viviendas |  | 0 |  |
| 98 | `VPH_AGUADV` | Viviendas particulares habitadas que disponen de agua entubada en el ámbito de la vivienda | Viviendas |  | 0 |  |
| 99 | `VPH_AGUAFV` | Viviendas particulares habitadas que no disponen de agua entubada en el ámbito de la vivienda | Viviendas |  | 0 | Agregada a la lista original (ver reporte) |
| 100 | `VPH_NDEAED` | Viviendas particulares habitadas que no disponen de energía eléctrica, agua entubada, ni drenaje | Viviendas |  | 0 |  |
| 101 | `VPH_DRENAJ` | Viviendas particulares habitadas que disponen de drenaje | Viviendas |  | 0 |  |
| 102 | `VPH_NODREN` | Viviendas particulares habitadas que no disponen de drenaje | Viviendas |  | 0 |  |
| 103 | `VPH_C_SERV` | Viviendas particulares habitadas que disponen de energía eléctrica, agua entubada de la red pública y drenaje | Viviendas |  | 0 |  |
| 104 | `VPH_REFRI` | Viviendas particulares habitadas que disponen de refrigerador | Viviendas |  | 0 |  |
| 105 | `VPH_LAVAD` | Viviendas particulares habitadas que disponen de lavadora | Viviendas |  | 0 |  |
| 106 | `VPH_AUTOM` | Viviendas particulares habitadas que disponen de automóvil o camioneta | Viviendas |  | 0 |  |
| 107 | `VPH_MOTO` | Viviendas particulares habitadas que disponen de motocicleta o motoneta | Viviendas |  | 0 |  |
| 108 | `VPH_BICI` | Viviendas particulares habitadas que disponen de bicicleta como medio de transporte | Viviendas |  | 0 |  |
| 109 | `VPH_SNBIEN` | Viviendas particulares habitadas sin ningún bien | Viviendas |  | 0 |  |
| 110 | `PSINDER` | Población sin afiliación a servicios de salud | Personas |  | 0 |  |
| 111 | `PDER_SS` | Población afiliada a servicios de salud | Personas |  | 0 |  |
| 112 | `P3YM_HLI` | Población de 3 años y más que habla alguna lengua indígena | Personas |  | 0 |  |
| 113 | `PHOG_IND` | Población en hogares censales indígenas | Personas |  | 0 |  |
| 114 | `POB_AFRO` | Población que se considera afromexicana o afrodescendiente | Personas |  | 0 |  |
| 115 | `PCON_DISC` | Población con discapacidad | Personas |  | 0 |  |

### Censo 2020, ITER (calculada)

| # | Variable | Descripción | Unidad | Denominador | Faltantes | Nota |
|---|---|---|---|---|---|---|
| 116 | `pct_pobfem` | Población femenina, como porcentaje de POBTOT | Porcentaje (0-100) | `POBTOT` | 0 | 100 * POBFEM / POBTOT |
| 117 | `pct_pobmas` | Población masculina, como porcentaje de POBTOT | Porcentaje (0-100) | `POBTOT` | 0 | 100 * POBMAS / POBTOT |
| 118 | `pct_pob0_14` | Población de 0 a 14 años, como porcentaje de POBTOT | Porcentaje (0-100) | `POBTOT` | 0 | 100 * POB0_14 / POBTOT |
| 119 | `pct_pob15_64` | Población de 15 a 64 años, como porcentaje de POBTOT | Porcentaje (0-100) | `POBTOT` | 0 | 100 * POB15_64 / POBTOT |
| 120 | `pct_pob65_mas` | Población de 65 años y más, como porcentaje de POBTOT | Porcentaje (0-100) | `POBTOT` | 0 | 100 * POB65_MAS / POBTOT |
| 121 | `pct_p_60ymas` | Población de 60 años y más, como porcentaje de POBTOT | Porcentaje (0-100) | `POBTOT` | 0 | 100 * P_60YMAS / POBTOT |
| 122 | `pct_hogjef_f` | Hogares censales con persona de referencia mujer, como porcentaje de TOTHOG | Porcentaje (0-100) | `TOTHOG` | 0 | 100 * HOGJEF_F / TOTHOG |
| 123 | `pct_vph_inter` | Viviendas particulares habitadas que disponen de Internet, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_INTER / VIVPARH_CV |
| 124 | `pct_vph_pc` | Viviendas particulares habitadas que disponen de computadora, laptop o tablet, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_PC / VIVPARH_CV |
| 125 | `pct_vph_cel` | Viviendas particulares habitadas que disponen de teléfono celular, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_CEL / VIVPARH_CV |
| 126 | `pct_vph_telef` | Viviendas particulares habitadas que disponen de línea telefónica fija, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_TELEF / VIVPARH_CV |
| 127 | `pct_vph_stvp` | Viviendas particulares habitadas que disponen de servicio de televisión de paga, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_STVP / VIVPARH_CV |
| 128 | `pct_vph_spmvpi` | Viviendas particulares habitadas que disponen de servicio de películas, música o videos de paga por Internet, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_SPMVPI / VIVPARH_CV |
| 129 | `pct_vph_cvj` | Viviendas particulares habitadas que disponen de consola de videojuegos, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_CVJ / VIVPARH_CV |
| 130 | `pct_vph_radio` | Viviendas particulares habitadas que disponen de radio, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_RADIO / VIVPARH_CV |
| 131 | `pct_vph_tv` | Viviendas particulares habitadas que disponen de televisor, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_TV / VIVPARH_CV |
| 132 | `pct_vph_sincint` | Viviendas particulares habitadas sin computadora ni Internet, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_SINCINT / VIVPARH_CV |
| 133 | `pct_vph_sinltc` | Viviendas particulares habitadas sin línea telefónica fija ni teléfono celular, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_SINLTC / VIVPARH_CV |
| 134 | `pct_vph_sinrtv` | Viviendas particulares habitadas sin radio ni televisor, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_SINRTV / VIVPARH_CV |
| 135 | `pct_vph_sintic` | Viviendas particulares habitadas sin tecnologías de la información y de la comunicación (TIC), como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_SINTIC / VIVPARH_CV |
| 136 | `pct_p15ym_an` | Población de 15 años y más analfabeta, como porcentaje de P_15YMAS | Porcentaje (0-100) | `P_15YMAS` | 0 | 100 * P15YM_AN / P_15YMAS |
| 137 | `pct_p15ym_se` | Población de 15 años y más sin escolaridad, como porcentaje de P_15YMAS | Porcentaje (0-100) | `P_15YMAS` | 0 | 100 * P15YM_SE / P_15YMAS |
| 138 | `pct_p18ym_pb` | Población de 18 años y más con educación posbásica, como porcentaje de P_18YMAS | Porcentaje (0-100) | `P_18YMAS` | 0 | 100 * P18YM_PB / P_18YMAS |
| 139 | `pct_p15pri_in` | Población de 15 años y más con primaria incompleta, como porcentaje de P_15YMAS | Porcentaje (0-100) | `P_15YMAS` | 0 | 100 * P15PRI_IN / P_15YMAS |
| 140 | `pct_p15sec_co` | Población de 15 años y más con secundaria completa, como porcentaje de P_15YMAS | Porcentaje (0-100) | `P_15YMAS` | 0 | 100 * P15SEC_CO / P_15YMAS |
| 141 | `pct_pea` | Población de 12 años y más económicamente activa, como porcentaje de P_12YMAS | Porcentaje (0-100) | `P_12YMAS` | 0 | 100 * PEA / P_12YMAS |
| 142 | `pct_pe_inac` | Población de 12 años y más no económicamente activa, como porcentaje de P_12YMAS | Porcentaje (0-100) | `P_12YMAS` | 0 | 100 * PE_INAC / P_12YMAS |
| 143 | `pct_pocupada` | Población de 12 años y más ocupada, como porcentaje de PEA | Porcentaje (0-100) | `PEA` | 0 | 100 * POCUPADA / PEA |
| 144 | `pct_pdesocup` | Población de 12 años y más desocupada, como porcentaje de PEA | Porcentaje (0-100) | `PEA` | 0 | 100 * PDESOCUP / PEA |
| 145 | `pct_vph_pisodt` | Viviendas particulares habitadas con piso de material diferente de tierra, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_PISODT / VIVPARH_CV |
| 146 | `pct_vph_pisoti` | Viviendas particulares habitadas con piso de tierra, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_PISOTI / VIVPARH_CV |
| 147 | `pct_vph_1cuart` | Viviendas particulares habitadas con sólo un cuarto, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_1CUART / VIVPARH_CV |
| 148 | `pct_vph_1dor` | Viviendas particulares habitadas con un dormitorio, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_1DOR / VIVPARH_CV |
| 149 | `pct_vph_c_elec` | Viviendas particulares habitadas que disponen de energía eléctrica, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_C_ELEC / VIVPARH_CV |
| 150 | `pct_vph_s_elec` | Viviendas particulares habitadas que no disponen de energía eléctrica, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_S_ELEC / VIVPARH_CV |
| 151 | `pct_vph_aguadv` | Viviendas particulares habitadas que disponen de agua entubada en el ámbito de la vivienda, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_AGUADV / VIVPARH_CV |
| 152 | `pct_vph_aguafv` | Viviendas particulares habitadas que no disponen de agua entubada en el ámbito de la vivienda, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_AGUAFV / VIVPARH_CV |
| 153 | `pct_vph_ndeaed` | Viviendas particulares habitadas que no disponen de energía eléctrica, agua entubada, ni drenaje, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_NDEAED / VIVPARH_CV |
| 154 | `pct_vph_drenaj` | Viviendas particulares habitadas que disponen de drenaje, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_DRENAJ / VIVPARH_CV |
| 155 | `pct_vph_nodren` | Viviendas particulares habitadas que no disponen de drenaje, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_NODREN / VIVPARH_CV |
| 156 | `pct_vph_c_serv` | Viviendas particulares habitadas que disponen de energía eléctrica, agua entubada de la red pública y drenaje, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_C_SERV / VIVPARH_CV |
| 157 | `pct_vph_refri` | Viviendas particulares habitadas que disponen de refrigerador, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_REFRI / VIVPARH_CV |
| 158 | `pct_vph_lavad` | Viviendas particulares habitadas que disponen de lavadora, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_LAVAD / VIVPARH_CV |
| 159 | `pct_vph_autom` | Viviendas particulares habitadas que disponen de automóvil o camioneta, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_AUTOM / VIVPARH_CV |
| 160 | `pct_vph_moto` | Viviendas particulares habitadas que disponen de motocicleta o motoneta, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_MOTO / VIVPARH_CV |
| 161 | `pct_vph_bici` | Viviendas particulares habitadas que disponen de bicicleta como medio de transporte, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_BICI / VIVPARH_CV |
| 162 | `pct_vph_snbien` | Viviendas particulares habitadas sin ningún bien, como porcentaje de VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | 100 * VPH_SNBIEN / VIVPARH_CV |
| 163 | `pct_psinder` | Población sin afiliación a servicios de salud, como porcentaje de POBTOT | Porcentaje (0-100) | `POBTOT` | 0 | 100 * PSINDER / POBTOT |
| 164 | `pct_pder_ss` | Población afiliada a servicios de salud, como porcentaje de POBTOT | Porcentaje (0-100) | `POBTOT` | 0 | 100 * PDER_SS / POBTOT |
| 165 | `pct_p3ym_hli` | Población de 3 años y más que habla alguna lengua indígena, como porcentaje de P_3YMAS | Porcentaje (0-100) | `P_3YMAS` | 0 | 100 * P3YM_HLI / P_3YMAS |
| 166 | `pct_phog_ind` | Población en hogares censales indígenas, como porcentaje de POBTOT | Porcentaje (0-100) | `POBTOT` | 0 | 100 * PHOG_IND / POBTOT |
| 167 | `pct_pob_afro` | Población que se considera afromexicana o afrodescendiente, como porcentaje de POBTOT | Porcentaje (0-100) | `POBTOT` | 0 | 100 * POB_AFRO / POBTOT |
| 168 | `pct_pcon_disc` | Población con discapacidad, como porcentaje de POBTOT | Porcentaje (0-100) | `POBTOT` | 0 | 100 * PCON_DISC / POBTOT |
| 169 | `pct_viv_no_esp` | Porcentaje de viviendas con características no especificadas: 100 * (VIVPARH_CV - VPH_C_ELEC - VPH_S_ELEC) / VIVPARH_CV | Porcentaje (0-100) | `VIVPARH_CV` | 0 | Indicador de calidad: si es alto, los porcentajes de vivienda y de población están subestimados |

### Censo 2020, ITER (localidades)

| # | Variable | Descripción | Unidad | Denominador | Faltantes | Nota |
|---|---|---|---|---|---|---|
| 170 | `n_localidades` | Número de localidades con registro en el ITER | Localidades |  | 0 |  |
| 171 | `n_loc_urbanas` | Número de localidades de 2,500 habitantes o más (TAMLOC >= 5) | Localidades |  | 0 |  |
| 172 | `pob_urbana` | Población en localidades de 2,500 habitantes o más | Personas |  | 0 |  |
| 173 | `pct_pob_urbana` | Porcentaje de la población en localidades de 2,500 habitantes o más (población urbana, criterio INEGI) | Porcentaje (0-100) | `POBTOT` | 0 |  |
| 174 | `pob_loc_15mil` | Población en localidades de 15,000 habitantes o más (TAMLOC >= 8) | Personas |  | 0 |  |
| 175 | `pct_pob_loc_15mil` | Porcentaje de la población en localidades de 15,000 habitantes o más | Porcentaje (0-100) | `POBTOT` | 0 |  |
| 176 | `loc_principal_clave` | Clave de la localidad más poblada del municipio | Texto (4 dígitos) |  | 0 |  |
| 177 | `loc_principal_nombre` | Nombre de la localidad más poblada | Texto |  | 0 |  |
| 178 | `loc_principal_pob` | Población de la localidad más poblada | Personas |  | 0 |  |
| 179 | `pct_pob_loc_principal` | Porcentaje de la población municipal en la localidad más poblada | Porcentaje (0-100) | `POBTOT` | 0 |  |
| 180 | `loc_principal_lon` | Longitud de la localidad más poblada | Grados decimales (oeste negativo) |  | 0 |  |
| 181 | `loc_principal_lat` | Latitud de la localidad más poblada | Grados decimales |  | 0 |  |
| 182 | `loc_principal_alt` | Altitud de la localidad más poblada | Metros sobre el nivel del mar |  | 0 |  |
| 183 | `loc0001_nombre` | Nombre de la localidad 0001 | Texto |  | 2 | Por convención de INEGI la 0001 suele ser la cabecera municipal; 2 municipios no la tienen (vacío) |
| 184 | `loc0001_lon` | Longitud de la localidad 0001 | Grados decimales (oeste negativo) |  | 2 | Por convención de INEGI la 0001 suele ser la cabecera municipal; 2 municipios no la tienen (vacío) |
| 185 | `loc0001_lat` | Latitud de la localidad 0001 | Grados decimales |  | 2 | Por convención de INEGI la 0001 suele ser la cabecera municipal; 2 municipios no la tienen (vacío) |
| 186 | `loc0001_alt` | Altitud de la localidad 0001 | Metros sobre el nivel del mar |  | 2 | Por convención de INEGI la 0001 suele ser la cabecera municipal; 2 municipios no la tienen (vacío) |
## Notas sobre la lista original de variables

Comparé cada mnemónico con el diccionario oficial del ITER (`diccionario_datos_iter_00CSV20.csv`).
Estas son las diferencias con la descripción que tenías:

| Mnemónico | Lo que dice el diccionario del ITER | Qué hice |
|---|---|---|
| `VPH_NDEAED` | Viviendas que **no disponen de energía eléctrica, agua entubada ni drenaje** (ninguno de los tres). No es "sin agua entubada". | La conservé con su descripción correcta. |
| `VPH_AGUAFV` | Viviendas que **no disponen de agua entubada** en el ámbito de la vivienda. | **La agregué**: es la contraparte de `VPH_AGUADV`. |
| `VPH_PISODT` / `VPH_PISOTI` | `PISODT` es piso de material **diferente de tierra** (firme); `PISOTI` es piso **de tierra**. | Sin cambio; solo el orden estaba invertido en la lista. |
| `PDER_SS` | Población **afiliada a servicios de salud** (IMSS, ISSSTE, INSABI, privados, etc.), no a seguridad social. | Sin cambio. |
| `P_3YMAS` | Población de 3 años y más. | **La agregué** como denominador de `P3YM_HLI`. |
| `ENTIDAD`, `NOM_ENT`, `MUN`, `NOM_MUN`, `LOC` | Claves y nombres del ITER. | No se duplican: comprobé que coinciden con el Marco en los 2,469 municipios. `LOC` vale 0000 en todos los totales municipales. |
| `LATITUD`, `LONGITUD`, `ALTITUD` | En el ITER solo existen por localidad (vacías en el total municipal), en grados, minutos y segundos. | Las convertí a grados decimales para la localidad más poblada y para la localidad 0001. |
