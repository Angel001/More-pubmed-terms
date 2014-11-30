library(rentrez)
library(dplyr)
library(wordcloud)
library(RColorBrewer)

data <- data.frame(Year = integer(), N = integer(), Type = character())
field <- "[title/abstract]"
query <- c("Lasik", "Epi-Lasik", "PRK", "Lasek", "Intralase", "ReLEx",
           "Intracor", "Wavefront guided", "Phakic intraocular lens",
           "Multifocal IOL", "Toric IOL", "Refractive surgery", "Microkeratome",
           "Myopia", "Astigmatism", "Hyperopia", "Presbyopia", 
           "Femtosecond laser cataract", "Intacs" )

for (i in query) {
        for (j in 2011:2014) {
                x1 <- entrez_search(db = "pubmed", term = paste0(i, field),
                                    rettype = "count", datetype="pdat",
                                    mindate = as.character(j),
                                    maxdate = as.character(j)
                )       
                data <- rbind(data, data.frame(Year = j, N = x1$count, Type = i))     
                Sys.sleep(0.4)
        }
}

y14 <- filter(data, Year == 2014)

wordcloud(y14$Type, freq = y14$N, colors = colors()[c(589:593)],
          scale = c(4,1), rot.per = 0.3, random.order = F)

docmatrix <- matrix(data = data$N, ncol = 4, byrow = T,
                    dimnames = list(levels(data$Type), c(2011:2014)))
docmatrix <- docmatrix[,c(2,1,3,4)]

comparison.cloud(docmatrix, rot.per = 0.2, title.size = 1, random.order = F)
