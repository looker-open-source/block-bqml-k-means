# ReadMe for LookML Developers


## About this LookML Block

Clustering is a common exploratory data analysis technique used to gain a better understanding of your data by
grouping observations (e.g., customers, stores, products, transactions, etc...) into "like" segments or clusters
based on a collection of behaviors and attributes known about each observation. For example, you may want to
cluster retail stores based on region, annual profit, total sales, or top selling brands in each. Or you may
want to segment your customers based on Recency, Frequency or Monetary metrics.

A K-means clustering algorithm is an unsupervised machine learning technique used for data segmentation; for
example, identifying customer segments, fraudulent transactions, or similar documents. Using this Block, Looker
developers can add this advanced analytical capability right into new or existing Explores, no data scientists
required.

Using this Block, you can integrate Looker with a BigQuery ML K-Means model to get the benefit of clustering
and segmenting data using advanced analytics, without needing to be an expert in data science.

K-means uses a distance algorithm to:
- Divide data into similar clusters or segments
- Ensures data within each group are as similar as possible
- Ensures each group is as dissimilar from other groups as possible

This Block gives business users the ability to identify clusters or segments in data using a new or existing
Explore. Explores created with this Block can be used to train multiple K-Means models, evaluate them, and
access their predictions in dashboards or custom analyses.


## Block Requirements

This Block requires a BigQuery database connection with the following:
- Service account with the **BigQuery Data Editor** and **BigQuery Job User** predefined roles
- Looker PDTs enabled
- The temporary dataset for Looker PDTs must be located in the `US` multi-region location to use this block's example Explore


## Implementation Steps

1. Install block from Looker Marketplace
  - Specify the name of a BigQuery connection and the connection's dataset for Looker PDTs
2. Create an IDE folder to save refinements for each new use case
3. Create refinements of the following LookML files in the use case's IDE folder:
  - (REQUIRED) `input_data.view` - Include the sql definition for the input dataset. Each row should represent an individual item / observation to be clustered and include features / attributes of the item that users may want to use for defining clusters.
  - (REQUIRED) `model_name_suggestions.explore` - Add a *sql_always_where* clause to specify the `${model_info.explore} = explore_name`. This will prevent suggestions of ML models names created with other Explores.
  - (OPTIONAL) `k_means_training_data.view` - Specify allowed parameter values and the default value for "Select Item ID" (e.g. trip_id) and optionally hide the parameter. The "Select Item ID" field requires the end user to select a field that uniquely identifies each row in the data.
  - (OPTIONAL) `k_means_predict.view` - The ID field chosen in "SELECT Item ID" is returned as `item_id` in model predictions. If there is only one valid ID field for "Select Item ID" (e.g. trip_id), you may choose to add a label to the `item_id` dimension (e.g., Trip ID).
4. Create a new LookML model for each use case (See [Example](https://github.com/looker/block-bqml-k-means/blob/master/models/nyc_taxi_trip_segmentation.model.lkml))
  - Add include statements to include `bqml_k_means.explore` file and all refinement files in your use case IDE folder
  - Create an Explore in the use case's LookML model that extends the `bqml_k_means` Explore
  - Join `k_means_predict` to the extending Explore (*type: full_outer*) and define the JOIN criteria between `input_data` and `k_means_predict`


## Enabling Business Users

This block comes with a [Quick Start Guide for Business Users](https://github.com/looker/block-bqml-k-means/blob/master/QUICK_START_GUIDE.md) and the following example Explore for enabling business users.
- BQML K-Means: NYC Taxi Trip Segmentation


## Notes and Other Known Issues

BigQuery ML requires the target dataset for storing ML models be in the same location as the data used to
train the model. This block's example Explore uses BiqQuery public data stored in the `US` multi-region location.
Therefore, to use the block's example Explore, your BiqQuery database connection must have a temporary dataset for
Looker PDTs located in the `US` region. If you would like to use the block with data stored in other regions, simply
create another BigQuery connection in Looker with a Looker PDT dataset located in that region.

When using multiple BigQuery database connections with this block, it's recommended to use the same dataset
name for Looker PDTs in different BigQuery projects. This will prevent Looker PDT dataset references throughout
the block from breaking.
See [BigQuery ML Locations](https://cloud.google.com/bigquery-ml/docs/locations) for more details.

Avoid using BigQuery analytic functions such as ROW_NUMBER() OVER() in the SQL definition of a use case's input data. Including
analytic functions may cause BigQuery to return an InternalError code when used with BigQuery ML functions. If your input data is
missing a primary key, CONCAT(*field_1, field_2, ...*) two or more columns to generate a unique ID instead of using ROW_NUMBER() OVER().


## Resources

[BigQuery ML Tutorial: Creating a k-means clustering model](https://cloud.google.com/bigquery-ml/docs/kmeans-tutorial)

[BigQuery ML Documentation](https://cloud.google.com/bigquery-ml/docs)

[BigQuery ML Pricing](https://cloud.google.com/bigquery-ml/pricing#bqml)

[BigQuery ML Locations](https://cloud.google.com/bigquery-ml/docs/locations)


### Find an error or have suggestions for improvements?
Blocks were designed for continuous improvement through the help of the entire Looker community, and we'd love your input. To log an error or improvement recommendations, simply create a "New Issue" in the corresponding Github repo for this Block. Please be as detailed as possible in your explanation, and we'll address it as quickly as we can.


#### Author: Google
