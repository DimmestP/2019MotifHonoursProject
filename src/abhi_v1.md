Initation
---------

``` r
library(tidyverse)
```

    ## -- Attaching packages ---------------------------------- tidyverse 1.2.1 --

    ## v ggplot2 3.1.0     v purrr   0.2.5
    ## v tibble  2.0.1     v dplyr   0.7.8
    ## v tidyr   0.8.2     v stringr 1.3.1
    ## v readr   1.3.1     v forcats 0.3.0

    ## -- Conflicts ------------------------------------- tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(ggplot2)
```

Task 1.1: Load Datasets
-----------------------

Loading the datasets dr\_data.csv and sr\_data.csv in objects by same names.

``` r
#Error Handling for File not found
#Syntax tryCatch( {Exprns}, error = function(any){ print("out") } )
tryCatch({
            dr_data <- read.csv("data/dr_data.csv")
            sr_data <- read.csv("data/sr_data.csv")
          },
        error = function(x) 
          {
            cat("\nCheck Working Directory. Current directory:\n",
                getwd())
          }
)
```

``` r
#new dataframe containing both data together by Gene and Strain, 
#Suffixes dr and sr for distinguishing values.
combined_data <- merge(dr_data, sr_data,
                       by = c("Gene", "X", "Strain"), 
                       suffixes = c("_dr", "_sr"))
```

Task 1.2: Calculate Mean SR and DR
----------------------------------

Calculating the mean of decay (drm) and synthesis (srm) rates for each gene across all strains containing it. Unit is: Log2fold

``` r
com_data_m <- combined_data %>%
  #Remove duplicate rows
  distinct() %>%
    #remove NAs in both log2fold column
    #filter(is.finite(Log2Fold_dr), is.finite(Log2Fold_sr)) %>%
      # Group rows so that each group is one gene
      group_by(Gene) %>%
        #calculate mean
        mutate(drm = mean(Log2Fold_dr), srm = mean(Log2Fold_sr))%>%
      ungroup()  
```

Task 1.3: Find Significant Changes
----------------------------------

Create SINGLE table of genes that have one or more mutants with significantly changed decay rate OR synthesis rate? Also, record the number of significant mutants for each gene.

``` r
#Analyze this dataset
sig_data <- com_data_m %>% 
  arrange(Gene)%>%
  #select(Gene, Significance_dr, Significance_sr)%>%
    filter(Significance_dr != "not" | Significance_sr != "not")%>%
      group_by(Gene)%>%
        #calculate and add number of sig mutants for every gene
        mutate(No_of_sig_mutants = n())%>%
          #Remove rows with no difference in significance between genes
          #distinct()%>%
      ungroup()
```

Task 1.4: Log2Fold Readings in Gene vs Mutant Table
---------------------------------------------------

Goal: To Make another table with one row per gene; with the logfold decay/synthesis rates across all mutants along the columns

``` r
#Analyze this dataset
trans_data_dr <- com_data_m %>% 
    #get rid of other columns
    select(Gene, Strain, Log2Fold_dr, drm)%>%
      #Grouping
      group_by(Gene)%>%
        
        #Transposing (Key,Value) 
        #Strains go to columns (Key); Log2Fold to row (values)
        spread(Strain, Log2Fold_dr)%>%

      ungroup()%>%
    arrange(desc(drm)) #just for better handling
```

Same for Synthesis

``` r
#Analyze this dataset
trans_data_sr <- com_data_m %>% 
    #get rid of other columns
    select(Gene, Strain, Log2Fold_sr, srm)%>%
      #Grouping
      group_by(Gene)%>%
        
        #Transposing (Key,Value) 
        #Strains go to columns (Key); Log2Fold to row (values)
        spread(Strain, Log2Fold_sr)%>%

      ungroup()%>%
    arrange(desc(srm)) #just for better handling
```

Task 1.5: Plotting
------------------

``` r
#Start with dr data with mean
top_data_dr <- trans_data_dr %>% 
    #get rid of other columns
      #arrange top 5 genes by mean dr
      arrange(desc(drm))%>%
      #Take top 5
      head(n = 5)

#Start with sr data with mean
top_data_sr <- trans_data_sr %>% 
      #arrange top 5 genes by mean sr
      arrange(desc(srm))%>%
      #Take top 5
      head(n = 5)

#Find the top5 Genes in actual data
com_data_plot <- com_data_m %>%

  filter(Gene %in% top_data_dr$Gene | Gene %in% top_data_sr$Gene)%>%
    select(Gene, Strain, Log2Fold_dr, Log2Fold_sr)

plot_data <- gather(com_data_plot, key = "Type", value = "Log2fold", -Gene, -Strain)
```

``` r
#Create the plot
(my_plot <- ggplot(plot_data, aes(x = Log2fold, y = Strain, colour = Gene, shape = Type)) +
   geom_point()
)
```

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](abhi_v1_files/figure-markdown_github/ggPlot%20Synthesis%20Rate%20vs%20Genes-1.png)

Seems to work although the number of points is too high.

ISSUES: com\_data\_plot currently filters for all Top genes in either decay or synthesis rate while we only want the top ones from each of them.

Task 2: Regex
-------------

Task 2.1: Import Data
---------------------

``` r
#Error Handling for File not found
#Syntax tryCatch( {Exprns}, error = function(any){ print("out") } )
tryCatch({
            chr7 <- read_file("data/ScerevisiaeChromVIII.txt")
            #PS File name is ChromVIII but the data is for ChromVII
          },
        error = function(x) 
          { 
            print(x)
            cat("\nCurrent directory:",
                getwd())  
          }
)
```

Task 2.2: Counting frequency of "TGTTGGAATA"
--------------------------------------------

Counting the number of occurrences of TGTTGGAATA in chr7 using stringr::str\_count

``` r
print(str_count(chr7, "TGTTGGAATA"))
```

    ## [1] 13

Task 2.3: Finding Most common bases before and after "TGTTGGAATA" motifs
------------------------------------------------------------------------

``` r
#create a df of start/stop indices for ".XXXX." motif
motif_all <- data.frame(str_locate_all(chr7, ".TGTTGGAATA."))

#Use the df for identifying bases
motif_all <- motif_all %>%
  mutate(
    #identify the base before and after
    before = str_sub(chr7, start, start), 
    after = str_sub(chr7, end, end),
    #JFF - Find the actual expanded sequence with random base 
    exp_seq = str_sub(chr7, start, end)
    )
  
#Print Most common mutants using max() and min()
max(motif_all$before)
```

    ## [1] "T"

``` r
max(motif_all$after)
```

    ## [1] "T"

Task 2.4: Finding single nt Mutants for "TGTTGGAATA
---------------------------------------------------

``` r
motif <- "TGTTGGAATA"
mutants <- c()

#A loop for creating a list of candidate mutants to look for 
for (base in 1:str_length("TGTTGGAATA")) {
  #substitute the base with current loop index with wildcard(.)
  str_sub(motif, base, base) <- "."
  #add to list
  mutants[[base]] <- motif  
  #reset the motif for next iteration
  motif <- "TGTTGGAATA"
}

#print(mutants)

#find mutants and store as a list of matrices
x <- str_locate_all(chr7, mutants)
#convert the list of matrices to a dataframe 
chr7_mutants <- data.frame(do.call(rbind, x))

# Filter out duplicates and Identify the mutant motifs   
chr7_mutant_motifs <- chr7_mutants %>%
    mutate(motif = str_sub(chr7, start, end))%>%
      #only keep sequence motifs
      select(motif)%>%
        #remove duplicate motifs
        unique()%>%
          #filter out original motif 
          filter(motif != "TGTTGGAATA")
        
      
print(chr7_mutant_motifs)
```

    ##         motif
    ## 1  CGTTGGAATA
    ## 2  AGTTGGAATA
    ## 3  TCTTGGAATA
    ## 4  TTTTGGAATA
    ## 5  TATTGGAATA
    ## 6  TGCTGGAATA
    ## 7  TGGTGGAATA
    ## 8  TGATGGAATA
    ## 9  TGTAGGAATA
    ## 10 TGTGGGAATA
    ## 11 TGTCGGAATA
    ## 12 TGTTAGAATA
    ## 13 TGTTTGAATA
    ## 14 TGTTCGAATA
    ## 15 TGTTGAAATA
    ## 16 TGTTGCAATA
    ## 17 TGTTGTAATA
    ## 18 TGTTGGTATA
    ## 19 TGTTGGAGTA
    ## 20 TGTTGGATTA
    ## 21 TGTTGGACTA
    ## 22 TGTTGGAAGA
    ## 23 TGTTGGAAAA
    ## 24 TGTTGGAATG
    ## 25 TGTTGGAATC
    ## 26 TGTTGGAATT
