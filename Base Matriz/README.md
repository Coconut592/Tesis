# Base Matriz

Base municipal 2020 que une cuatro fuentes por **CVEGEO** (5 dígitos en texto: entidad de 2 +
municipio de 3):

- Marco Geoestadístico 2020 del INEGI;
- ILMM 2020, primer trimestre, del INEGI;
- CONEVAL 2020;
- ITER del Censo de Población y Vivienda 2020, del INEGI.

Tiene los **2,469 municipios** del Marco y **186 variables**. **2,457** municipios tienen las tres
fuentes estadísticas; los 12 restantes siguen en la base, marcados con `muestra_final = 0`.

| Archivo | Qué es |
|---|---|
| `Base_Matriz_Municipal_2020.xlsx` | La base sin geometría. Hojas: `datos` (2,469 × 186), `diccionario`, `universo` (fuentes de cada municipio), `excluidos` (los 12 que quedan fuera y por qué) y `fuentes`. |
| `Base_Matriz_Municipal_2020.gpkg` | Los mismos datos más el polígono municipal (capa `municipios`, EPSG:6372). Sirve para la matriz W y para extraer luces nocturnas (NTL). Pesa unos 62 MB. |
| `Diccionario_Base_Matriz.md` | Las 186 variables: fuente, descripción, unidad y denominador. |
| `Reporte_Base_Matriz.md` | Qué municipios se quedan y cuáles salen, decisiones de construcción, correcciones a la lista original, validaciones, calidad de los datos y descriptivos. |
| `script/construir_base_matriz.R` | Script que genera los dos archivos a partir de las descargas originales. |
| `script/variables_iter.csv` | Las 67 variables del ITER que se usan, con su nombre oficial y el denominador de cada porcentaje. |

## Leer la base en R

```r
library(readxl)
base <- read_excel("Base Matriz/Base_Matriz_Municipal_2020.xlsx", sheet = "datos")
muestra <- subset(base, muestra_final == 1)          # 2,457 municipios

library(sf)
mapa <- st_read("Base Matriz/Base_Matriz_Municipal_2020.gpkg", layer = "municipios")
```

## Volver a generar la base

Las fuentes originales **no están en el repositorio**: el ITER pesa 150 MB y GitHub no acepta
archivos de más de 100 MB. El script las lee de tu carpeta `Bases de datos`, con esta estructura:

```
Bases de datos/
├── ITER_NALCSV20.csv
├── MG_2020_Integrado/
│   ├── catalogos/municipios.csv
│   └── conjunto_de_datos/00mun.shp (y .dbf, .shx, .prj, .cpg)
└── ILMM/conjunto_de_datos/conjunto_de_datos_ilmm_2020_1t.csv
```

La base de CONEVAL se toma de `Base Pobreza/` en este mismo repositorio. Para generar la base,
abre la raíz del repositorio `Tesis` y corre:

```r
install.packages(c("sf", "data.table", "readxl", "openxlsx"))   # solo la primera vez
source("Base Matriz/script/construir_base_matriz.R", encoding = "UTF-8")
```

Si tu carpeta de bases cambia de lugar, define antes la variable de entorno `TESIS_BASES`, por
ejemplo `Sys.setenv(TESIS_BASES = "D:/TESIS/Bases de datos")`.
