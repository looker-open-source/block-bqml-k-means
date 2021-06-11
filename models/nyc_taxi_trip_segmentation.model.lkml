connection: "@{database_connection}"

include: "/explores/bqml_k_means.explore"
include: "/use_case_refinements/nyc_taxi_trip_segmentation/*"

explore: nyc_taxi_trip_segmentation {
  label: "BQML K-Means: NYC Taxi Trip Segmentation"
  description: "Use this Explore to create BQML K-means Clustering models for NYC taxi trips BigQuery's Public dataset for NYC Taxi Trips."

  extends: [bqml_k_means]

  join: k_means_predict {
    type: full_outer
    relationship: one_to_one
    sql_on: ${input_data.trip_id} = ${k_means_predict.item_id} ;;
  }

  query: create_model {
    label: "Create Model"
    description: "Important: Provide a unique name for your ML model"
    dimensions: [k_means_create_model.train_model]
    filters: [
      k_means_hyper_params.choose_number_of_clusters: "5",
      k_means_training_data.select_features: "\"fare_amount\",\"duration_minutes\",\"trip_distance\"",
      model_name.select_model_name: ""
    ]
  }

  query: evaluate_model {
    label: "Evaluate Model"
    description: "Important: Specify the model name from step 1"
    dimensions: [k_means_evaluate.davies_bouldin_index, k_means_evaluate.mean_squared_distance]
    filters: [model_name.select_model_name: ""]
  }

  query: get_predictions {
    label: "Get Predictions"
    description: "Important: Specify the model name from step 1"
    dimensions: [k_means_predict.centroid_id]
    measures: [k_means_predict.item_count, k_means_predict.item_count_percent_of_total, k_means_predict.total_item_count]
    filters: [model_name.select_model_name: ""]
    sorts: [k_means_predict.centroid_id: asc]
  }
}
