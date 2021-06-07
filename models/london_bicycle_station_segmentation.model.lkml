connection: "@{database_connection}"

include: "/explores/bqml_k_means.explore"
include: "/use_case_refinements/london_bicycle_station_segmentation/*"

explore: london_bicycle_station_segmentation {
  label: "BQML K-Means: London Bicycle Station Segmentation"
  description: "Use this Explore to create BQML K-means Clustering models for station segmentation analysis using BigQuery's Public dataset for London Bicyles"

  extends: [bqml_k_means]

  join: k_means_predict {
    type: full_outer
    relationship: one_to_one
    sql_on: ${input_data.station_name} = ${k_means_predict.item_id} ;;
  }
}
