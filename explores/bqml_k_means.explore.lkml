include: "/views/*.view"

explore: bqml_k_means {
  extension: required
  view_name: model_name
  group_label: "Advanced Analytics with BQML"
  description: "Use this Explore to build and evaluate a BQML K-means Clustering model"
  persist_for: "0 minutes"

  always_filter: {
    filters: [model_name.select_model_name: ""]
  }

  join: input_data {
    type: cross
    relationship: one_to_many
  }

  join: k_means_training_data {
    sql:  ;;
    relationship: many_to_one
  }

  join: k_means_hyper_params {
    sql:  ;;
    relationship: many_to_one
  }

  join: k_means_create_model {
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

  join: k_means_predict {
    type: cross
    relationship: many_to_many
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
