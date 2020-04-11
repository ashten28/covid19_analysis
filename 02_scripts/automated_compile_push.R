# get working directory to covid19_analysis folder
wd <- paste0(Sys.getenv('R_USER'), "/Ashten/rprojects/covid19_analysis")

# set wd
setwd(wd)

# run data compile script
# system(paste0('Rscript "', wd, '/02_scripts/covid19_data_compile.R"'))

# git commit  and push to github
# system("git add .")
# system('git commit -m "automated update"')
# 
# base::Sys.getenv()

# task scheduler. 
library(taskscheduleR)
myscript <- system.file("extdata", "helloworld.R", package = "taskscheduleR")

## run script once within 62 seconds
taskscheduler_create(taskname = "update covid19 data", rscript = myscript,
                     schedule = "ONCE", starttime = format(Sys.time() + 62, "%H:%M"))