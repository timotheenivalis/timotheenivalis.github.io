FMakeNewTree <- function(id, birthyear)
{
  list(id=id, birthyear=birthyear)
}

FinitializeTrees <-function(number=4, age=301)
{
  treepop <- list()
  for (i in 1:number)
  {
    treepop[[i]] <- list(id=i, birthyear=-age)
  }
  return(treepop)
}

FMakeNewRed <- function(id, birthyear)
{
  #  stopifnot(is.numeric(birthyear))
  list(id=id, birthyear=birthyear)
}

FinitializeReds <- function(number=20)
{
  redpop <- list()
  for (i in 1:number)
  {
    redpop[[i]] <- list(id=i, birthyear=-sample(x=31:50, size = 1))
  }
  return(redpop)
}

mainfunction <- function(yearnb=150, extrinsicmortality=0.001)
{
  monitor <- data.frame(year=1:yearnb, reds=rep(0, times=yearnb), trees=rep(0, times=yearnb),
                        adulttree=rep(0, times=yearnb), reprotree=rep(0, times=yearnb))
  
  reprotable <- data.frame(tree=1L, red=1:2L, fertilyear =-1L, lastrepro=-1L)
  
  treepop <- FinitializeTrees(number=1)
  redpop <- FinitializeReds(number = 2)
  globalredcounter <- length(redpop)
  
  
  
  y <-0L
  while(globalredcounter<10000L & y<yearnb & length(treepop)<10000L)
  {
    y <- y +1L
    currenttrees <- unlist(lapply(treepop, function(x) x$id))
    currentreds <- unlist(lapply(redpop, FUN = function(x){x$id}))
    if(length(redpop)>0)
    {
      #Trees being fertilized
      tomate <- unlist(lapply(redpop, FUN = function(x){x$id[(y-x$birthyear)>=30]}))
      
      if(length(tomate)>0)
      {
        pottreesall <- reprotable[(reprotable$tree %in% currenttrees) &
                                    reprotable$lastrepro==-1L,]
        if(nrow(pottreesall)>0)
        {
          for (ind in tomate)
          {
            pottrees <- pottreesall$tree[pottreesall$red==ind]
            
            if(length(pottrees)>0)
            {
              if(length(pottrees)>1)
              {
                tree <- sample(pottrees, size = 1, replace = FALSE)
              }else{tree<-pottrees}
              reprotable[reprotable$tree==tree & reprotable$red==ind,
                         c("fertilyear", "lastrepro")] <- c(y, 0)
            }
          }
        }#end     if(length(tomate)>0)
      }
      
      #Death of reds and creations of new trees
      deathlists <- NULL
      extdeath <- rbinom(n = length(redpop), size = 1, extrinsicmortality)==1
      
      for (ind in 1:length(redpop))
      {
        if((y-redpop[[ind]]$birthyear > 100) | extdeath[ind])
        {
          deathlists <- c(deathlists, ind)
          newid<-length(treepop)+1
          treepop[[newid]] <- FMakeNewTree(id = newid, birthyear = y)
          
        }
      }
      
      if(length(deathlists)>0)
      {
        reprotable <-reprotable[!( (reprotable$red %in% currentreds[deathlists]) &
                                     reprotable$fertilyear==-1),]
        reprotable <- rbind(reprotable,
                            expand.grid(tree=(length(treepop)-length(deathlists)):length(treepop), 
                                        red=currentreds,
                                        fertilyear =-1L, lastrepro=-1L))
        redpop <- redpop[-deathlists]
      }
    }
    
    #Reds being born
    currentreptrees <- unlist(lapply(treepop, function(x) x$id[(y-x$birthyear)>300]))
    currenttrees <- unlist(lapply(treepop, function(x) x$id))
    
    if(length(currentreptrees)>(length(redpop)/10))
    {
      reprotrees <- reprotable[(reprotable$tree %in% currentreptrees) & 
                                 (reprotable$lastrepro!=-1) &
                                 ((reprotable$lastrepro == 0) | ((y - reprotable$lastrepro) > 100)) &
                                 (y - reprotable$fertilyear)>4,]
      if(nrow(reprotrees)>1)
      {
        treeid <- unique(reprotrees$tree)
        firstnewred <- globalredcounter+1
        for (ind in 1:length(treeid))
        {
          potreds <- reprotrees$red[reprotrees$tree == treeid[ind]]
          if(length(potreds)>1)
          {
            gametes <- sample(potreds, size = 2, replace = FALSE)
            reprotable$lastrepro[(reprotable$tree==treeid[ind]) & 
                                   reprotable$red %in% gametes] <- y
            globalredcounter <- globalredcounter+1
            redpop[[length(redpop)+1]] <- FMakeNewRed(id=globalredcounter, birthyear = "y")
          }
        }
        reprotable <- rbind(reprotable,
                            expand.grid(tree=currenttrees, 
                                        red=firstnewred:max(c(firstnewred+40),globalredcounter),
                                        fertilyear =-1L, lastrepro=-1L))
      }
    }# end  if(length(currentreptrees)>( length(redpop)/10))
    
    
    monitor[y,] <- c(y, length(redpop), length(treepop),
                     sum(unlist(lapply(treepop,function(x) {(y-x$birthyear)>300}))),
                     length(unique(reprotrees$tree)))
    print(paste("year=",y, " reds=", length(redpop), " trees=", length(treepop)))
    
  }#end while
  return(monitor)
}