include: "/views/*.view"
include: "/jt_testing/*.view"

explore: jt_users_explore {
  group_label: "JT Testing"
  label: "JT Users Explore"
 extends: [jt_testing_extension]
view_name: jt_users

  join: k_means_predict {
    type: left_outer
    sql_on: ${k_means_predict.item_id} = ${jt_users.user_id} ;;
    relationship: one_to_one
  }

  query: cluster_profiles {
    dimensions: [jt_k_means_centroid_feature_category_profile.centroid_label, jt_k_means_centroid_feature_category_profile.feature_category]
    measures: [jt_k_means_centroid_feature_category_profile.centroid_value_highlight]
    filters: [model_name.select_model_name: "\"cust_shop_segments\""]
  }


}

explore: jt_testing_extension {
  extension: required
  group_label: "JT Testing"
  #description: "Use this Explore to build and evaluate a BQML K-means Clustering model"

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
  relationship: one_to_one
}

join: k_means_predict {
  type: left_outer
  sql_on: TRUE ;;
  relationship: one_to_one
}

join: nearest_centroids_distance {
  type: left_outer
  sql: LEFT JOIN UNNEST(${k_means_predict.nearest_centroids_distance}) as nearest_centroids_distance ;;
  relationship: one_to_many
}

# join: k_means_centroid_counts {
#   type: left_outer
#   sql_on: ${k_means_predict.centroid_id} = ${k_means_centroid_counts.centroid_id} ;;
#   relationship: one_to_many
# }

# join: k_means_centroids {
#   type: left_outer
#   sql_on: ${k_means_predict.centroid_id} = ${k_means_centroids.centroid_id} ;;
#   relationship: many_to_one
# }

# join: categorical_value {
#   sql: LEFT JOIN UNNEST(${k_means_centroids.categorical_value}) as categorical_value ;;
#   relationship: one_to_many
# }

# join: k_means_centroid_feature_category {
#   type: left_outer
#   sql_on: ${k_means_predict.centroid_id} = ${k_means_centroid_feature_category.centroid_id} ;;
#   relationship: many_to_one
# }

join: jt_k_means_centroid_feature_category_profile {
    type: full_outer
    sql_on: ${k_means_predict.centroid_id} = ${jt_k_means_centroid_feature_category_profile.centroid_id} ;;
    relationship: many_to_one
  }

#validate against original
  # join: k_means_centroid_profiles_with_overall {
  #   type: full_outer
  #   sql_on: ${k_means_predict.centroid_id} = ${k_means_centroid_profiles_with_overall.centroid_id} ;;
  #   relationship: many_to_one
  # }

}
