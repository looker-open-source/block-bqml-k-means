include: "/views/*.view"

explore: bqml_k_means {
  extension: required
  group_label: "Advanced Analytics with BQML"
  description: "Use this Explore to build and evaluate a BQML K-means Clustering model"

  always_filter: {
    filters: [model_name.select_model_name: ""]
  }

  join: model_name {
    sql:  ;;
    relationship: one_to_one
  }

  join: k_means_training_data {
    sql:  ;;
    relationship: one_to_one
  }

  join: k_means_create_model {
    sql:  ;;
    relationship: one_to_one
  }

  join: k_means_evaluate {
    type: cross
    relationship: many_to_many
  }

  join: k_means_predict {
    type: cross
    relationship: many_to_many
  }

  join: nearest_centroids_distance {
    type: left_outer
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
    type: left_outer
    sql_on: ${k_means_centroids.centroid_id} = ${k_means_centroids_indexed_values.centroid_id} AND ${categorical_value.feature_category} = ${k_means_centroids_indexed_values.feature_category} ;;
    relationship: one_to_one
  }
}
