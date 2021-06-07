# Quick Start Guide for Business Users

## Creating and Evaluating a K-means Segmentation Model

Once a LookML Developer creates an Explore with the appropriate training dataset paired with the BQML K-means Block, the Looker business analyst can begin creating and evaluating K-means segmentation models.

Clustering is a common exploratory data analysis technique used to gain a better understanding of your data by grouping observations (e.g., customers, stores, products, transactions, etc...) into "like" segments or clusters based on a collection of behaviors and attributes known about each observation. For example, you may want to cluster retail stores based on region, annual profit, total sales, or top selling brands in each. Or you may want to segment your customers based on Recency, Frequency or Monetary metrics.

K-means uses a distance alogirthm to:
* Divide data into similar clusters or segments
* where records within each cluster are as similar as possible
* and each cluster is as dissimilar from other clusters as possible

This Quick Start guide will explain how a business analyst can create and evaluate a K-means segmentation model.
An Explore defined with BQML K-means will include steps to **create a model** and steps to **evaluate a model**. We will describe this steps at a high-level and then discuss each step in more detail as we walk through the example Explore **BQML K-Means: London Bicycle Station Segmentation** included with the block.

### Create Model Steps

To create a model, you must review and make selections from *Steps 1 - 5*. You may also select from *Steps 6 - 8* when creating a model; however, these steps are not required to create the model.

| Step  | Description |
| ------------- | ------------- |
| **\[1\] BQML: Input Data**  | data to be clustered |
| **\[2\] BQML: Name Your Model** | name of model to be created or evaluated (no spaces allowed)  |
| **\[3\] BQML: Select Training Data**  | Specify what observation to cluster and what attributes/features to use for clustering. For example, the clustering field is customer, and you cluster the data based on customer attributes like total revenue. Features available for selection come from list of dimensions found in *Input Data* in Step 1).  |
| **\[4\] BQML: Set Model Parameters**  | Specify the number of clusters or segments to create (if omitted, BigQuery ML will choose a reasonable default based on number of rows in the training data). |
| **\[5\] BQML: Create Model**  | To create model, must add this dimension to the query. When model has successfully completed, value will show "Complete".  |

### Evaluate Model Steps

To evaluate a model which has already been created, you must specifiy name of the model (*Step 2*) plus make selections from *Steps 6, 7 or 8*. Note these steps can be included as part of the *Create Model* process but are not required to create the model.

| Step  | Description |
| ------------- | ------------- |
| **\[6\] BQML: Evaluation Metrics**  | The goal of K-means clustering is to find segments or clusters in which members of a segment are as similar as possible while each segment is as distinctive as possible from the other segments. These evaluation metrics produced by the BigQuery ML modeling process are indicators of how well these goals are achieved (the lower the number, the better the solution).    |
| **\[7\] BQML: Predictions** | This step uses the specificed model to predict the distance of each observation to each cluster centroid. Each observation is assigned to its *nearest centroid*  |
| **\[8\] BQML: Profiles** | Uses the centroid means produced by BigQuery ML K-means modeling process to generate a profile of each cluster (i.e., what are the main features/attributes driving the cluster). Also include specially designed metrics to allow business analyst to build a table visualization comparing each cluster to the overall mean of the training dataset.    |
