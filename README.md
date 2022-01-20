# ReadMe for LookML Developers


## About this LookML Block

Clustering is a common exploratory data analysis technique used to gain a better understanding of your data by grouping observations (e.g., customers, stores, products, transactions, etc...) into "like" segments or clusters based on a collection of behaviors and attributes known about each observation. For example, you may want to cluster retail stores based on region, annual profit, total sales, or top selling brands in each. Or you may want to segment your customers based on Recency, Frequency or Monetary metrics.

A K-means clustering algorithm is an unsupervised machine learning technique used for data segmentation; for example, identifying customer segments, fraudulent transactions, or similar documents. Using this Block, Looker developers can add this advanced analytical capability right into new or existing Explores.

Using this Block, you can integrate Looker with a BigQuery ML K-Means model to get the benefit of clustering and segmenting data using advanced analytics, without needing to be an expert in data science.

K-means uses a distance algorithm to:
- Divide data into similar clusters or segments
- Ensures data within each group are as similar as possible
- Ensures each group is as dissimilar from other groups as possible

This Block gives business users the ability to identify clusters or segments in data using a new or existing Explore. Explores created with this Block can be used to train multiple K-Means models, evaluate them, and access their predictions in dashboards or custom analyses.

---
> <b><font size = "3" color="#174EA6"> <i class='fa fa-info-circle'></i>  Reach out to your Looker account team if you would like to partner with Looker Professional Services to implement this Looker + BQML block</font></b>

---

## Block Requirements
### 1. An existing [BigQuery database connection](https://docs.looker.com/setup-and-management/database-config/google-bigquery#overview):
- using **Service Account** with the `BigQuery Data Editor` and `BigQuery Job User` predefined roles. Note a connection using BigQuery OAuth cannot be used as Persistent Derived Tables are not allowed.

- with **Persistent Derived Tables** (PDTs) enabled

### 2. **BigQuery Dataset for storing KMeans model details and related tables**
- This dataset could be the same one named in your connection for Looker PDTs but does not have to be. The Service Account named in your Looker data connection must have read/write access to the dataset you choose.

- The dataset must be located in the same multi-region location as your use case data defined in the Explore (see note below). This Block creates multiple tables and views in this dataset.

During installation you will be asked for the connection and dataset name. These values will be added as constants to the Block's project marketplace_lock file. These constants will be referenced throughout the Block as KMeans models are created.

---
 <font size = "3"><font color = "red"> <i class='fa fa-exclamation-triangle'></i><b> note:  BigQuery ML processes and stages data in the same location.</b></font></font><br> See [BigQuery ML Locations](https://cloud.google.com/bigquery-ml/docs/locations) for more details. The example Explore included in this Block is based on BigQuery public dataset stored in the `US` multi-region location. Therefore, to use the Block’s example Explore you should name a dataset also located in the `US` multi-region. To use this Block with data stored in region or multi-region outside of the `US`, name an K-Means model dataset located in the same region or multi-region and use refinements to hide the example Explore as it will not work in regions outside of the `US`.


 <font size = "3"><font color="red"><i class='fa fa-exclamation-triangle'></i><b> note: This Block is intended to be used with only one data connection and one dataset for model processing.</b></font></font><br>If you would like to use Block with multiple data connections, customization of the Block is required. Reach out to your Looker account team for more information and guidance from Looker Professional Services.

---


## Installation Steps
1. From the Looker Marketplace page for [BigQuery ML Clustering or Segmentation (K-Means) block](/marketplace/view/k-means), click `INSTALL` button
2. Review **license agreement** and click `Accept`
3. Review **required Looker permissions** and click `Accept`<br>_note these permissions allow Marketplace to install the Block and are not related to user or developer permissions on your instance_
4. Specify **configuration details**
    - Select **Connection Name** from dropdown. This value will be saved to the Block's marketplace_lock file for the constant named `CONNECTION_NAME` and referenced throughout the Block.
    - Enter **name of dataset for storing Model details and related tables**. This value can be the same dataset used for Looker PDTs as defined in the selected connection. This value will be saved to the Block's marketplace_lock file for the constant `looker_temp_dataset_name` and referenced throughout the Block.

Upon successful completion of the installation, a green Check Mark and bar will appear. These new objects are installed:

| type | name | description |
| -------- | -------- | ---------- |
| project | marketplace_k-means |
| explore | BQML K-Means: NYC Taxi Trip Segmentation | found in Explore menu under Looker + BigQuery ML |
| explore | BQML K-Means: Model Info  | found in Explore menu under Looker + BigQuery ML; captures details for each K-Means model created with this Block |

---
 <font size = "3"><font color="red"><i class='fa fa-exclamation-triangle'></i><b> note:  The marketplace_k-means project is installed as a bare GIT repository.</b></font></font><br>For version control utilizing a remote repository, you will need to [update the connection settings for your Git repository](https://docs.looker.com/data-modeling/getting-started/setting-up-git-connection).

---

At this point you can begin creating your own Explores incorporating the K-Means model workflow (see next section for details on building your own Explores) or navigate to the included explore example and create k-means model.

## Building an Explore with the BQML K-Means Block

The installed Block provides a workflow template as part of an Explore to guide a business user through the steps necessary to create and evaluate k-means segmentation models. As seen in the provided Explore `BQML K-Means: NYC Taxi Trip Segmentation`, a user navigates through a series of steps to create and evaluate a segmentation model. Examples of the workflow steps are:
> <b>[1] BQML: Input Data<br>
> [2] BQML: Name Your Model<br>
> [3] BQML: Select Training Data<br>
> [7] BQML: Predictions<br>
> [8] BQML: Centroids<br>
> [9] BQML: Anomaly Detection</b>

For each use case, a LookML developer will create an Explore incorporating the workflow template but changing the Input Data to match a specific use case. For example, your use case may be a segmentation model to classify customers into like groups based on lifetime revenue, recency, average spend and other attributes. You would add a new model and explore to the `marketplace_k-means project` extending the `bqml_k_means` explore that defines the overall workflow and modifying the input data to capture the desired data for your use case.

At a high-level the steps for each use case are:
><b>1)  Create Folder for all Use Case files<br>
>2)  Add New Model <br>
>3)  Make Refinements of select Explores and Views from the Block <br>
>4)  Add New Explore which Extends the Block's bqml_k_means Explore <br></b>

Details and code examples for each step are provided next. Note, all steps take place in `marketplace_k-means` project while in **development mode**.

---
 <font size = "3"><font color="red"><i class='fa fa-exclamation-triangle'></i><b> note:  If copying/pasting example LookML from this document, ensure quotation marks are straight quotes (") </b></font></font><br>When pasting from this document, quotations may appear as curly or smart quotes (“). If necessary, re-type quotes in the LookML IDE to change to straight quotes.

---

### 1. Create Folder for all Use Case files (one folder per use case)
When you open the `marketplace_k-means` project while in development mode and review the `File Browser` pane, you will see the project contains a folder called `imported_projects`. Expanding this folder you will see a subfolder named `k-means`. This folder contains all the models, explores and views for the Block. These files are read-only; however, we will be including these files in the use case model and refining/extending a select few files to support the use case. You should keep all files related to the use case in a single folder. Doing so will allow easy editing of a use case. Within the project, you should create a separate folder for each use case.

| steps | example |
| -- | -- |
| Add the folder at the project's root level by clicking + at the top of `File Browser` | |
| Select Create Folder | |
| In the Create File pop-up, enter a `Name` for the use case folder<br> Note, you should use also use this same name for the Model and Explore created in next steps | customer_value_segments |
| Click `CREATE` |

### 2. Add New Model
Add a new model file for the use case, update the connection, and add include statements for the Block's bqml_k_means Explore and use case refinement files. The included Explore from the Block will be extended into the use case Explore which will be created in the next step.

| steps | example |
| -- | -- |
| From `File Browser` pane, navigate to and click on the Use Case Folder created in prior step | |
| To create the file insider the folder, click the folder's menu (found just to the right of the folder name) | |
| Select Create Model | |
| In the Create File pop-up, enter a `Name` for the use case folder  | customer_value_segments |
| Click `CREATE` |
| Within newly created model file, set `connection:` parameter to value set during installation of this Block | connection: "thlook_bq" |
| Add an include statement for all view files found in same directory (note, you may receive a warning files cannot be found but you can ignore as files will be added in following steps)| include: "*.view" |
| Add an include statement for all Explore files found in same directory (note, you may receive a warning files cannot be found but you can ignore as files will be added in following steps) | include: "*.explore" |
| Add an include statement for the Block's `bqml_k_means.explore` so the file is available to this use case model and can be extended into the new Explore created in the next step.| include: "//k-means/**/bqml_k_means.explore" |
| Click `SAVE` | |


### 3. Make Refinements of select Explores and Views from the Block
Just like we used the bqml_k_means explore as a building block for the use case explore, we will adapt the Block's `input_data.view` and `model_name_suggestions.explore` and, if needed, adapt `k_means_training_data.view` and `k_means_predict.view` for the use case using LookML refinements syntax. To create a refinement you add a plus sign (+) in front of the name to indicate that it's a refinement of an existing view. All the parameters of the existing view will be used and select parameters can be modified (i.e., overwrite the original value). For detailed explanation of refinements, refer to the [LookML refinements](https://docs.looker.com/data-modeling/learning-lookml/refinements) documentation page. Within the use case folder, add a new `input_data.view`, a new `model_name_suggestions.explore` and optionally add new `k_means_predict.view` and `k_means_training_data.view` files. Keep reading for detailed steps for each refinement file.


#### <font size=5>3a. input_data.view </font><font color='red'> (REQUIRED)

The input_data.view is where you define the data to use as input into the segmentation model. The Block's example input_data.view is a SQL derived table, so the use case refinement will update the derived_table syntax and all dimensions and measures to match the use case. We recommend using SQL Runner to test your query and generate the Derived Table syntax (see [SQL Runner](https://docs.looker.com/data-modeling/learning-lookml/sql-runner-create-dts) documentation for more information). The steps are below.

| steps | example |
| -- | -- |
| From `File Browser` pane, navigate to and click on the Use Case Folder | |
| To create the file insider the folder, click the folder's menu (found just to the right of the folder name) | |
| Select Create View | |
| In the Create File pop-up, enter `input_data` <br><br>While this file name does not have to match the original filename, we recommend you keep it the same.| input_data |
| Click `CREATE` |
| Navigate to SQL Runner by clicking on the `Develop` Menu and selecting `SQL Runner` | |
| In left pane, change `Connection` to match the connection defined during installation of this Block (see project's marketplace_lock file and value for `@{CONNECTION_NAME}`)  | @CONNECTION_NAME = thelook_bq |
| Write and test your SQL query to produce the desired dataset. This example creates a simple dataset with customer_id, lifetime_sales, days_since_last_visit, average_spend_per_trip. | SELECT<br>customer_id<br>,sum(sales) as lifetime_sales<br>, sum(sales)/count(distinct order_id) as average_spend_per_trip<br>,date_diff(current_date,max(order_date),DAY) as days_since_last_visit<br>FROM ecommerce.orders<br>group by 1|
| Once the results are as expected, click the `gear` menu (next to Run button) and select `Get Derived Table LookML`. | |
| Copy the generated LookML (all lines) | |
| Navigate back to `input_data.view` in your Use Case Folder | |
| Delete all the notes in the file which were auto-generated when you created the file | |
| Paste the contents from SQL Runner into the file | |
| On line 1 of the file insert include statement for the Block view to be refined | include: "//k-means/views/input_data.view" |
| Replace `view: sql_runner_query` with `view: +input_data` <br> <br>The plus sign (+) indicates we are modifying/refining the original input_data view defined for the Block | view: +input_data |
| Review the remaining LookML and edit as necessary with:<br>a. names, labels, group labels, descriptions<br>b. identify primary key field<br>c. Modify date formats as necessary. For example, dates are automatically defined as a `dimension_group with type of time` so modify as necessary for timeframes or convert to a single date dimension.<d> Add any additional measures if needed (only count created by default) | dimension: customer_id {<br>  type: string<br>  primary_key: yes<br>  sql: <br>${TABLE}.customer_id ;;<br>} |
| Click `SAVE` | |

---
   <font size = "3"><font color="red"><i class='fa fa-exclamation-triangle'></i><b> note: Avoid using BigQuery analytic functions such as ROW_NUMBER() OVER() in the SQL definition of a use case's input data.</b></font></font> Including analytic functions may cause BigQuery to return an `InternalError` code when used with BigQuery ML functions. If your input data is missing a primary key, CONCAT(*field_1, field_2, ...*) two or more columns to generate a unique ID instead of using ROW_NUMBER() OVER().

---


#### <font size=5>3b. model_name_suggestions.explore </font><font color='red'> (REQUIRED)
To create a K-Means segmentation model, the user must enter a name for the model and can type in any string value. The K-Means Explore also allows the user to evaluate a model which has already been created. The `Model Name` parameter allows users to select the name from a list of existing models created by the given Explore. These suggested values come from the `BQML_K_MEANS_MODEL_INFO` table stored in the Model Details dataset defined for the Block during installation. Because this table captures details for all models created with the Block across all Explores, we need to filter the suggestions by Explore name–the Explore which will be created next in `Implementation Step 4`. If you do not filter for the use case Explore, an error would occur if the user tries to evaluate a model based on different input data.

The name suggestions come from the `model_name_suggestions.explore` and in this step we will refine the `sql_always_where` filter applied to the include the use case Explore name.

| steps | example |
| -- | -- |
| From `File Browser` pane, navigate to and click on the Use Case Folder | |
| To create the file insider the folder, click the folder's menu (found just to the right of the folder name) | |
| Select Create Generic LookML File | |
| In the Create File pop-up, enter `model_name_suggestions.explore` <br><br>While this file name does not have to match the original filename, we recommend you keep it the same. Be sure to include the `.explore` extension so you can quickly identify the type from the File Browser. | model_name_suggestions.explore |
| Click `CREATE` |
| On line 1 of the blank file, insert include statement for the Block explore to be refined | include: "//k-means/**/model_name_suggestions.explore" |
| On the next lines, enter<br> a. the explore name using the + refinement syntax<br> b. update sql_always_where syntax with use case explore name (as shown in <font color = 'orange'>bold</font> in the example) | explore: +model_name_suggestions {<br>  sql_always_where: ${model_info.explore} =<font color='orange'><b>'customer_value_segments'</b></font>;;<br>} |


#### <font size=5>3c. k_means_predict.view </font><font color='red'> (OPTIONAL)
As noted earlier the K-Means prediction output uses generic term Item ID as the unit of segmentation for all Models. To improve the user experience, you may consider changing the label for Item ID to value more meaningful to the user (e.g., if segmenting on customers, change label to Customer Id).

| steps | example |
| -- | -- |
| From `File Browser` pane, navigate to and click on the Use Case Folder | |
| To create the file insider the folder, click the folder's menu (found just to the right of the folder name) | |
| Select Create View | |
| In the Create File pop-up, enter `k_means_predict` <br><br>While this file name does not have to match the original filename, we recommend you keep it the same.| k_means_predict |
| Click `CREATE` |
| On line 1 of the file insert include statement for the Block view to be refined | include: "//k-means/**/k_means_predict.view" |
| Replace `view: k_means_predict` with `view: +k_means_predict` <br> <br>The plus sign (+) indicates we are modifying/refining the original k_means_predict view defined for the Block | view: +k_means_predict |
| On next lines, add dimension: item_id and update *label:* accordingly:| dimension: item_id {<br>    <font color='orange'><b>label: "Customer ID"</b></font><br>} |
| Click `SAVE`| |

#### <font size=5>3d. k_means_training_data.view </font><font color='red'> (OPTIONAL)
As part of the create K-Means segmentation model workflow, the user is required to include the `Select an ID Field` parameter to identify which field in the input data is the unit of segmentation (i.e., the field that uniquely identifies each row of the input data). To improve the user experience, you may set a default value for this parameter and hide it from the Explore, so the user does not have to make a selection.

| steps | example |
| -- | -- |
| From `File Browser` pane, navigate to and click on the Use Case Folder | |
| To create the file insider the folder, click the folder's menu (found just to the right of the folder name) | |
| Select Create View | |
| In the Create File pop-up, enter `k_means_training_data` <br><br>While this file name does not have to match the original filename, we recommend you keep it the same.| k_means_training_data |
| Click `CREATE` |
| On line 1 of the file insert include statement for the Block view to be refined | include: "//k-means/**/k_means_training_data.view" |
| Replace `view: k_means_training_data` with `view: +k_means_training_data` <br> <br>The plus sign (+) indicates we are modifying/refining the original k_means_training_data view defined for the Block | view: +k_means_training_data |
| If you want to set the default and hide the parameter:<br>a. delete the auto-generated comments added when view file was created<br>b.update parameter: select_item_id with default value equal to primary key of the `input_data` view and set hidden to yes<br> <br><font color='red'><i class='fa fa-exclamation-triangle'></i> note: Using a default means the `input_data` view defined for the use case Explore must contain a field matching the default value otherwise an error may occur.</font> | parameter: select_item_id {<br>    <font color = 'orange'><b>default_value: "customer_id"<br>    hidden: yes<br></b></font> } |
| Click `SAVE`| |



### 4. Add New Explore which Extends the Block's bqml_k_means Explore
As noted earlier, all the files related to this Block are found in the `imported_projects\k-means` directory. The Explore file `bqml_k_means.explore` specifies all the views and join relationships to generate the stepped workflow the user will navigate through to create and evaluate segmentation models using K-Means. For each use case, you will use the `bqml_k_means` Explore as a starting point by extending it into a new Explore. The new Explore will build upon the content and settings from the original Explore and modify some of the components to fit the use case. See the [extends for Explores](https://docs.looker.com/reference/explore-params/extends) documentation page for more information on extends. In the previous step, we added the `include: "//k-means/**/bqml_k_means.explore"` statement to the model file so that we could use this Explore for the use case. Below are the steps for adding a new Explore to the use case model file.

| steps | example                |
| -- | -- |
| Open the Use Case Model file | customer_value_segments.model |
| Add Explore LookML which <br> a. includes label, group_label and/or description relevant to your use case<br>b. extends the bqml_k_means explore<br>c. updates the join parameters of `k_means_predict` and `k_means_detect_anomalies` to reflect correct field to properly join to `input_data` <br> <br>The K-Means model prediction output assigns each unit of segmentation to a centroid (or segment). <br>Because the unit of segmentation can vary by use case, the Block uses generic term Item ID as part of the model prediction output and anomaly detection output for all k-means models. So we need to update the Explore to capture the correct unit defined in the use case's `input_data` file (as defined in the previous section).<br><br>In the example, edit the terms in <b><font color='orange'>bold</font></b> to fit your use case.<br> <br>|explore: <font color='orange'><b>customer_value_segment</b></font> {<br>  label: <font color='orange'><b>"BQML: K-Means Customer Value Segment"</b></font><br>  description: <font color='orange'><b>"Use this Explore to create Segmentation models based on customer value"</b></font><br><br>  extends: [bqml_k_means] <br><br>   join: k_means_predict {<br>    type:full_outer<br>    relationship: one_to_one<br>    sql_on: <font color = 'orange'><b>${input_data.customer_id}</b></font> = ${k_means_predict.item_id} ;;<br>  } <br> join: k_means_detect_anomalies {<br>    type:left_outer<br>    relationship: one_to_one<br>    sql_on: <font color = 'orange'><b>${input_data.customer_id}</b></font> = ${k_means_detect_anomalies.item_id} ;;<br>  }<br>} |
| Click `SAVE`| |


## K-Means CREATE MODEL Syntax

With this Block, the user will be able to control these options for the K-Means Model:

| options | description | default |
| -- | -- | -- |
| model name | name of the BigQuery ML model that you're creating or replacing |
| num_clusters | The number of clusters to identify in the input data. Allowed values are 2 - 100 | auto (derived from number of observations in input data) |

The user provides the values for the `select_item_id` and `select_features` parameters to define the training dataset input into the model. The `kmeans_init_method` of KMEANS++ is used for all K-Means models created with this Block. All other options are left at defaults. For more information about the possible options for the K-Means Model, see the [Create Model Syntax documentation](https://cloud.google.com/bigquery-ml/docs/reference/standard-sql/bigqueryml-syntax-create-kmeans#create_model_syntax).

Note, this block could be customized to include additional options and parameters.


## Enabling Business Users
This block comes with a [Quick Start Guide for Business Users](https://github.com/looker/block-bqml-k-means/blob/master/QUICK_START_GUIDE.md) and the following example Explore for enabling business users.
- BQML K-Means: NYC Taxi Trip Segmentation



## Resources

[BigQuery ML Tutorial: Creating a k-means clustering model](https://cloud.google.com/bigquery-ml/docs/kmeans-tutorial)

[BigQuery ML Documentation](https://cloud.google.com/bigquery-ml/docs)

[BigQuery ML Pricing](https://cloud.google.com/bigquery-ml/pricing#bqml)

[BigQuery ML Locations](https://cloud.google.com/bigquery-ml/docs/locations)


### Find an error or have suggestions for improvements?
Blocks were designed for continuous improvement through the help of the entire Looker community, and we'd love your input. To log an error or improvement recommendations, simply create a "New Issue" in the corresponding Github repo for this Block. Please be as detailed as possible in your explanation, and we'll address it as quickly as we can.


#### Author: Google
