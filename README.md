## Basic repo setup for final project

Describe project and general structure of repo ...

For this project, my prediction research question is can we predict the air quality on a certain day based off certain factors such as nitric oxide levels, nitric dioxide, and ammonia levels in the air. My variable of interest is air quality level (AQI variable), and this is a regression problem.


## Folders
	•	data ~ This contains the raw data file 
	
	•	R files ~ This contains all the .R files where the code has been conducted. The following R files are present in this folder:
	◦	1_initial_setup.R ~ This shows the initial set up for the lab including the folds
	◦	2_recipes.R ~ This contains the code for the recipe
	◦	Starts with 3_ ~ These files contain the code for the 6 different models - rf, bt, knn, elastic, linreg, and null 
	◦	4_model_analysis ~ This file contains the model analysis and code 
	◦ 5_fitting_best_mod ~ this contains the fitting of the model that performed the best to the training data
	◦ 6_best_model_results ~ This file contains the evaluation of the model performance on the test data
	
	•	results ~ This contains all the rda files for the split data, recipes, and model fits