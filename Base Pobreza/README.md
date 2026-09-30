# Base Pobreza

Indicadores de pobreza municipal del CONEVAL, **solo año 2020**, limpios y listos para análisis.
La base tiene 2,469 municipios × 51 variables.

| Archivo | Qué es |
|---|---|
| `Pobreza_Municipal_2020_Limpia.xlsx` | **La base.** La hoja `datos` es la matriz de datos (una fila por municipio). También trae las hojas `diccionario`, `glosario`, `estatal_2020` (las 32 entidades) y `notas_coneval`. |
| `Diccionario_Variables.md` | Diccionario de las 51 variables y glosario de conceptos (pobreza, carencias, líneas de pobreza). |
| `Reporte_Base_Pobreza_2020.md` | Reporte del contenido: limpieza, cobertura, faltantes, validaciones, estadística descriptiva nacional y de Veracruz, correlaciones y consideraciones para el análisis. |
| `script/limpiar_pobreza_2020.R` | Script en R que genera la base limpia a partir del archivo original. |
| `original/Concentrado_indicadores_de_pobreza_2020.xlsx` | Archivo original del CONEVAL (2010, 2015 y 2020, municipal y estatal), sin modificar. |

## Leer la base en R

```r
library(readxl)
pobreza <- read_excel("Base Pobreza/Pobreza_Municipal_2020_Limpia.xlsx", sheet = "datos")
pobreza_ver <- subset(pobreza, cve_ent == "30")   # Veracruz: 212 municipios
```

## Volver a generar la base

Abre la raíz del repositorio `Tesis` (en VSCode o RStudio) y corre:

```r
install.packages(c("readxl", "openxlsx"))   # solo la primera vez
source("Base Pobreza/script/limpiar_pobreza_2020.R", encoding = "UTF-8")
```
