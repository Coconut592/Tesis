# =============================================================================
# Base Pobreza · Pobreza municipal 2020 (CONEVAL) → base limpia
#
# Entrada: Base Pobreza/original/Concentrado_indicadores_de_pobreza_2020.xlsx
#          (Medición de la pobreza, Estados Unidos Mexicanos, 2010-2020)
# Salida:  Base Pobreza/Pobreza_Municipal_2020_Limpia.xlsx
#
# Toma TODAS las variables del concentrado municipal, pero solo del año 2020:
# claves, nombres, población y los 16 indicadores con todas sus medidas
# (porcentaje, personas y carencias promedio). Una fila por municipio.
#
# Correr desde la raíz del repositorio Tesis:
#   source("Base Pobreza/script/limpiar_pobreza_2020.R")
# Paquetes: readxl, openxlsx
# =============================================================================

library(readxl)
library(openxlsx)

carpeta  <- "Base Pobreza"
original <- file.path(carpeta, "original", "Concentrado_indicadores_de_pobreza_2020.xlsx")
salida   <- file.path(carpeta, "Pobreza_Municipal_2020_Limpia.xlsx")

# -----------------------------------------------------------------------------
# 1. Catálogo de indicadores, en el orden en que aparecen en el original
# -----------------------------------------------------------------------------
indicadores <- data.frame(
  prefijo = c("pobreza", "pobreza_ext", "pobreza_mod", "vul_car", "vul_ing",
              "no_pobre_no_vul", "rezago_edu", "car_salud", "car_segsoc",
              "car_vivienda", "car_servbas", "car_alim", "car_1omas",
              "car_3omas", "ing_inf_lp", "ing_inf_lpe"),
  grupo = c(rep("Pobreza", 3), rep("Vulnerabilidad y no pobreza", 3),
            rep("Carencias sociales", 6), rep("Privación social", 2),
            rep("Bienestar económico (ingreso)", 2)),
  # Frase que completa "Porcentaje de la población ...", "Personas ...", etc.
  frase = c("en situación de pobreza",
            "en situación de pobreza extrema",
            "en situación de pobreza moderada",
            "vulnerable por carencias sociales",
            "vulnerable por ingresos",
            "no pobre y no vulnerable",
            "con rezago educativo",
            "con carencia por acceso a los servicios de salud",
            "con carencia por acceso a la seguridad social",
            "con carencia por calidad y espacios de la vivienda",
            "con carencia por acceso a los servicios básicos en la vivienda",
            "con carencia por acceso a la alimentación",
            "con al menos una carencia social",
            "con tres o más carencias sociales",
            "con ingreso inferior a la línea de pobreza por ingresos",
            "con ingreso inferior a la línea de pobreza extrema por ingresos"),
  # "Vulnerables por ingreso" y "No pobre y no vulnerable" no traen carencias promedio
  tiene_carpro = c(rep(TRUE, 4), FALSE, FALSE, rep(TRUE, 10)),
  stringsAsFactors = FALSE
)

medidas <- data.frame(
  medida = c("pct", "pers", "carpro"),
  etiqueta = c("Porcentaje", "Personas", "Carencias promedio"),
  unidad = c("Porcentaje (0-100)", "Número de personas", "Número de carencias (0-6)"),
  stringsAsFactors = FALSE
)

# -----------------------------------------------------------------------------
# 2. Nombres de las 145 columnas del original (B:EP), con año
# -----------------------------------------------------------------------------
anios <- c(2010, 2015, 2020)
nombres_bloque <- function(prefijo, tiene_carpro) {
  m <- if (tiene_carpro) medidas$medida else medidas$medida[1:2]
  as.vector(t(outer(paste(prefijo, m, sep = "_"), anios, paste, sep = "_")))
}
nombres_orig <- c("cve_ent", "entidad", "cve_mun", "municipio",
                  paste0("poblacion_", anios),
                  unlist(Map(nombres_bloque, indicadores$prefijo, indicadores$tiene_carpro),
                         use.names = FALSE))
stopifnot(length(nombres_orig) == 145)

# Encabezados originales (filas 5 y 6, fila 5 con celdas combinadas) para trazabilidad
enc <- read_excel(original, sheet = "Concentrado municipal", range = "B5:EP6",
                  col_names = FALSE, col_types = "text", .name_repair = "minimal")
una_linea <- function(x) trimws(gsub("\\s*[\r\n]+\\s*", " ", x))
enc5 <- una_linea(unlist(enc[1, ]))
for (i in seq_along(enc5)) if (is.na(enc5[i])) enc5[i] <- enc5[i - 1]
enc6 <- una_linea(unlist(enc[2, ]))
encabezado_original <- ifelse(is.na(enc6), enc5, paste(enc5, enc6, sep = " | "))
columna_original <- int2col(2:146)

# Verificación: cada nombre corresponde a su encabezado (año y medida)
anio_nombre <- sub(".*_(\\d{4})$", "\\1", nombres_orig)
anio_enc    <- sub(".*(\\d{4}).*", "\\1", encabezado_original)
stopifnot(all(anio_nombre[5:145] == anio_enc[5:145]))
medida_nombre <- sub(".*_(pct|pers|carpro)_\\d{4}$", "\\1", nombres_orig[8:145])
medida_enc <- medidas$medida[match(sub(" \\d{4}$", "", enc6[8:145]), medidas$etiqueta)]
stopifnot(identical(medida_nombre, medida_enc))

# -----------------------------------------------------------------------------
# 3. Lectura del concentrado municipal (filas 9 a 2477)
#    n.d. = sin estimación ese año; n.a. = grupo sin población (no hay promedio)
# -----------------------------------------------------------------------------
municipal <- read_excel(original, sheet = "Concentrado municipal", range = "B9:EP2477",
                        col_names = nombres_orig,
                        col_types = c(rep("text", 4), rep("numeric", 141)),
                        na = c("n.d.", "n.a."))
# Misma lectura como texto, solo para distinguir n.d. de n.a.
municipal_txt <- read_excel(original, sheet = "Concentrado municipal", range = "B9:EP2477",
                            col_names = nombres_orig, col_types = "text")

# -----------------------------------------------------------------------------
# 4. Selección de 2020 y nombres finales (sin sufijo de año)
# -----------------------------------------------------------------------------
sel <- c(1:4, grep("_2020$", nombres_orig))
stopifnot(length(sel) == 51)
nombres_2020 <- sub("_2020$", "", nombres_orig[sel])

datos <- as.data.frame(municipal[, sel])
names(datos) <- nombres_2020
datos_txt <- as.data.frame(municipal_txt[, sel])

stopifnot(nrow(datos) == 2469, !anyDuplicated(datos$cve_mun),
          all(nchar(datos$cve_mun) == 5), all(substr(datos$cve_mun, 1, 2) == datos$cve_ent))

# -----------------------------------------------------------------------------
# 5. Diccionario de variables
# -----------------------------------------------------------------------------
ind  <- indicadores[match(sub("_(pct|pers|carpro)$", "", nombres_2020), indicadores$prefijo), ]
med  <- sub(".*_(pct|pers|carpro)$", "\\1", nombres_2020)
desc <- ifelse(med == "pct", paste("Porcentaje de la población", ind$frase),
        ifelse(med == "pers", paste("Personas", ind$frase),
               paste("Número promedio de carencias sociales de la población", ind$frase)))

id <- data.frame(
  variable = c("cve_ent", "entidad", "cve_mun", "municipio", "poblacion"),
  descripcion = c("Clave de la entidad federativa (INEGI, 2 dígitos, texto)",
                  "Nombre de la entidad federativa",
                  "Clave del municipio (INEGI, 5 dígitos = entidad + municipio, texto)",
                  "Nombre del municipio",
                  "Población total del municipio en 2020 estimada por el CONEVAL para la medición de pobreza"),
  grupo = c(rep("Identificación", 4), "Población"),
  unidad = c(rep("Texto", 4), "Número de personas"),
  stringsAsFactors = FALSE
)

es_id <- nombres_2020 %in% id$variable
diccionario <- data.frame(
  n = seq_along(nombres_2020),
  variable = nombres_2020,
  descripcion = ifelse(es_id, id$descripcion[match(nombres_2020, id$variable)], desc),
  grupo = ifelse(es_id, id$grupo[match(nombres_2020, id$variable)], ind$grupo),
  medida = ifelse(es_id, NA, medidas$etiqueta[match(med, medidas$medida)]),
  unidad = ifelse(es_id, id$unidad[match(nombres_2020, id$variable)],
                  medidas$unidad[match(med, medidas$medida)]),
  tipo = ifelse(sapply(datos, is.numeric), "numérico", "texto"),
  n_validos = colSums(!is.na(datos)),
  n_faltantes_nd = colSums(datos_txt == "n.d.", na.rm = TRUE),
  n_faltantes_na = colSums(datos_txt == "n.a.", na.rm = TRUE),
  minimo = sapply(datos, function(x) if (is.numeric(x)) min(x, na.rm = TRUE) else NA),
  media = sapply(datos, function(x) if (is.numeric(x)) mean(x, na.rm = TRUE) else NA),
  maximo = sapply(datos, function(x) if (is.numeric(x)) max(x, na.rm = TRUE) else NA),
  columna_original = columna_original[sel],
  encabezado_original = encabezado_original[sel],
  row.names = NULL, stringsAsFactors = FALSE
)
stopifnot(all(diccionario$n_validos + diccionario$n_faltantes_nd + diccionario$n_faltantes_na == 2469))

# -----------------------------------------------------------------------------
# 6. Glosario de conceptos (resumen de la metodología del CONEVAL)
# -----------------------------------------------------------------------------
glosario <- data.frame(
  concepto = c(
    "Pobreza", "Pobreza extrema", "Pobreza moderada",
    "Vulnerable por carencias sociales", "Vulnerable por ingresos", "No pobre y no vulnerable",
    "Carencias sociales", "Rezago educativo", "Carencia por acceso a los servicios de salud",
    "Carencia por acceso a la seguridad social", "Carencia por calidad y espacios de la vivienda",
    "Carencia por acceso a los servicios básicos en la vivienda",
    "Carencia por acceso a la alimentación",
    "Al menos una carencia social", "Tres o más carencias sociales",
    "Línea de pobreza por ingresos (LPI)", "Línea de pobreza extrema por ingresos (LPEI)",
    "Porcentaje (_pct)", "Personas (_pers)", "Carencias promedio (_carpro)",
    "Población (poblacion)", "Valor faltante n.d.", "Valor faltante n.a."),
  definicion = c(
    "Población con al menos una carencia social y con un ingreso inferior a la línea de pobreza por ingresos, es decir, insuficiente para adquirir los bienes y servicios alimentarios y no alimentarios que requiere.",
    "Población con tres o más carencias sociales (de seis) y con un ingreso inferior a la línea de pobreza extrema por ingresos: aun si dedicara todo su ingreso a alimentos, no podría adquirir los nutrientes necesarios para una vida sana.",
    "Población en situación de pobreza que no está en pobreza extrema (pobreza = pobreza extrema + pobreza moderada).",
    "Población con al menos una carencia social, pero con un ingreso igual o superior a la línea de pobreza por ingresos.",
    "Población sin carencias sociales, pero con un ingreso inferior a la línea de pobreza por ingresos.",
    "Población sin carencias sociales y con un ingreso igual o superior a la línea de pobreza por ingresos. Pobreza + vulnerables por carencias + vulnerables por ingresos + no pobre y no vulnerable = 100%.",
    "Los seis indicadores de derechos sociales de la medición: rezago educativo, acceso a los servicios de salud, acceso a la seguridad social, calidad y espacios de la vivienda, servicios básicos en la vivienda y acceso a la alimentación.",
    "La persona no cuenta con el nivel de educación obligatoria que corresponde a su edad y año de nacimiento (primaria, secundaria o media superior, según su cohorte) y, si está en edad escolar, no asiste a un centro de educación formal.",
    "La persona no está afiliada ni tiene derecho a recibir servicios médicos de alguna institución pública de salud (IMSS, ISSSTE, Pemex, Defensa, Marina, Seguro Popular/INSABI, IMSS-Bienestar, etc.) o privada.",
    "La persona no tiene acceso a la seguridad social por su trabajo, por contratación voluntaria, por parentesco con alguien que la tenga, ni por ser pensionada; en el caso de adultos mayores, tampoco recibe un programa de pensiones para adultos mayores.",
    "La persona habita una vivienda con piso de tierra; techo de lámina de cartón o desechos; muros de embarro, bajareque, carrizo, bambú, palma, lámina de cartón, metálica o asbesto, o material de desecho; o con hacinamiento (más de 2.5 personas por cuarto).",
    "La persona habita una vivienda sin agua entubada dentro de la vivienda o del terreno; sin drenaje o con desagüe a río, lago, mar, barranca o grieta; sin energía eléctrica; o donde se cocina con leña o carbón sin chimenea.",
    "El hogar de la persona presenta inseguridad alimentaria moderada o severa según la Escala Mexicana de Seguridad Alimentaria (en la metodología 2018: acceso a la alimentación nutritiva y de calidad).",
    "Población que presenta una o más de las seis carencias sociales.",
    "Población que presenta tres o más de las seis carencias sociales.",
    "Valor monetario de la canasta alimentaria más la no alimentaria por persona al mes (antes llamada línea de bienestar).",
    "Valor monetario de la canasta alimentaria por persona al mes (antes llamada línea de bienestar mínimo).",
    "Porcentaje de la población total del municipio que está en la condición indicada, en escala de 0 a 100.",
    "Número estimado de personas del municipio que están en la condición indicada.",
    "Número promedio de carencias sociales (de 0 a 6) que tiene la población que está en la condición indicada. No existe para vulnerables por ingresos ni para no pobres y no vulnerables, porque por definición no tienen carencias.",
    "Población calibrada por el CONEVAL para que la suma municipal coincida con la población estatal del Modelo Estadístico 2020 (MEC del MCS-ENIGH); puede diferir de las cifras de INEGI o CONAPO.",
    "No disponible: el municipio no tiene estimación ese año (municipios de nueva creación o muestra censal insuficiente). En la base limpia es una celda vacía (NA).",
    "No aplica: el grupo no tiene población en el municipio (0 personas), por lo que no se puede calcular su promedio de carencias. En la base limpia es una celda vacía (NA)."),
  stringsAsFactors = FALSE
)

# -----------------------------------------------------------------------------
# 7. Concentrado estatal 2020 (misma estructura, sin columnas de municipio)
# -----------------------------------------------------------------------------
nombres_est <- nombres_orig[-(3:4)]
estatal <- read_excel(original, sheet = "Concentrado estatal", range = "B9:EN40",
                      col_names = nombres_est,
                      col_types = c(rep("text", 2), rep("numeric", 141)),
                      na = c("n.d.", "n.a."))
sel_est <- c(1:2, grep("_2020$", nombres_est))
estatal <- as.data.frame(estatal[, sel_est])
names(estatal) <- sub("_2020$", "", names(estatal))
stopifnot(nrow(estatal) == 32, identical(names(estatal), nombres_2020[-(3:4)]))

# La población municipal suma la estatal en todas las entidades
pob_mun <- tapply(datos$poblacion, datos$cve_ent, sum, na.rm = TRUE)
stopifnot(all(abs(pob_mun[estatal$cve_ent] - estatal$poblacion) < 1))

# -----------------------------------------------------------------------------
# 8. Fuente y notas originales del CONEVAL
# -----------------------------------------------------------------------------
titulo <- read_excel(original, sheet = "Concentrado municipal", range = "B2:B3",
                     col_names = FALSE, .name_repair = "minimal")[[1]]
notas <- read_excel(original, sheet = "Concentrado municipal", range = "B2480:B2493",
                    col_names = FALSE, .name_repair = "minimal")[[1]]
notas_coneval <- data.frame(
  texto = c(titulo, trimws(notas),
            "Base limpia: solo año 2020; n.d. y n.a. convertidos a celdas vacías (NA). Ver Reporte_Base_Pobreza_2020.md."),
  stringsAsFactors = FALSE
)

# -----------------------------------------------------------------------------
# 9. Escritura del Excel
#    La hoja "datos" va primero: read_excel(salida) la lee directamente.
# -----------------------------------------------------------------------------
wb <- createWorkbook()
estilo_enc <- createStyle(textDecoration = "bold", fgFill = "#D9E1F2",
                          border = "Bottom", wrapText = FALSE)

agregar_hoja <- function(nombre, df, anchos = "auto") {
  addWorksheet(wb, nombre)
  writeData(wb, nombre, df, headerStyle = estilo_enc, keepNA = FALSE)
  freezePane(wb, nombre, firstRow = TRUE)
  addFilter(wb, nombre, rows = 1, cols = seq_len(ncol(df)))
  setColWidths(wb, nombre, cols = seq_len(ncol(df)), widths = anchos)
}

agregar_hoja("datos", datos)
agregar_hoja("diccionario", diccionario,
             anchos = c(5, 22, 70, 28, 18, 24, 10, 10, 15, 15, 14, 14, 14, 17, 80))
agregar_hoja("glosario", glosario, anchos = c(45, 140))
agregar_hoja("estatal_2020", estatal)
addWorksheet(wb, "notas_coneval")
writeData(wb, "notas_coneval", notas_coneval, headerStyle = estilo_enc)
setColWidths(wb, "notas_coneval", cols = 1, widths = 200)

saveWorkbook(wb, salida, overwrite = TRUE)
message("Base guardada en: ", salida, " (", nrow(datos), " municipios x ",
        ncol(datos), " variables)")
