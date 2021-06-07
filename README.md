
# Read Me for LookML Developers


## About this LookML Block

Clustering is a common exploratory data analysis technique used to gain a better understanding of your data by grouping observations (e.g., customers, stores, products, transactions, etc...) into "like" segments or clusters based on a collection of behaviors and attributes known about each observation. For example, you may want to cluster retail stores based on region, annual profit, total sales, or top selling brands in each. Or you may want to segment your customers based on Recency, Frequency or Monetary metrics.

K-means uses a distance alogirthm to:
* Divide data into similar clusters or segments
* where records within each group are as similar as possible
* and each group is as dissimilar from other groups as possible

With this block added to a compatible Explore, business users can build and evaluate BQML K-means Clustering models directly from the Looker UI.


## Implementation Steps to Add Block to an Explore

1. Install block from Looker Marketplace
2. Update the database connection and looker temporary dataset constants in the manifest
3. Create a subfolder in the *use_case_refinements* IDE folder for your use case
4. Within this use case subfolder make refinements of the following as neccessary for your use case:
  *  *input_data* View - include the sql definition for the input dataset (e.g., features of the items/observations you want to include in the model or use to profile the resulting clusters by)
  *  *k_means_predict* View - specify field label for the item_id to be clustered (e.g. user_id)
  *  *k_means_training_data* View - specify parameter label for the item_id to be clustered (e.g. user_id)
  *  *model_name_suggestions* Explore - specify name of use case explore to control model name suggestions
5. Create a refinement of the *k_means_predict* View for your use case
6. Create a refinement of the *k_means_training_data* View for your use case
7. Create a model for your use case
8. Create an Explore in your new use case model that extends the *bqml_k_means* Explore
9. Define the JOIN between your input data and predictions in the extending Explore

## Block Structure

## Customizations

## Execution Steps to Create and Evaluate K-means models
See [*QUICK_START_TO_CREATE_KMEANS_MODEL*](/QUICK_START_TO_CREATE_KMEANS_MODEL.md) document for detailed steps to create and evaluate K-means model in Looker UI

## Resources

[BigQuery ML Tutorial: Creating a k-means clustering model]
(https://cloud.google.com/bigquery-ml/docs/kmeans-tutorial)

## Find an error or have Suggestions for Improvements?
Blocks were designed for continuous improvement through the help of the entire Looker community, and we'd love your input. To log an error or improvement recommendations, simply create a "New Issue" in the corresponding Github repo for this Block. Please be as detailed as possible in your explanation, and we'll address it as quick as we can.

## Notes and Other Known Issues

##### Author: Chris Schmidt, Jennifer Thomas
