# **Quick Start Guide for Business Users**

## Creating and Evaluating a K-means Segmentation Model

Once a LookML Developer creates an Explore with the appropriate training dataset paired with the BQML K-means Block, the Looker business analyst can begin creating and evaluating K-means segmentation models.

Clustering is a common exploratory data analysis technique used to gain a better understanding of your data by grouping observations (e.g., customers, stores, products, transactions, etc...) into "like" segments or clusters based on a collection of behaviors and attributes known about each observation.

For example, a retailer may want to identify natural groupings of customers who have similar purchasing habits or locations. Data you use to perform customer segmentation might include the store they visited, what items they bought, how much they paid, and so on. You would create a segmentation model to understand what these groups of customer personas are like so you can design items which appeal to group members.

You could also find product groups among the items purchased. In this case, you would cluster items based on who purchased them, when they were purchased, where they were purchased, and so on. You would create a segmentation model to determine the characteristics of a product group so that you can make informed decisions such as how to improve cross-selling.

You can even use segmentation for fraud detection as this unsupervised machine learning technique can identify anomalies or patterns in your data you may not realize exist.

---
  K-means uses a distance alogirthm to:
  - **Divide** data into clusters or segments
  - where records within each cluster are as **similar** as possible
  - and each cluster is as **dissimilar** from other clusters as possible
---

This Quick Start guide will explain how a business analyst can create and evaluate a K-means segmentation model.
An Explore defined with BQML K-means will include steps to **create a model** and steps to **evaluate a model**. We will describe these steps at a high-level and then discuss each step in more detail as we walk through the example Explore **BQML K-Means: NYC Taxi Trip Segmentation** included with the block.

### Create Model Steps

To create a model, you must review and make selections from *Steps 1 - 5*. You may also select from *Steps 6 - 8* when creating a model; however, these steps are not required to create the model.

| Step  | Description |
| ------------- | ------------- |
| **\[1\] BQML: Input Data**  | Data to be used for clustering and profiling |
| **\[2\] BQML: Name Your Model** | **REQUIRED** Name of model to be created or evaluated (no spaces allowed)  |
| **\[3\] BQML: Select Training Data**  | **REQUIRED to create model** Specify what observation to cluster and what attributes/features to use for clustering. For example, the clustering field is customer, and you cluster the data based on customer attributes like total revenue. Features available for selection come from list of dimensions found in *Input Data* in Step 1).  |
| **\[4\] BQML: Set Model Parameters**  | Specify the number of clusters or segments to create (if omitted, BigQuery ML will choose a reasonable default based on number of rows in the training data). |
| **\[5\] BQML: Create Model**  | **REQUIRED to create model** To create model, must add this dimension to the query. When model has successfully completed, value will show "Complete".  |

### Evaluate Model Steps

To evaluate a model which has already been created, you must specifiy name of the model (*Step 2*) plus make selections from *Steps 6, 7 or 8*. Note these steps can be included as part of the *Create Model* process but are not required to create the model.

| Step  | Description |
| ------------- | ------------- |
| **\[6\] BQML: Evaluation Metrics**  | The goal of K-means clustering is to find segments or clusters in which members of a segment are as similar as possible while each segment is as distinctive as possible from the other segments. These evaluation metrics produced by the BigQuery ML modeling process are indicators of how well these goals are achieved (the lower the number, the better the solution).    |
| **\[7\] BQML: Predictions** | This step uses the specificed model to predict the distance of each observation to each cluster centroid. Each observation is assigned to its *nearest centroid*  |
| **\[8\] BQML: Profiles** | Uses the centroid means produced by BigQuery ML K-means modeling process to generate a profile of each cluster (i.e., what are the main features/attributes driving the cluster). Also include specially designed metrics to allow business analyst to build a table visualization comparing each cluster to the overall mean of the training dataset.    |


## **\[1\] BQML: Input Data**

The proper preparation of the input dataset is critical to the success of K-means clustering. The LookML developer who sets of the BQML K-means explore will need to prepare a dataset for the observations of interest with meaningful attributes/behaviors that can be used to group similar observations into clusters.

To illustrate, we will look at the example Explore **BQML K-Means: NYC Taxi Trip Segmentation** included with the block. We will group *trips* based on the following attributes:
The dataset contains:

| Dimension  | Description |
| ------------- | ------------- |
| Trip ID | observation we will be grouping into K clusters |
| Duration Minutes | average duration in minutes of a trip |
| Distance | distance of trip |
| Fare Amount | amount of fare excluding tip, toll and other fees |

The dataset also contains a few other dimensions we will use for profiling our resulting clusters but will not use them to define the basis of the cluster for this example.

| Measures  | Description |
| ------------- | ------------- |
| Pct Trips Weekend | percent of trips during the weekend (Sat - Sun) |
| Pct Trips 12:00AM to 6:00AM | percent of trips between 12:00AM and 6:00AM |

These dimensions will be available for selection in step **\[3\] BQML: Select Training Data**. Additional measures like *Trip Count* or *Avg Duration Minutes* are avaiable profiling clusters.

## **\[2\] BQML: Name Your Model**  **REQUIRED**

With the filter-only field **BQML Model Name (REQUIRED)**, enter a unique name to create a new BQML model or select an existing model to use in your analysis. Name must not include spaces. Note, if you enter a model name which already exists and run *create model* the existing model will be replaced.

  > For the **Trip Segmentation** example, enter unique name (e.g. trips\_by\_fare\_duration\_distance)

## **\[3\] BQML: Select Training Data**  **REQUIRED to create model**

Add **Select Features (REQUIRED)** to the filter pane. Leave the default filter condition of *is equal to* for string values. Click in the empty string field and a list of the dimensions found in **\[1\] BQML: Input Data** will be shown. You can select one or more dimensions. Note, be sure to select meaningful attributes. Fields with random values like ID fields should be avoided. BigQuery ML will automatically handle categorical fields (e.g., gender, region) and also normalize across the inputs so that attributes with widely different scales (like Sales and Age) are treated equally.

  > For the **Trip Segmentation** example, select these three trip attributes: *distance*, *duration_minutes*, *fare_amount*

## **\[4\] BQML: Set Model Parameters**

If you would like to specify the number of clusters to generate, add **Select Number of Clusters (optional)** to the filter pane. The optimal number of clusters depends on many factors--the size of the data, the number and type of attributes you are using as inputs and even how you intend to use the segments. You should consider running several iterations and compare the solutions. For example, how does 3 segments compare to 5 segments? What happens if you increase to 10 segments--are each of the individual segments of meaningful size and actionable? We will discuss ways to determine the optimal number of clusters in more detail in step **\[6\] BQML: Evaluation Metrics**.

This is an *optional* parameter. If left blank or not included, BigQuery ML will select a default size based on the number of rows in your training dataset.

  > For the **Trip Segmentation** example, add to the filter pane and type in the value 4.

## **\[5\] BQML: Create Model**

To submit any query in Looker, you must include at least one dimension in the data pane. So to create the segmentation model, add the **Train Model (REQUIRED)** dimension to the data pane. Once the dimension is added, you will be able to click the RUN button in top right and model will be built in BigQuery ML. Once segmentation model has been created, the query will return a value of **Complete** for the **Train Model** dimension. The amount of time it takes to create the model will likely be at least a few minutes. The total time can vary depending size of the dataset and number of dimensions selected for clustering.

If you select to create a model which already exists, the model will be replaced. After creating the model, you will want to remove the **Train Model (REQUIRED)** dimension from the data pane to avoid inadvertantly creating the model again.

## **\[6\] BQML: Evaluation Metrics**

The goal of K-means clustering is to group observations with similiar characteristics or behaviors. Ideally members of a cluster are tightly grouped around the centroid (distance to cluster center is minimize) while clusters are distinctive and far apart (distance between cluster centers is maximized). To evaluate how well the model named in step **\[2\] BQML: Name Your Model** acheives these objectives, add the following dimensions to the data grid and select RUN:

| Dimension  | Description |
| ------------- | ------------- |
| **Davies Bouldin Index** | The lower the value, the better the separation of the centroids and the 'tightness' inside the centroids. If creating multiple versions of a model with different number of clusters, the version which minimizes the Davies-Boudin Index is considered best. |
| **Mean Squared Distance** | The lower the value, the better the 'tightness' inside centroids |

Determining the optimum number of clusters (the "k" in K-means) depends on your use case. Sometimes the correct number will be easy to identify. Other times you will want to experiment with multiple versions of the model using different numbers of clusters. Compare the Mean Square Distance and Davies Bouldin Index across different versions of the model (e.g., how does 3-clusters compare to 4-, 5-, 6-clusters). The lowest values usually indicates the solution which performs best in terms of grouping your data while minimizing distance within each cluster.

## **\[7\] BQML: Predictions**

This step ...
