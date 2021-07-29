connection: "@{CONNECTION_NAME}"

include: "/explores/bqml_k_means.explore"

explore: nyc_taxi_trip_segmentation {
  label: "BQML K-Means: NYC Taxi Trip Segmentation"
  description: "Use this Explore to create BQML K-means Clustering models for NYC taxi trips BigQuery's Public dataset for NYC Taxi Trips."

  extends: [bqml_k_means]

  join: k_means_predict {
    type: full_outer
    relationship: one_to_one
    sql_on: ${input_data.trip_id} = ${k_means_predict.item_id} ;;
  }
}
