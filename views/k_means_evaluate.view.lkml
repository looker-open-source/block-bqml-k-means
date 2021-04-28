view: k_means_evaluate {
  label: "[6] BQML: Evaluation Metrics"

  sql_table_name: ML.EVALUATE(MODEL @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %}_k_means_model) ;;

  dimension: davies_bouldin_index {
    type: number
    sql: ${TABLE}.davies_bouldin_index ;;
  }

  dimension: mean_squared_distance {
    type: number
    sql: ${TABLE}.mean_squared_distance ;;
  }
}
