## Air Quality Predicition

For this project, my prediction research question is can we predict the air quality on a certain day based off certain factors such as nitric oxide levels, nitric dioxide, and ammonia levels in the air. My variable of interest is air quality level (AQI variable), and this is a regression problem.


## Structure of this repository
	•	data ~ This contains the raw data file 
	
	•	R files ~ This contains all the .R files where the code has been conducted. The following R files are present in this folder:
		◦	0_data_EDA.R ~ This file contains the EDA I performed to investigate relationships between predictor variables
		◦	0_targvar_analysis.R ~ This file contains my analysis of the target variable on the entire dataset
		◦	1_initial_setup.R ~ This shows the initial set up for the lab including the folds
		◦	2_adv_recipe.R ~ This contains the code for the main featured engineered recipe for parametric models (linear, elastic net)
		◦	2_basic_recipe_lm.R ~ This contains the code for the basic recipe for parametric models (null, linear, elastic net)
		◦	2_adv_tree_recipe.R ~ This contains the code for the main featured engineered recipe for tree models (knn, random forest, boosted tree)
		◦	2_adv_base_recipe.R ~ This contains the code for the basic recipe for tree models (knn, random forest, boosted tree)
		◦	Starts with 3_ ~ These files contain the code for the 6 different models on both recipes - rf, bt, knn, elastic, linreg, and null 
		◦	4_model_results ~ This file contains the model analysis and code 
		◦ 	5_fitting_best_mod ~ this contains the fitting of the model that performed the best to the training data
		◦ 	6_best_model_results ~ This file contains the evaluation of the model performance on the test data
		
	•	results ~ This contains all the rda files for the split data, recipes, model fits, tables, and graphs
