view: k_means_hyper_params {
  label: "[4] BQML: Set Model Parameters"

  parameter: choose_number_of_clusters {
    label: "Select Number of Clusters (optional)"
    description: "Enter the number of clusters you want to create. If omitted, BigQuery ML will choose a reasonable default based on the total number of rows in the training data"
    type: number
    default_value: "auto"
  }
}
