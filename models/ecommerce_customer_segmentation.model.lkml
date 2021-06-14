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
}
