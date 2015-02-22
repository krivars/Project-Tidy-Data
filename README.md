# Project-Tidy-Data
>This repository contains the Course Project for Getting and Cleaning Data.

>The repository includes this README.md file, a codebook and the script run_analysis. This README describes the script creating a dataset of average values from the input Samsung data. The codebook gives the variables in the resulting dataset.

>The script run_analysis.R merges test and training data and subsets out the columns regarding mean() and std(). Column names are renamed to not include any characters (,) or -. Then, the data is grouped by subjectid and activity and the average is calculated for each variable of the 68 resulting variables.
