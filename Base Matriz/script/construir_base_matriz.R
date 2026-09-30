# =============================================================================
# Base Matriz · Base municipal 2020
#
# Une por CVEGEO (5 dígitos en texto: entidad de 2 + municipio de 3) cuatro fuentes:
#   1. Marco Geoestadístico 2020 integrado (INEGI): claves, nombres y polígonos
#   2. ILMM 2020, primer trimestre (INEGI): PEA, ocupación e informalidad
#   3. CONEVAL 2020: base limpia de este repositorio (carpeta Base Pobreza)
#   4. Censo de Población y Vivienda 2020, ITER (INEGI): totales municipales
#      (LOC = 0000) y registros de localidad
#
# Salidas (carpeta Base Matriz):
#   Base_Matriz_Municipal_2020.xlsx  datos sin geometría, diccionario y universo
#   Base_Matriz_Municipal_2020.gpkg  los mismos datos con el polígono municipal
#
# No se elimina ningún municipio: la base conserva los 2,469 del Marco. La
# columna muestra_final marca a los que tienen las tres fuentes estadísticas y
# motivo_exclusion explica por qué los demás quedan fuera.
#
# Correr desde la raíz del repositorio Tesis:
#   source("Base Matriz/script/construir_base_matriz.R", encoding = "UTF-8")
# Las fuentes originales no están en el repositorio (el ITER pesa 150 MB); se
# leen de dir_bases. Paquetes: sf, data.table, readxl, openxlsx
# =============================================================================

suppressPackageStartupMessages({
  library(sf)
  library(data.table)
  library(readxl)
  library(openxlsx)
})

# -----------------------------------------------------------------------------
# 0. Rutas
# -----------------------------------------------------------------------------
# Carpeta con las descargas de INEGI. Se puede cambiar con la variable de
# entorno TESIS_BASES sin tocar el script.
dir_bases <- Sys.getenv("TESIS_BASES",
                        "C:/Users/abram/OneDrive/Desktop/TESIS/Bases de datos")

rutas <- list(
  shp     = file.path(dir_bases, "MG_2020_Integrado", "conjunto_de_datos", "00mun.shp"),
  mun_cat = file.path(dir_bases, "MG_2020_Integrado", "catalogos", "municipios.csv"),
  ilmm    = file.path(dir_bases, "ILMM", "conjunto_de_datos", "conjunto_de_datos_ilmm_2020_1t.csv"),
  iter    = file.path(dir_bases, "ITER_NALCSV20.csv"),
  coneval = file.path("Base Pobreza", "Pobreza_Municipal_2020_Limpia.xlsx")
)
faltan <- names(rutas)[!file.exists(unlist(rutas))]
if (length(faltan)) stop("No se encontraron: ", paste(unlist(rutas[faltan]), collapse = "; "))

carpeta   <- "Base Matriz"
vars_iter <- fread(file.path(carpeta, "script", "variables_iter.csv"), encoding = "UTF-8")
salida_xlsx <- file.path(carpeta, "Base_Matriz_Municipal_2020.xlsx")
salida_gpkg <- file.path(carpeta, "Base_Matriz_Municipal_2020.gpkg")

# -----------------------------------------------------------------------------
# 1. Marco Geoestadístico 2020: claves, nombres, polígono y superficie
# -----------------------------------------------------------------------------
# Catálogo: tres filas de título; la tercera es el encabezado
catalogo <- fread(rutas$mun_cat, skip = 2, sep = ";", colClasses = "character",
                  encoding = "Latin-1", header = TRUE)
setnames(catalogo, c("cve_ent", "nom_ent", "cve_mun", "nom_mun"))
catalogo[, names(catalogo) := lapply(.SD, enc2utf8)]
catalogo[, CVEGEO := paste0(cve_ent, cve_mun)]

# Polígonos (00mun.cpg declara UTF-8)
mun_sf <- st_read(rutas$shp, quiet = TRUE)
stopifnot(nrow(mun_sf) == 2469, !anyDuplicated(mun_sf$CVEGEO),
          setequal(mun_sf$CVEGEO, catalogo$CVEGEO),
          all(st_is_valid(mun_sf)))
stopifnot(identical(catalogo$nom_mun[match(mun_sf$CVEGEO, catalogo$CVEGEO)], mun_sf$NOMGEO))

# El .prj trae los parámetros de "MEXICO_ITRF_2008_LCC" sin código EPSG. Son los
# mismos que EPSG:6372 (Mexico ITRF2008 / LCC); se asigna el código para que
# QGIS, R o Python lo reconozcan. Antes se comprueba que proyectan igual.
prueba <- st_sfc(st_point(c(-96.92, 19.54)), crs = 4326)
stopifnot(max(abs(st_coordinates(st_transform(prueba, st_crs(mun_sf))) -
                  st_coordinates(st_transform(prueba, 6372)))) < 1e-6)
mun_sf <- suppressWarnings(st_set_crs(mun_sf, 6372))

# Superficie: la proyección Lambert conforme del Marco no conserva áreas (error
# de -1.1% a +1.4% por municipio). Se usa una Albers equivalente (igual área)
# sobre el elipsoide GRS80, con los mismos paralelos estándar del Marco.
crs_igual_area <- paste("+proj=aea +lat_0=12 +lon_0=-102 +lat_1=17.5 +lat_2=29.5",
                        "+x_0=2500000 +y_0=0 +ellps=GRS80 +units=m +no_defs")
mun_sf$area_km2 <- as.numeric(st_area(st_transform(mun_sf, crs_igual_area))) / 1e6

# Centroide geométrico en grados decimales (ITRF2008 ~ WGS84)
centroides <- st_coordinates(st_transform(st_centroid(st_geometry(mun_sf)), 4326))
mun_sf$lon_centroide <- centroides[, "X"]
mun_sf$lat_centroide <- centroides[, "Y"]

marco <- merge(catalogo[, .(CVEGEO, cve_ent, nom_ent, cve_mun, nom_mun)],
               as.data.table(st_drop_geometry(mun_sf))[, .(CVEGEO, area_km2, lon_centroide, lat_centroide)],
               by = "CVEGEO")

# -----------------------------------------------------------------------------
# 2. ILMM 2020-1T: una fila por municipio y tipo de estimador (est = 1 a 5)
#    1 valor, 2 error estándar, 3 y 4 límites del intervalo de confianza al 90%,
#    5 coeficiente de variación (%). Los tres indicadores son porcentajes.
# -----------------------------------------------------------------------------
ilmm <- fread(rutas$ilmm, encoding = "UTF-8")
stopifnot(identical(names(ilmm), c("ent", "mun", "est", "pea", "ocupados", "informales")))
ilmm <- ilmm[ent > 0 & mun > 0]                 # quita totales nacional y estatales
ilmm[, CVEGEO := sprintf("%02d%03d", ent, mun)]
stopifnot(all(ilmm[, .N, by = CVEGEO]$N == 5))

sufijo_est <- c("1" = "", "2" = "_ee", "3" = "_li90", "4" = "_ls90", "5" = "_cv")
ilmm_w <- dcast(ilmm, CVEGEO ~ est, value.var = c("pea", "ocupados", "informales"), sep = "@")
viejos <- setdiff(names(ilmm_w), "CVEGEO")
setnames(ilmm_w, viejos, paste0("ilmm_", sub("@.*", "", viejos), sufijo_est[sub(".*@", "", viejos)]))
orden_ilmm <- as.vector(outer(c("ilmm_pea", "ilmm_ocupados", "ilmm_informales"),
                              sufijo_est, paste0))
setcolorder(ilmm_w, c("CVEGEO", orden_ilmm))

# Precisión según los metadatos del ILMM: alta CV < 15, moderada 15-30, baja >= 30
ilmm_w[, ilmm_informales_precision := as.character(cut(ilmm_informales_cv, c(0, 15, 30, Inf),
                                                       right = FALSE,
                                                       labels = c("Alta", "Moderada", "Baja")))]
# El valor cae dentro de su intervalo, salvo cuando INEGI estima 100%: ahí el
# límite superior publicado es 99.99x (intervalo acotado en 100)
for (v in c("pea", "ocupados", "informales")) {
  x <- ilmm_w[[paste0("ilmm_", v)]]
  fuera <- x < ilmm_w[[paste0("ilmm_", v, "_li90")]] | x > ilmm_w[[paste0("ilmm_", v, "_ls90")]]
  stopifnot(all(x[fuera] == 100))
}

# -----------------------------------------------------------------------------
# 3. CONEVAL 2020 (base limpia, hoja datos). cve_mun es la clave de 5 dígitos.
#    poblacion es la calibrada por CONEVAL: solo para ponderar.
# -----------------------------------------------------------------------------
vars_coneval <- c("pobreza_pct", "pobreza_ext_pct", "pobreza_mod_pct", "pobreza_pers",
                  "ing_inf_lp_pct", "ing_inf_lpe_pct",
                  "rezago_edu_pct", "car_salud_pct", "car_segsoc_pct", "car_vivienda_pct",
                  "car_servbas_pct", "car_alim_pct", "car_1omas_pct", "car_3omas_pct",
                  "vul_car_pct", "vul_ing_pct", "no_pobre_no_vul_pct")
coneval <- as.data.table(read_excel(rutas$coneval, sheet = "datos"))
coneval <- coneval[, c("cve_mun", "poblacion", vars_coneval), with = FALSE]
setnames(coneval, c("cve_mun", "poblacion"), c("CVEGEO", "pob_coneval"))
stopifnot(nrow(coneval) == 2469, setequal(coneval$CVEGEO, marco$CVEGEO))

# -----------------------------------------------------------------------------
# 4. ITER 2020
#    Registros: ENTIDAD 00 = nacional; MUN 000 = estatal; LOC 0000 = total
#    municipal; LOC 9998 y 9999 = resúmenes de localidades de una y de dos
#    viviendas, que ya aparecen una por una (sumarlos duplicaría población).
#    Códigos: "*" = dato reservado por confidencialidad; "N/D" = no disponible.
# -----------------------------------------------------------------------------
cols_id  <- c("ENTIDAD", "MUN", "LOC", "NOM_LOC", "LONGITUD", "LATITUD", "ALTITUD", "TAMLOC")
iter <- fread(rutas$iter, colClasses = "character", encoding = "UTF-8",
              select = unique(c(cols_id, vars_iter$mnemonico)))
iter[, (names(iter)) := lapply(.SD, trimws)]   # algunos números traen espacios a la izquierda
iter[, CVEGEO := paste0(ENTIDAD, MUN)]

a_numero <- function(x) {
  x[x %in% c("*", "N/D", "")] <- NA
  y <- suppressWarnings(as.numeric(x))
  if (any(is.na(y) & !is.na(x))) stop("Valores no numéricos inesperados: ",
                                       paste(head(unique(x[is.na(y) & !is.na(x)])), collapse = ", "))
  y
}

# 4.1 Totales municipales (LOC = 0000)
iter_mun <- iter[ENTIDAD != "00" & MUN != "000" & LOC == "0000"]
stopifnot(nrow(iter_mun) == 2469, !anyDuplicated(iter_mun$CVEGEO))
# En los totales municipales solo TAMLOC viene como "*" (no aplica): no hay datos reservados
stopifnot(iter_mun[, all(unlist(lapply(.SD, function(x) !any(x %in% c("*", "N/D"))))),
                   .SDcols = vars_iter$mnemonico])
iter_mun <- iter_mun[, c("CVEGEO", vars_iter$mnemonico), with = FALSE]
iter_mun[, (vars_iter$mnemonico) := lapply(.SD, a_numero), .SDcols = vars_iter$mnemonico]

# 4.2 Porcentajes con el denominador del diccionario del ITER
con_den <- vars_iter[denominador != ""]
for (i in seq_len(nrow(con_den))) {
  v <- con_den$mnemonico[i]; d <- con_den$denominador[i]
  set(iter_mun, j = paste0("pct_", tolower(v)),
      value = 100 * iter_mun[[v]] / iter_mun[[d]])
}

# Calidad de la captación: porcentaje de viviendas sin dato en sus
# características (no especificado). Se mide con electricidad; en agua, drenaje,
# piso, edad y afiliación a salud el porcentaje es prácticamente el mismo
# (correlación de 0.99 o más entre municipios). Donde es alto, los porcentajes
# de vivienda y de población quedan subestimados.
iter_mun[, pct_viv_no_esp := 100 * (VIVPARH_CV - VPH_C_ELEC - VPH_S_ELEC) / VIVPARH_CV]

# 4.3 Localidades (LOC distinto de 0000, 9998 y 9999)
loc <- iter[ENTIDAD != "00" & MUN != "000" & !LOC %in% c("0000", "9998", "9999"),
            .(CVEGEO, LOC, NOM_LOC, LONGITUD, LATITUD, ALTITUD,
              TAMLOC = as.integer(TAMLOC), POBTOT = a_numero(POBTOT))]
stopifnot(!anyNA(loc$TAMLOC), !anyNA(loc$POBTOT))
# La suma de las localidades reproduce exactamente la población municipal
control <- merge(loc[, .(suma = sum(POBTOT)), by = CVEGEO], iter_mun[, .(CVEGEO, POBTOT)], by = "CVEGEO")
stopifnot(nrow(control) == 2469, control[, all(suma == POBTOT)])

# Coordenadas "102°17'45.768\" W" -> grados decimales (oeste y sur negativos)
dms_a_decimal <- function(x) {
  x <- gsub('"+', '"', x)   # en el CSV la comilla de los segundos viene escapada ("")
  p <- regmatches(x, regexec("^(\\d+)\u00b0(\\d+)'([0-9.]+)\" ([NSEW])$", x))
  vapply(p, function(v) {
    if (length(v) != 5) return(NA_real_)
    g <- as.numeric(v[2]) + as.numeric(v[3]) / 60 + as.numeric(v[4]) / 3600
    if (v[5] %in% c("S", "W")) -g else g
  }, numeric(1))
}
# Altitud en metros. Las localidades bajo el nivel del mar vienen como "-006" o
# "00-2"; ambas formas se leen como -6 y -2
loc[, `:=`(lon = dms_a_decimal(LONGITUD), lat = dms_a_decimal(LATITUD),
           alt = a_numero(sub("^0+-", "-", ALTITUD)))]
stopifnot(!anyNA(loc$lon), !anyNA(loc$lat))

# TAMLOC: 5 = 2,500 a 4,999 habitantes (urbana según INEGI); 8 = 15,000 a 29,999
loc_mun <- loc[, .(n_localidades = .N,
                   n_loc_urbanas = sum(TAMLOC >= 5),
                   pob_urbana    = sum(POBTOT[TAMLOC >= 5]),
                   pob_loc_15mil = sum(POBTOT[TAMLOC >= 8])), by = CVEGEO]

# Localidad más poblada (en caso de empate, la de clave menor)
setorder(loc, CVEGEO, -POBTOT, LOC)
principal <- loc[loc[, .I[1], by = CVEGEO]$V1,
                 .(CVEGEO, loc_principal_clave = LOC, loc_principal_nombre = NOM_LOC,
                   loc_principal_pob = POBTOT, loc_principal_lon = lon,
                   loc_principal_lat = lat, loc_principal_alt = alt)]
# Localidad 0001 (por convención, casi siempre la cabecera municipal)
loc0001 <- loc[LOC == "0001", .(CVEGEO, loc0001_nombre = NOM_LOC, loc0001_lon = lon,
                                loc0001_lat = lat, loc0001_alt = alt)]

iter_loc <- Reduce(function(a, b) merge(a, b, by = "CVEGEO", all.x = TRUE),
                   list(loc_mun, principal, loc0001))

# -----------------------------------------------------------------------------
# 5. Unión por CVEGEO sobre el universo del Marco (2,469 municipios)
# -----------------------------------------------------------------------------
base <- Reduce(function(a, b) merge(a, b, by = "CVEGEO", all.x = TRUE),
               list(marco, coneval, ilmm_w, iter_mun, iter_loc))

base[, `:=`(
  densidad_pob         = POBTOT / area_km2,
  pct_pob_urbana       = 100 * pob_urbana / POBTOT,
  pct_pob_loc_15mil    = 100 * pob_loc_15mil / POBTOT,
  pct_pob_loc_principal = 100 * loc_principal_pob / POBTOT
)]

base[, `:=`(
  fuente_coneval = as.integer(!is.na(pobreza_pct)),
  fuente_ilmm    = as.integer(!is.na(ilmm_informales)),
  fuente_iter    = as.integer(!is.na(POBTOT))
)]
base[, muestra_final := as.integer(fuente_coneval & fuente_ilmm & fuente_iter)]
base[, motivo_exclusion := gsub("\\s+", " ", trimws(paste(
  ifelse(fuente_coneval == 0, "Sin estimación CONEVAL 2020.", ""),
  ifelse(fuente_ilmm == 0, "Sin estimación ILMM 2020.", ""),
  ifelse(fuente_iter == 0, "Sin registro ITER 2020.", ""))))]

# Orden de columnas
cols_pct_iter <- paste0("pct_", tolower(con_den$mnemonico))
orden <- c("CVEGEO", "cve_ent", "nom_ent", "cve_mun", "nom_mun",
           "muestra_final", "motivo_exclusion", "fuente_coneval", "fuente_ilmm", "fuente_iter",
           "area_km2", "densidad_pob", "lon_centroide", "lat_centroide",
           "pob_coneval", vars_coneval,
           orden_ilmm, "ilmm_informales_precision",
           vars_iter$mnemonico, cols_pct_iter, "pct_viv_no_esp",
           "n_localidades", "n_loc_urbanas", "pob_urbana", "pct_pob_urbana",
           "pob_loc_15mil", "pct_pob_loc_15mil",
           "loc_principal_clave", "loc_principal_nombre", "loc_principal_pob",
           "pct_pob_loc_principal", "loc_principal_lon", "loc_principal_lat", "loc_principal_alt",
           "loc0001_nombre", "loc0001_lon", "loc0001_lat", "loc0001_alt")
stopifnot(setequal(orden, names(base)))
setcolorder(base, orden)
setorder(base, CVEGEO)

# -----------------------------------------------------------------------------
# 6. Diccionario de variables
# -----------------------------------------------------------------------------
fila <- function(variable, fuente, descripcion, unidad, denominador = "", nota = "") {
  data.table(variable, fuente, descripcion, unidad, denominador, nota)
}
dic <- rbindlist(list(
  fila("CVEGEO", "Marco Geoestadístico 2020", "Clave geoestadística del municipio: entidad (2) + municipio (3). Llave de unión", "Texto"),
  fila("cve_ent", "Marco Geoestadístico 2020", "Clave de entidad federativa", "Texto (2 dígitos)"),
  fila("nom_ent", "Marco Geoestadístico 2020", "Nombre de la entidad federativa", "Texto"),
  fila("cve_mun", "Marco Geoestadístico 2020", "Clave de municipio dentro de la entidad", "Texto (3 dígitos)"),
  fila("nom_mun", "Marco Geoestadístico 2020", "Nombre del municipio", "Texto"),
  fila("muestra_final", "Construida", "1 si el municipio tiene CONEVAL, ILMM e ITER; 0 si le falta alguna fuente", "0/1"),
  fila("motivo_exclusion", "Construida", "Fuentes que le faltan al municipio (vacío si está en la muestra final)", "Texto"),
  fila("fuente_coneval", "Construida", "1 si CONEVAL tiene estimación 2020 para el municipio", "0/1"),
  fila("fuente_ilmm", "Construida", "1 si el ILMM 2020-1T tiene estimación para el municipio", "0/1"),
  fila("fuente_iter", "Construida", "1 si el municipio tiene registro de total municipal en el ITER 2020", "0/1"),
  fila("area_km2", "Marco Geoestadístico 2020 (00mun.shp)", "Superficie del polígono municipal, calculada en proyección Albers de igual área (GRS80)", "km²"),
  fila("densidad_pob", "ITER + Marco", "Población total (POBTOT) entre superficie", "Habitantes por km²"),
  fila("lon_centroide", "Marco Geoestadístico 2020 (00mun.shp)", "Longitud del centroide geométrico del polígono", "Grados decimales (oeste negativo)", nota = "En municipios con varias partes (islas) puede caer fuera del polígono"),
  fila("lat_centroide", "Marco Geoestadístico 2020 (00mun.shp)", "Latitud del centroide geométrico del polígono", "Grados decimales"),
  fila("pob_coneval", "CONEVAL 2020", "Población calibrada por CONEVAL para la medición de pobreza", "Personas", nota = "Solo para ponderar; difiere de POBTOT del Censo"),
  fila(vars_coneval, "CONEVAL 2020",
       c("Porcentaje de la población en situación de pobreza",
         "Porcentaje de la población en situación de pobreza extrema",
         "Porcentaje de la población en situación de pobreza moderada",
         "Personas en situación de pobreza",
         "Porcentaje de la población con ingreso inferior a la línea de pobreza por ingresos",
         "Porcentaje de la población con ingreso inferior a la línea de pobreza extrema por ingresos",
         "Porcentaje de la población con rezago educativo",
         "Porcentaje con carencia por acceso a los servicios de salud",
         "Porcentaje con carencia por acceso a la seguridad social",
         "Porcentaje con carencia por calidad y espacios de la vivienda",
         "Porcentaje con carencia por acceso a los servicios básicos en la vivienda",
         "Porcentaje con carencia por acceso a la alimentación",
         "Porcentaje con al menos una carencia social",
         "Porcentaje con tres o más carencias sociales",
         "Porcentaje de la población vulnerable por carencias sociales",
         "Porcentaje de la población vulnerable por ingresos",
         "Porcentaje de la población no pobre y no vulnerable"),
       ifelse(vars_coneval == "pobreza_pers", "Personas", "Porcentaje (0-100)"),
       nota = "Ver Base Pobreza/Diccionario_Variables.md"),
  fila(orden_ilmm, "ILMM 2020-1T (INEGI)",
       paste0(rep(c("Población económicamente activa, % de la población de 15 años y más",
                    "Población ocupada, % de la PEA",
                    "Población ocupada informal, % de la población ocupada"), times = 5),
              rep(c("", ": error estándar", ": límite inferior del IC al 90%",
                    ": límite superior del IC al 90%", ": coeficiente de variación (%)"), each = 3)),
       "Porcentaje (0-100)",
       nota = rep(c("est = 1", "est = 2", "est = 3", "est = 4", "est = 5"), each = 3)),
  fila("ilmm_informales_precision", "ILMM 2020-1T (INEGI)", "Precisión de ilmm_informales según su CV: Alta (< 15), Moderada (15 a 30), Baja (30 o más)", "Texto",
       nota = "Criterio de los metadatos del ILMM"),
  fila(vars_iter$mnemonico, "Censo 2020, ITER (LOC = 0000)", vars_iter$indicador_inegi,
       fifelse(vars_iter$mnemonico %in% c("REL_H_M"), "Hombres por cada 100 mujeres",
       fifelse(vars_iter$mnemonico %in% c("PROM_OCUP"), "Personas por vivienda",
       fifelse(vars_iter$mnemonico %in% c("GRAPROES"), "Años (grados aprobados)",
       fifelse(grepl("^VPH_|^VIVPAR|^TVIV", vars_iter$mnemonico), "Viviendas",
       fifelse(vars_iter$mnemonico %in% c("TOTHOG", "HOGJEF_F"), "Hogares", "Personas"))))),
       nota = fifelse(vars_iter$agregada == 1, "Agregada a la lista original (ver reporte)", "")),
  fila(cols_pct_iter, "Censo 2020, ITER (calculada)",
       paste0(con_den$indicador_inegi, ", como porcentaje de ", con_den$denominador),
       "Porcentaje (0-100)", con_den$denominador,
       nota = paste0("100 * ", con_den$mnemonico, " / ", con_den$denominador)),
  fila("pct_viv_no_esp", "Censo 2020, ITER (calculada)",
       "Porcentaje de viviendas con características no especificadas: 100 * (VIVPARH_CV - VPH_C_ELEC - VPH_S_ELEC) / VIVPARH_CV",
       "Porcentaje (0-100)", "VIVPARH_CV",
       nota = "Indicador de calidad: si es alto, los porcentajes de vivienda y de población están subestimados"),
  fila(c("n_localidades", "n_loc_urbanas", "pob_urbana", "pct_pob_urbana", "pob_loc_15mil", "pct_pob_loc_15mil"),
       "Censo 2020, ITER (localidades)",
       c("Número de localidades con registro en el ITER",
         "Número de localidades de 2,500 habitantes o más (TAMLOC >= 5)",
         "Población en localidades de 2,500 habitantes o más",
         "Porcentaje de la población en localidades de 2,500 habitantes o más (población urbana, criterio INEGI)",
         "Población en localidades de 15,000 habitantes o más (TAMLOC >= 8)",
         "Porcentaje de la población en localidades de 15,000 habitantes o más"),
       c("Localidades", "Localidades", "Personas", "Porcentaje (0-100)", "Personas", "Porcentaje (0-100)"),
       c("", "", "", "POBTOT", "", "POBTOT")),
  fila(c("loc_principal_clave", "loc_principal_nombre", "loc_principal_pob", "pct_pob_loc_principal",
         "loc_principal_lon", "loc_principal_lat", "loc_principal_alt"),
       "Censo 2020, ITER (localidades)",
       c("Clave de la localidad más poblada del municipio", "Nombre de la localidad más poblada",
         "Población de la localidad más poblada", "Porcentaje de la población municipal en la localidad más poblada",
         "Longitud de la localidad más poblada", "Latitud de la localidad más poblada",
         "Altitud de la localidad más poblada"),
       c("Texto (4 dígitos)", "Texto", "Personas", "Porcentaje (0-100)",
         "Grados decimales (oeste negativo)", "Grados decimales", "Metros sobre el nivel del mar"),
       c("", "", "", "POBTOT", "", "", "")),
  fila(c("loc0001_nombre", "loc0001_lon", "loc0001_lat", "loc0001_alt"),
       "Censo 2020, ITER (localidades)",
       c("Nombre de la localidad 0001", "Longitud de la localidad 0001",
         "Latitud de la localidad 0001", "Altitud de la localidad 0001"),
       c("Texto", "Grados decimales (oeste negativo)", "Grados decimales", "Metros sobre el nivel del mar"),
       nota = "Por convención de INEGI la 0001 suele ser la cabecera municipal; 2 municipios no la tienen (vacío)")
))
stopifnot(identical(dic$variable, names(base)))
dic[, `:=`(n = .I, tipo = vapply(base, function(x) if (is.numeric(x)) "numérico" else "texto", ""),
           n_validos = vapply(base, function(x) sum(!is.na(x) & x != ""), 0L),
           n_faltantes = vapply(base, function(x) sum(is.na(x) | x == ""), 0L))]
setcolorder(dic, c("n", "variable", "fuente", "descripcion", "unidad", "tipo",
                   "denominador", "n_validos", "n_faltantes", "nota"))

# -----------------------------------------------------------------------------
# 7. Universo: qué municipios quedan y cuáles salen
# -----------------------------------------------------------------------------
universo <- base[, .(CVEGEO, nom_ent, nom_mun, fuente_coneval, fuente_ilmm, fuente_iter,
                     muestra_final, motivo_exclusion, POBTOT)]
excluidos <- universo[muestra_final == 0]
message("Universo: ", nrow(base), " municipios; muestra final: ", sum(base$muestra_final),
        "; excluidos: ", nrow(excluidos))

fuentes <- data.table(
  fuente = c("Marco Geoestadístico 2020 integrado", "ILMM 2020, primer trimestre",
             "CONEVAL 2020", "Censo de Población y Vivienda 2020, ITER"),
  archivo = c("MG_2020_Integrado/conjunto_de_datos/00mun.shp y catalogos/municipios.csv",
              "ILMM/conjunto_de_datos/conjunto_de_datos_ilmm_2020_1t.csv",
              "Base Pobreza/Pobreza_Municipal_2020_Limpia.xlsx (hoja datos)",
              "ITER_NALCSV20.csv (= conjunto_de_datos_iter_00CSV20.csv)"),
  editor = c("INEGI", "INEGI", "CONEVAL (limpieza propia)", "INEGI"),
  registros_usados = c("2,469 polígonos municipales",
                       "Municipios con ent > 0 y mun > 0; estimadores 1 a 5",
                       "2,469 filas; 2,466 con estimación",
                       "Totales municipales (LOC = 0000) y localidades (LOC distinto de 0000, 9998 y 9999)"),
  descarga = c("https://www.inegi.org.mx/contenidos/productos/prod_serv/contenidos/espanol/bvinegi/productos/geografia/marcogeo/889463807469/mg_2020_integrado.zip",
               "https://www.inegi.org.mx/programas/ilmm/",
               "Concentrado_indicadores_de_pobreza_2020.xlsx (CONEVAL)",
               "https://www.inegi.org.mx/contenidos/programas/ccpv/2020/datosabiertos/iter/iter_00_cpv2020_csv.zip")
)

# -----------------------------------------------------------------------------
# 8. Escritura
# -----------------------------------------------------------------------------
wb <- createWorkbook()
estilo_enc <- createStyle(textDecoration = "bold", fgFill = "#D9E1F2", border = "Bottom")
hoja <- function(nombre, df, anchos = "auto") {
  addWorksheet(wb, nombre)
  writeData(wb, nombre, df, headerStyle = estilo_enc, keepNA = FALSE)
  freezePane(wb, nombre, firstRow = TRUE)
  addFilter(wb, nombre, rows = 1, cols = seq_len(ncol(df)))
  setColWidths(wb, nombre, cols = seq_len(ncol(df)), widths = anchos)
}
hoja("datos", base, anchos = 14)
hoja("diccionario", dic, anchos = c(5, 26, 30, 90, 26, 10, 14, 10, 11, 50))
hoja("universo", universo, anchos = c(9, 30, 36, 14, 11, 11, 13, 60, 12))
hoja("excluidos", excluidos, anchos = c(9, 30, 36, 14, 11, 11, 13, 60, 12))
hoja("fuentes", fuentes, anchos = c(38, 70, 24, 60, 120))
saveWorkbook(wb, salida_xlsx, overwrite = TRUE)

# GeoPackage: mismas columnas + polígono en EPSG:6372 (Lambert, ITRF2008)
geo <- merge(mun_sf[, "CVEGEO"], base, by = "CVEGEO")
geo <- geo[match(base$CVEGEO, geo$CVEGEO), c(names(base), attr(geo, "sf_column"))]
if (file.exists(salida_gpkg)) invisible(file.remove(salida_gpkg))
st_write(geo, salida_gpkg, layer = "municipios", quiet = TRUE)

message("Guardado: ", salida_xlsx, " y ", salida_gpkg,
        " (", nrow(base), " municipios x ", ncol(base), " variables)")
