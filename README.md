# 2019MotifHonoursProject
Code and resources compiled together as part of the Jan 2019 honours student project on predicting the effects of 3'UTR motifs

Please make sure you have installed the R programming language, its exceptionally useful IDE Rstudio and the sanity saving version control software git.

https://www.r-project.org

https://www.rstudio.com

https://git-scm.com

## Getting Started
First off let us make sure git and Rstudio are correctly installed (and than we can talk about what they do!).

Open a terminal and use the cd command to move to a suitable folder for all future honours project work (i.e. a place regularly backed up). Familiarity with the UNIX commandline is assumed, please see http://www.ee.surrey.ac.uk/Teaching/Unix/ for a tutorial otherwise.

Towards the top right of this page is the clone or download button, click there and copy the URL.

Type the code below with the copied URL inserted and enter.

```bash
git clone <repository url>
```

Hopefully the command will run smoothly and you can cd to the new 2019MotifHonoursProject folder on your local machine.

If you have got this far git appears to be working correctly. Now lets try R and Rstudio! 

Open the babySteps.R file either via the terminal with the code below or however you choose to open Rstudio.

```bash
open -a Rstudio ./src/babySteps.R
```
Go to the code tab in Rstudio, then run region and run all. (If this works try looking into the keyboard shortcuts for running the code for future use).

We can now relatively safely say R, Rstudio and git are running nicely.

## Git and Rstudio

Let's start with Rstudio.

Rstudio is an example of an integrated development environment or IDE. You don't need it to program in R, you could in fact open notepad and type away without ever thinking about Rstudio. Unfortunately managing variables, debugging and package management would just be a massive pain. IDEs, ubiquitous to all programming languages in one form or another, contain a suite of tools which make progamming easier and believe me we already have plenty to think about.

Git, on the other hand, is a piece of version control software. It is a log of all the changes made to a set of files since the last time git was ran. Regularly updating the git log will allow you to quickly return to a working version of your code when the inevitable bug appears (and highlight what has been changed). In addition, correct implimentation of modular progamming can take advantage of git's branching ability. Once a simple husk of your code is created you can produce separate branchs of the git log, each focused on different sections or extensions of the original model. Each branch can be worked on by different people, or the same person at different times. This ensures the original or master code cannot be accidentally broken by anyone at anytime because each branch has its own copy of the master file which is changed, the master file is never changed. Git's genius lies in the merging software it contains which allows for seamless integration of different branching archs once they reach completion. Finally, pair git with github (using an online repository rather than a local one) and you get a powerful tool encouraging open source programming, collaboration, regular backups and near-limitless distribution. Only after the painful discovery of a catastrophic programming error will the importance of git dawn on you!

### Introductory Task

Following [this](https://guides.github.com/activities/hello-world/) tutorial and using [this](https://www.atlassian.com/git/tutorials/atlassian-git-cheatsheet) git code cheatsheet

1. Create a new branch for your local copy of this git repository, name it something like <yourname>GitTest
2. Create a new R file, write a short program consisting of a function that will add two arguments together with an example of it being called
3. Commit this new file to git and push it back to my online github repo
4. Now merge your newly created branch with the master and push to your own github repo!

Meanwhile, https://www.tutorialspoint.com/git/git_basic_concepts.htm will tell you more than you could ever want to know about git
