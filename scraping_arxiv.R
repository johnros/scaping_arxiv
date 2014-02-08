library(OAIHarvester)

baseurl<- 'http://export.arxiv.org/oai2'
x<- oaih_identify(baseurl)
ls.str(x)

# Name the differet ArXiV archives
sets <- oaih_list_sets(baseurl)
length(sets)
sets


#### Scraping Statistics set ####
# spec <- unlist(sets[sets[, "setName"]  == "Statistics", "setSpec"])
# # Careful: long run.
# stats <- oaih_list_records(baseurl, set = spec)
# m <- stats[, "metadata"]
# m <- oaih_transform(m[sapply(m, length) > 0L])
# save(stats,m, file='stats.RData')

load(file='stats.RData')
colnames(stats)
colnames(m)

n.authors<- sapply(m[,'creator'], length)
n.submission<- length(unlist(m[,'date']))
n.papers<- nrow(stats)
m.flat<- matrix(NA, nrow=n.submission, ncol=2, dimnames=list(NULL,c("id","date")))
counter<- 1
for(i in 1:n.papers ){
  dates<- unlist(m[i,'date'])
  for(.date in dates){
    m.flat[counter,"id"]<- unlist(stats[i,'identifier'] )
    m.flat[counter,"date"]<- .date
    counter<- counter+1    
  }
}

m.flat.framed<- as.data.frame(m.flat)


#### Visualyze submission date ####


m.flat.framed$date2<- as.Date(m.flat.framed$date, format="%Y-%m-%d")
m.flat.framed$week<-as.Date(cut(m.flat.framed$date2 ,
                                breaks = "week",
                                start.on.monday = TRUE))
m.flat.framed$month<-as.Date(cut(m.flat.framed$date2 ,
                                 breaks = "month"))

library(dplyr)
m.flat.aggregate<- m.flat.framed %.% 
  group_by(month) %.%
  summarise(total = length(id)) 
plot(m.flat.aggregate, type='h')


