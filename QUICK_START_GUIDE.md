# **Quick Start Guide for Business Users**

## Creating and Evaluating a K-means Segmentation Model

Once a LookML Developer creates an Explore with an appropriate training dataset paired with the BQML K-means Block, a Looker business analyst can begin creating and evaluating K-means segmentation models.

Segmentation (also called Clustering) is a common exploratory data analysis technique used to gain a better understanding of your data by grouping observations (e.g., customers, stores, products, transactions, etc...) into "like" segments or clusters based on a collection of behaviors and attributes known about each observation.

For example, a retailer may want to identify natural groupings of customers who have similar purchasing habits or locations. Data you use to perform customer segmentation might include the store they visited, what items they bought, how much they paid, and so on. You would create a segmentation model to understand what these groups of customer personas are like so you can design items which appeal to group members.

You could also find product groups among the items purchased. In this case, you would cluster items based on who purchased them, when they were purchased, where they were purchased, and so on. You would create a segmentation model to determine the characteristics of a product group so that you can make informed decisions such as how to improve cross-selling.

You can even use segmentation for fraud detection as this unsupervised machine learning technique can identify anomalies or patterns in your data you may not realize exist.

---
  K-means uses a distance algorithm to:
  - **Divide** data into similar clusters or segments
  - Ensures data within each group are as **similar** as possible
  - Ensures each group is as **dissimilar** from other groups as possible

---

This Quick Start guide will outline how a business analyst can create and evaluate a K-means segmentation model within Looker. An Explore defined with BQML K-means will include steps to **create a model** and steps to **evaluate a model**. We will describe these steps at a high-level and then discuss each step in more detail as we walk through the example Explore **BQML K-Means: NYC Taxi Trip Segmentation** included with the block.

### Create Model Steps

To create a model, you must review and make selections from *Steps 1 - 5*. You may also select from *Steps 6 - 9* when creating a model; however, these steps are not required to create the model.

| Step  | Description |
| ------------- | ------------- |
| **\[1\] BQML: Input Data**  | Data to be used for clustering and profiling |
| **\[2\] BQML: Name Your Model** | **REQUIRED** Name of model to be created or evaluated (no spaces allowed)  |
| **\[3\] BQML: Select Training Data**  | **REQUIRED to create model** Specify what observation to cluster and what attributes/features to use for clustering. For example, the clustering field is customer, and you cluster the data based on customer attributes like total revenue. Features available for selection come from the list of dimensions found in *Input Data* in Step 1).  |
| **\[4\] BQML: Set Model Parameters**  | Specify the number of clusters or segments to create (if omitted, BigQuery ML will choose a reasonable default based on the number of rows in the training data). |
| **\[5\] BQML: Create Model**  | **REQUIRED to create model** To create a model, you must add this dimension to the query. When a model has successfully completed, the value will show "Complete".  |

### Evaluate Model Steps

To evaluate a model which has already been created, you must specify name of the model (*Step 2*) plus make selections from *Steps 6, 7, 8 or 9*.

| Step  | Description |
| ------------- | ------------- |
| **\[6\] BQML: Evaluation Metrics**  | The goal of K-means clustering is to find segments or clusters in which members of a segment are as similar as possible while each segment is as distinctive as possible from the other segments. These evaluation metrics produced by the BigQuery ML modeling process are indicators of how well these goals are achieved (the lower the number, the better the solution).    |
| **\[7\] BQML: Predictions** | This step uses the specified model to predict the distance of each observation to each cluster centroid. Each observation is assigned to its *nearest centroid*.  |
| **\[8\] BQML: Centroids** | Uses the centroid means produced by BigQuery ML K-means modeling algorithm to generate a profile of each cluster (i.e., what are the main features/attributes driving the cluster). Also include specially designed metrics to allow business analysts to build a table visualization comparing each cluster to the overall mean of the training dataset.    |
| **\[9\] BQML: Anomaly Detection** | Anomalies are identified based on the value of each input data point's normalized distance to its nearest cluster. If that distance exceeds a threshold determined by the contamination value provided by the user, the data point is identified as an anomaly.  |



## **\[1\] BQML: Input Data**

The proper preparation of the input dataset is critical to the success of K-means clustering. The LookML developer who sets up the BQML K-means Explore will need to prepare a dataset for the observations of interest with meaningful attributes/behaviors which can be used to group similar observations into clusters (one row for each observation to be clustered).

To illustrate, we will look at the example Explore **BQML K-Means: NYC Taxi Trip Segmentation** included with the block. We will group *trips* based on the following attributes:

| Dimension  | Description |
| ------------- | ------------- |
| Trip ID | observation we will be grouping into K clusters |
| Duration Minutes | average duration in minutes of a trip |
| Distance | distance of trip |
| Fare Amount | amount of fare excluding tip, toll and other fees |

The dataset also contains a few other dimensions we will use for profiling our resulting clusters, but we will not use them to define the basis of the cluster for this example.

| Measures  | Description |
| ------------- | ------------- |
| Pct Trips Weekend | percent of trips during the weekend (Sat - Sun) |
| Pct Trips 12:00 AM to 6:00 AM | percent of trips between 12:00AM and 6:00AM |

These dimensions will be available for selection in step **\[3\] BQML: Select Training Data**. Additional measures like *Trip Count* or *Avg Duration Minutes* are available for profiling clusters.

>
> <b><font size = "3" color="#174EA6"> <i class='fa fa-info-circle'></i> Note, all rows of the input dataset are used in training the model regardless of filters. </font></b> You can filter the input dataset as necessary to review and understand your data or to build visualizations; however, for modeling purposes **all** rows of the input dataset are included when creating a K-means segmentation model. If you need to alter the input dataset (e.g., add or remove metrics), contact a LookML Developer for assistance in refining the Explore to meet your use case.
>



## **\[2\] BQML: Name Your Model**  (*REQUIRED*)

For the required filter-only field **BQML Model Name (REQUIRED)**, enter a unique name to create a new BQML model or select an existing model to use in your analysis. Name must not include spaces. Note, if you enter a model name which already exists and run *create model* the existing model will be replaced. Clicking into the filter will generate a list of existing models created for the given Explore if any.

  > For the **Trip Segmentation** example, enter unique name (e.g. trips\_by\_fare\_duration\_distance)


## **\[3\] BQML: Select Training Data**  (*REQUIRED to create model*)

Add **Select an ID Field (REQUIRED)** to the filter pane. Leave the default filter condition of *is equal to* for string values. Click in the empty string field and a list of the dimension found in **\[1\] BQML: Input Data** will be shown. You can only select one dimension. Be sure to select an ID dimension that uniquely identifies each observation you would like to cluster.

  > For the **Trip Segmentation** example, select *trip_id*

Add **Select Features (REQUIRED)** to the filter pane. Leave the default filter condition of *is equal to* for string values. Click in the empty string field and a list of the dimensions found in **\[1\] BQML: Input Data** will be shown. You can select one or more dimensions. Note, be sure to select meaningful attributes. Fields with random values like ID fields should be avoided. BigQuery ML will automatically handle categorical fields (e.g., gender, region) and also normalize across the inputs so that attributes with widely different scales (like Sales and Age) are treated equally.

  > For the **Trip Segmentation** example, select these three trip attributes: *trip_distance*, *duration_minutes*, *fare_amount*

## **\[4\] BQML: Set Model Parameters**

If you would like to specify the number of clusters to generate, add `Select Number of Clusters (optional)` to the filter pane and enter a value between 2 and 100. The optimal number of clusters depends on many factors--the size of the data, the number and type of attributes you are using as inputs and even how you intend to use the segments. You should consider running several iterations and comparing the solutions. For example, how does 3 segments compare to 5 segments? What happens if you increase to 10 segments--are each of the individual segments of meaningful size and actionable? We will discuss ways to determine the optimal number of clusters in more detail in step **\[6\] BQML: Evaluation Metrics**.

This is an *optional* parameter. If left blank or not included, BigQuery ML will select a default size based on the number of rows in your training dataset.

  > For the **Trip Segmentation** example, add `Select Number of Clusters (optional)` to the filter pane and type in the value **4**.

## **\[5\] BQML: Create Model** (*REQUIRED to create model*)

To submit any query in Looker, you must include at least one dimension in the data pane. So to create the segmentation model, add the **Train Model (REQUIRED)** dimension to the data pane. Once the dimension is added, you will be able to click the **RUN** button in top right and the model will be built in BigQuery ML. Once the segmentation model has been created, the query will return a value of **Complete** for the **Train Model** dimension. The amount of time it takes to create the model will likely be at least a few minutes. The total time can vary depending on size of the dataset and number of dimensions selected for clustering.

If you select a model name which already exists, the model will be replaced with the latest iteration of the model creation step. After creating the model, you will want to remove the **Train Model (REQUIRED)** dimension from the data pane to avoid inadvertently creating the model again.

## **\[6\] BQML: Evaluation Metrics**

The goal of K-means clustering is to group observations with similar characteristics or behaviors. Ideally members of a cluster are tightly grouped around the centroid (distance to cluster center is minimized) while clusters are distinctive and far apart (distance between cluster centers is maximized). To evaluate how well the model named in step **\[2\] BQML: Name Your Model** achieves these objectives, add the following dimensions to the data grid and select RUN:

| Dimension  | Description |
| ------------- | ------------- |
| **Davies Bouldin Index** | The lower the value, the better the separation of the centroids and the 'tightness' inside the centroids. If creating multiple versions of a model with different numbers of clusters, the version which minimizes the Davies-Boudin Index is considered best. |
| **Mean Squared Distance** | The lower the value, the better the 'tightness' inside centroids. |

Determining the optimum number of clusters (the *k* in K-means) depends on your use case. Sometimes the correct number will be easy to identify. Other times you will want to experiment with multiple versions of the model using different numbers of clusters. After you generate new versions of a model for a range of *k* clusters (e.g., 2 to 10) while keeping the same model name and features, use **Metric History** to create a line chart of the **Mean Square Distance** and **Davies Bouldin Index** by **Number of Clusters**. Look for an "elbow" in the plot--the spot where the evaluation metrics level out indicating the benefit of increasing the number of clusters is diminishing. A reasonable solution will be the one which best meets your business requirements and has the best combination of low Mean Square Distance and low Davies Bouldin Index.

## **\[7\] BQML: Predictions**

Each observation is assigned to its **Nearest Centroid**. Expand the group **Centroid Distances** to see the standardized **Distance** between each observation and each cluster labeled **Centroid**. You will be able to build a variety of visualizations from this section and even incorporate dimensions/metrics from **\[1\] BQML: Input Data** to generate cluster profiles.

To build a new visualization for the **Trip Segmentation** example:

> 1. From the explore, expand the `filters` pane and enter the name of the model created in **\[2\] BQML: Name Your Model**
2. From the field picker expand folder **\[7\] BQML: Predictions**, add `Nearest Centroid` to the data pane.
3. Add `Count of Observations` to the data pane.
4. Add `Percent of Total Observations` to the data pane.
6. Click `RUN` to see the sizes of each cluster.

## **\[8\] BQML: Centroids**

With the dimensions and measures in this section, you can generate a profile of each cluster by the attributes/behaviors (labeled **Feature and Category**) selected for the model in step **\[3\] BQML: Select Training Data**. Uses the centroid means (labeled **Centroid Average**) produced by BigQuery ML K-means algorithm. Provides Feature Category normalized averages for each of the K clusters as well as an overall weighted average for the training data (cluster 0). By including the overall weighted average, you can compare each cluster not only to each other but also to the overall average.

You have many different options for profiling clusters. The example below highlights which features are well below or well above the overall average.

To build a new visualization for the **Trip Segmentation** example:

> 1. From the explore, expand the `filters` pane and enter the name of the model created in **\[2\] BQML: Name Your Model**
2. From the field picker expand folder **\[8\] BQML: Centroids**, add `Feature and Category` to the data pane.
3. Add `Centroid ID (with % of Total)` as **PIVOT** column for easy comparison of features by cluster.
4. Add `Centroid Average (for conditional formatting)` to the data pane. Note, this measure is uniquely defined to display the **Centroid Average** while actually representing the **Percent Difference from Training Set Average**. Designing the metric this way will allow you to conditionally format the table and highlight the differences from the training set's weighted average. If you would prefer to see and use the actual centroid average value in a chart, you can select the measure **Centroid Average**.
5. Click RUN to generate results and we'll walk through steps to format the visualization.
6. Select Table type visualization if not already selected
7. Click `Edit`, select `Series` tab and **Uncheck** Cell Visualization under **Centroid Average (for conditional formatting)** if turned on by default
8. Select *Formatting* tab, Turn On *Enable Conditional Formatting*
9. Add a *Conditional Formatting Rule*
       - along a scale
       - apply to all numeric fields
       - set Palette to a diverging color range (consider setting middle color to white so values which do not differ much from average are not highlighted)
       - uncheck Mirror Range Around Center Value
       - set Range: start = -1 , center = 0 , end = 2 (a value of 2 means the feature average for cluster is more than 2 times the overall weighted average)

## **\[9\] BQML: Anomalies**
If you recall, one of the main goals of K-means clustering is to minimize the variance within each cluster. Within each cluster, you want the data points to be as similar to each other as possible — this is what makes them members of the same group. So you can identify anomalies as those points that are farthest away from the cluster center or centroid.

The `Contamination Threshold`, specified by the user, determines the threshold of whether a data point is considered an anomaly. For example, a contamination value of 0.1 means that the top 10% of descending normalized distance from the training data will be used as the cut-off threshold. If the normalized distance for a datapoint exceeds the threshold, then it is identified as an anomaly. Setting an appropriate contamination will be highly dependent on the requirements of the user or business.

If you expand the **\[9\] BQML: Anomaly Detection** section of the field picker you will see several dimensions and measures available for building a visualization. You can review each item/observation in the input dataset, see its normalized distance to the nearest centroid and whether it is identified as an anomaly. You can create summarized results to see how many anomalies are found by cluster.

Let's continue reviewing the **Trip Segmentation** example and create an example visualization.

> 1. From the explore, expand the `filters` pane and enter the name of the model created in **\[2\] BQML: Name Your Model**
2. From the field picker expand folder **\[9\] BQML: Detect Anomalies**, add `Contamination Threshold (Optional)` to filter pane and set value to **0.05** which means the top 5% of descending normalized distances will be classified as an anomaly.
3. Add `Nearest Centroid` to the data pane.
4. Add `Total Anomaly Count` to the data pane.
5. Add `Anomaly Percent` to the data pane to see the percentage of the cluster considered to be an anomaly.
6. Click `RUN` to see the results.


## Resources

[BigQuery ML Documentation](https://cloud.google.com/bigquery-ml/docs)

[BigQuery ML Unsupervised Anomaly Detection](https://cloud.google.com/blog/products/data-analytics/bigquery-ml-unsupervised-anomaly-detection)

#### Author: Google
