# get_clean_data_peerassignment
README.md

Peer review assignment on course "Getting & cleaning Data"
Project submitted by Andy Devos - 10/07/2016

README.md: this file
run_analysis.R: script that contains all the different steps as requested by the project assigment
averages_bysubject_activity.txt: tidy data set, with averages of all variables in original data by subject and activity
CodeBook.md: Codebook

run_analysis.R:
Preparatory steps: download data and extract the necessary files for the features, activity and subject data
1.Merge the training and the test sets of the feature data. Merge the activity and subject data as well. 
  All these data are then combined. The variable labels are included as well.
2.Extract the measurements on the mean and standard deviation for each measurement, by seeking for 'mean()' and 'std()' in the variable name.
3.Use the descriptive activity names from the activity labels file. Factor the data set to get the activity labels on the activity variable.
4.Clarify the variable names by replacing the abbreviations.
5.Use the resulting data to creates a tidy data set with the average of each variable for each combination of activity and subject. 
  Create a codebook.
