connection: "@{database_connection}"

include: "/explores/bqml_k_means.explore"
include: "/use_case_refinements/ecommerce_customer_segmentation/*"

explore: ecommerce_customer_segmentation {
  label: "BQML K-Means: eCommerce Customer Segmentation"
  description: "Use this Explore to create BQML K-means Clustering models for customer segmentation analysis using Looker's eCommerce dataset"

  extends: [bqml_k_means]

  join: k_means_predict {
    type: full_outer
    relationship: one_to_one
    sql_on: ${input_data.user_id} = ${k_means_predict.item_id} ;;
  }

  query: create_model {
    label: "Create Model"
    description: "Important: Provide a unique name for your ML model"
    dimensions: [k_means_create_model.train_model]
    filters: [model_name.select_model_name: "",
              k_means_training_data.select_features: "\"days_since_latest_order\",\"lifetime_orders\",\"lifetime_revenue\""]
  }

  query: evaluate_model {
    label: "Evaluate Model"
    description: "Important: Specify model name from Create Model step"
    dimensions: [k_means_evaluate.davies_bouldin_index, k_means_evaluate.mean_squared_distance]
    filters: [model_name.select_model_name: ""]
  }

  query: get_predictions {
    label: "Get Predictions"
    description: "Important: Specify model name from Create Model step"
    dimensions: [k_means_predict.centroid_id]
    measures: [k_means_predict.item_count, k_means_predict.item_count_percent_of_total, k_means_predict.total_item_count]
    filters: [model_name.select_model_name: ""]
    sorts: [k_means_predict.centroid_id: asc]
  }
}
