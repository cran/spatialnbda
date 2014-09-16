\name{rjmcmc}
\alias{rjmcmc}

\title{
Model discriminiation in a Bayesian context for spatial NBDA.
}
\description{
An RJMCMC algorithm is used to achieve model discrimination between the null model
which contains only the baseline rate parameter and the full model which contains
both the baseline rate and social parameters.
}

\usage{
rjmcmc(formatteddata, its, pilot_tuner1, pilot_tuner2, start1, start2, start3, p1, p2)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{formatteddata}{
Formatted data using the FormatData function.
}
  \item{its}{
Number of iterations
}
  \item{pilot_tuner1}{
Tuner for proposal distribution for the social parameter.
}
  \item{pilot_tuner2}{
Tuner for the proposal distribution for the baseline rate parameter.
}
  \item{start1}{
Start value for the social parameter
}
  \item{start2}{
Start value for the baseline rate parameter
}
  \item{start3}{
Start model
}
  \item{p1}{
Unifor prior variance tuner for the baseline rate
}
  \item{p2}{
Uniform prior variance tuner for the social parameter
}
}
\details{
It is important to check that the chains have mixed which using this function.
A rough way would be to view the trace plots printed.
}
\value{
The output is a table with the number of iterations for which the Markov
chain spent in each visited model.
}
\examples{

#Example 1
data(timearray)
data(idarray)
data(socialx)
data(socialy)

Times = timearray[,1]
Ids = idarray[,1]
lenh = length(Times)
Groups = rep(1,length(Times))
Events = c(1:length(Times))

socialites = matrix(1,nrow=lenh,ncol=lenh)
x = socialx
y = socialy

plot(x[,1],y[,1],xlab="x",ylab="y",cex=2,pch=16,main="Point pattern of nest positions")

areas = calculate.areas(x[,1],y[,1],rep(0.2,lenh),1000)
spatialareas = areas
len = length(x[,1])
Diffusions = rep(1,len)
for(i in 2:10){
  addon = rep(i,len)
  Diffusions = c(Diffusions,addon)
  
}


spatialnetwork = matrix(0,nrow=len,ncol=len)
for(i in 1:len){
  for(j in i:len){ 
    template = spatialareas[[i]][j]
    spatialnetwork[i,j] = spatialnetwork[j,i] = template
    #spatialareas[[i]]=NULL
    
  }
  
}


shape = FormatData(Times,spatialnetwork,Ids,Groups,Diffusions,Events,spatialnetwork)



#ptm <- proc.time()
#mcmc(shape,10000,0.05,0.05,-3,-5)
#proc.time() - ptm

#ptm <- proc.time()
#rjmcmc(shape,10000,5,1,-3,-3,1,10,10)
#proc.time() - ptm


# Example 2
data(papertimes)
data(papernests)
data(x)
data(y)
z = array(0,c(length(x[,1]),1))# setting up array for storing spatial covariate information

for(i in 1:70){   # simulating spatial covariate information
xx = x[,1][i]
yy = y[,1][i]
z[i] = (3*xx + 14*yy) * exp(2 * (.4*xx - 1)) 
}



Times = papertimes[,1]
Ids = papernests[,1]
Diffusions = rep(1,length(Times))
Groups = rep(1,length(Times))
Events = c(1:length(Times))
socialites = matrix(1,nrow=70,ncol=70)


plot(x[,1],y[,1],xlab="x",ylab="y",cex=2,pch=16,main="Point pattern of nest positions")



areas = calculate.areas(x[,1],y[,1],rep(0.05,70),1000)
spatialareas = areas
len = length(x[,1])

spatialnetwork = matrix(0,nrow=len,ncol=len)
for(i in 1:len){
  for(j in i:len){ 
    template = spatialareas[[i]][j]
    spatialnetwork[i,j] = spatialnetwork[j,i] = template
    #spatialareas[[i]]=NULL
    
  }
  
}


shape = FormatData(Times,spatialnetwork,Ids,Groups,Diffusions,Events,spatialnetwork,z)


#ptm <- proc.time()
#mcmc(shape,10000,5,1,-5,-6)
#proc.time() - ptm

#ptm <- proc.time()
#nullmcmc(shape,10000,1,-5)
#proc.time() - ptm


#ptm <- proc.time()
#rjmcmc(shape,10000,5,1,0,0,2,5,5)
#proc.time() - ptm



}