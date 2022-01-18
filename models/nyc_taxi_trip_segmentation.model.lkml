connection: "@{CONNECTION_NAME}"


include: "/views/*.view"

explore: nyc_taxi_trip_segmentation {
  view_name: model_name
  group_label: "Looker + BigQuery ML"
  label: "BQML K-Means: NYC Taxi Trip Segmentation"
  description: "Use this Explore to create BQML K-means Clustering models for NYC taxi trips BigQuery's Public dataset for NYC Taxi Trips."
  persist_for: "0 minutes"

 always_filter: {
  filters: [model_name.select_model_name: ""]
}

join: nyc_taxi_trip_input_data {
  type: cross
  relationship: one_to_many
}

join: nyc_taxi_trip_k_means_training_data {
  sql:  ;;
relationship: many_to_one
}

join: k_means_hyper_params {
  sql:  ;;
relationship: many_to_one
}

join: nyc_taxi_trip_k_means_create_model {
  sql:  ;;
relationship: many_to_one
}

join: k_means_evaluate {
  type: cross
  relationship: many_to_many
}

join: k_means_evaluate_history {
  type: cross
  relationship: many_to_many
}

## update type, relationship and sql_on to join k_means_predict.item_id to equivalent field in input_data view defined for use case
join: k_means_predict {
  type:full_outer
  relationship: one_to_one
  sql_on: ${nyc_taxi_trip_input_data.trip_id} = ${k_means_predict.item_id} ;;
}

join: nearest_centroids_distance {
  sql: LEFT JOIN UNNEST(${k_means_predict.nearest_centroids_distance}) as nearest_centroids_distance ;;
  relationship: one_to_many
}

join: k_means_centroids {
  type: left_outer
  sql_on: ${k_means_predict.centroid_id} = ${k_means_centroids.centroid_id} ;;
  relationship: many_to_one
}

join: categorical_value {
  sql: LEFT JOIN UNNEST(${k_means_centroids.categorical_value}) as categorical_value ;;
  relationship: one_to_many
}

join: k_means_centroid_item_count {
  type: left_outer
  sql_on: ${k_means_centroids.centroid_id} = ${k_means_centroid_item_count.centroid_id} ;;
  relationship: one_to_one
}

join: k_means_centroids_indexed_values {
  type: full_outer
  sql_on: ${k_means_centroids.centroid_id} = ${k_means_centroids_indexed_values.centroid_id} AND ${categorical_value.feature_category} = ${k_means_centroids_indexed_values.feature_category} ;;
  relationship: one_to_one
}
}
