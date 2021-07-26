view: k_means_evaluate {
  label: "[6] BQML: Evaluation Metrics"

  sql_table_name: ML.EVALUATE(MODEL @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %}_k_means_model_{{ _explore._name }}) ;;

  dimension: davies_bouldin_index {
    type: number
    description: "The lower the value, the better the separation of the centroids and the 'tightness' inside the centroids. If creating multiple versions of a model with different number of clusters, the version which minimizes the Davies-Boudin Index is considered best."
    sql: ${TABLE}.davies_bouldin_index ;;
    value_format_name: decimal_4
  }

  dimension: mean_squared_distance {
    type: number
    description: "The lower the value, the better the cluster solution. A goal of k-means clustering is to minimize the distance of any data point and its cluster center (the 'tightness' inside centroids)."
    sql: ${TABLE}.mean_squared_distance ;;
    value_format_name: decimal_4
  }
}
