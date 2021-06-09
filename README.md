
# ReadMe for LookML Developers


## About this LookML Block

Clustering is a common exploratory data analysis technique used to gain a better understanding of your data by
grouping observations (e.g., customers, stores, products, transactions, etc...) into "like" segments or clusters
based on a collection of behaviors and attributes known about each observation. For example, you may want to
cluster retail stores based on region, annual profit, total sales, or top selling brands in each.
Or you may want to segment your customers based on Recency, Frequency or Monetary metrics.

A K-means clustering algorithm is an unsupervised machine learning technique used for data segmentation; for
example, identifying customer segments, fraudulent transactions, or similar documents. Using this Block, Looker
developers can add this advanced analytical capability right into new or existing Explores, no data scientists
required.

Using this Block, you can integrate Looker with a BigQuery ML K-Means model to get the benefit of clustering
and segmenting data using advanced analytics, without needing to be an expert in data science.

K-means uses a distance alogirthm to:
- Divide data into similar clusters or segments
- Ensures data within each group are as similar as possible
- Ensures each group is as dissimilar from other groups as possible

This Block adds the ability to identify clusters or segments in your data using a new or existing Explore. You
can use this Block to create multiple K-Means models, save them, and refer to them in dashboards or custom
analyses.


## Block Requirements

This Block requires a BigQuery database connection with the following:
- Service account with the **BigQuery Data Editor** and **BigQuery Job User** predefined roles
- PDTs enabled
- The Looker PDT dataset must be located in the `US` multi-region location to use block's example Explores


## Implementation Steps

1. Install block from Looker Marketplace
  - Specify the name of a BigQuery connection and the connection's dataset for Looker PDTs
2. Create a subfolder in the *use_case_refinements* IDE folder for each new use case
3. Within the use case subfolder make the following refinements:
  -  `input_data` View - include the sql definition for the input dataset (each row should represent an individual item / observation and include features users may want to include in the ML model)
  -  `k_means_training_data` View - specify allowed parameter values for the item_id to be clustered (e.g. user_id) and optionally hide the parameter
  -  `k_means_predict` View - specify dimension label for the item_id to be clustered (e.g. user_id)
  -  `model_name_suggestions` Explore - add a sql_always_where to filter out model name suggestions from other Explores
4. Create a new model for your use case
5. Add include statement to include the `bqml_k_means` Explore and all refinements in your use case subfolder
6. Create an Explore in your new use case model that extends the `bqml_k_means` Explore
7. Define the JOIN between your input data and predictions in the extending Explore


## Enabling Business Users

This block comes with a [Quick Start Guide for Business Users](/projects/bqml_k_means_block/documents/QUICK_START_GUIDE.md) and two sample Explores.
- BQML K-Means: eCommerce Customer Segmentation
- BQML K-Means: NYC Taxi Trip Segmentation


## Notes and Other Known Issues

BigQuery ML requires that the target dataset for storing ML models be in the same location as the data used to
train the model. This block's example Explores use BiqQuery public data stored in the `US` multi-region location.
Therefore, to use the block's example Explores, your BiqQuery database connection must have a dataset for Looker
PDTs located in the `US` region. If you would like to use the block with data stored in other regions, simply
create another BigQuery connection in Looker with a Looker PDT dataset located in that region.

When using multiple BigQuery database connections with this block, it's recommended to use the same dataset
name for Looker PDTs in different BigQuery projects. This will prevent Looker PDT dataset references throughout
the block from breaking.
See [BigQuery ML Locations](https://cloud.google.com/bigquery-ml/docs/locations) for more details.


## Resources

[BigQuery ML Tutorial: Creating a k-means clustering model](https://cloud.google.com/bigquery-ml/docs/kmeans-tutorial)

[BigQuery ML Documentation](https://cloud.google.com/bigquery-ml/docs)

[BigQuery ML Pricing](https://cloud.google.com/bigquery-ml/pricing#bqml)

[BigQuery ML Locations](https://cloud.google.com/bigquery-ml/docs/locations)


### Find an error or have suggestions for improvements?
Blocks were designed for continuous improvement through the help of the entire Looker community, and we'd love your input. To log an error or improvement recommendations, simply create a "New Issue" in the corresponding Github repo for this Block. Please be as detailed as possible in your explanation, and we'll address it as quick as we can.


#### Authors: Chris Schmidt, Jennifer Thomas
