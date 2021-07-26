view: k_means_evaluate_history {
  label: "[6] BQML: Evaluation Metrics"

  sql_table_name: @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %}_k_means_evaluation_metrics_{{ _explore._name }} ;;

  dimension: item_id {
    group_label: "Metric History"
    type: string
    description: "Item or observation which was clustered."
    sql: ${TABLE}.item_id ;;
  }

  dimension: features {
    group_label: "Metric History"
    type: string
    description: "Metrics or attributes used to create the clusters"
    sql: ${TABLE}.features ;;
  }

  dimension: number_of_clusters {
    group_label: "Metric History"
    type: string
    sql: ${TABLE}.number_of_clusters ;;
  }

  dimension_group: created_at {
    group_label: "Metric History"
    type: time
    timeframes: [raw, time]
    sql: ${TABLE}.created_at ;;
  }

  dimension: davies_bouldin_index {
    group_label: "Metric History"
    type: number
    description: "The lower the value, the better the separation of the centroids and the 'tightness' inside the centroids. If creating multiple versions of a model with different number of clusters, the version which minimizes the Davies-Boudin Index is considered best."
    sql: ${TABLE}.davies_bouldin_index ;;
    value_format_name: decimal_4
  }

  dimension: mean_squared_distance {
    group_label: "Metric History"
    type: number
    description: "The lower the value, the better the cluster solution. A goal of k-means clustering is to minimize the distance of any data point and its cluster center (the 'tightness' inside centroids)."
    sql: ${TABLE}.mean_squared_distance ;;
    value_format_name: decimal_4
  }
}
