view: k_means_predict {
  label: "[6] BQML: Predictions"

  sql_table_name: ML.PREDICT(MODEL @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %},
                      TABLE @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %}_training_data
                    )
  ;;

  dimension: item_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.item_id ;;
  }

  dimension: centroid_id {
    label: "Nearest Centroid"
    type: number
    sql: ${TABLE}.CENTROID_ID ;;
  }

  dimension: nearest_centroids_distance {
    hidden: yes
    type: string
    sql: ${TABLE}.NEAREST_CENTROIDS_DISTANCE ;;
  }

  measure: item_count {
    type: count
    description: "Number of Observations in Nearest Centroid"
  }

  measure: item_count_percent_of_total {
    type: percent_of_total
    description: "Nearest Centroid Percent of Total Observations in Training Set"
    sql: ${item_count} ;;
  }

  measure: total_item_count {
    type: number
    description: "Total Number of Observations in Training Set"
    # sql: (select count(distinct item_id) from ML.PREDICT(MODEL @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %},
    #                   TABLE @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %}_training_data
    #                 ))  ;;
    sql: (select count(item_id) from ${k_means_predict.SQL_TABLE_NAME}) ;;
  }

}

view: nearest_centroids_distance {
  label: "[6] BQML: Predictions"

  dimension: item_centroid_id {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${k_means_predict.item_id}, ${centroid_id}) ;;
  }

  dimension: centroid_id {
    group_label: "Centroid Distances"
    label: "Centroid"
    type: number
    sql: ${TABLE}.CENTROID_ID ;;
  }

  dimension: distance {
    group_label: "Centroid Distances"
    type: number
    sql: ${TABLE}.DISTANCE ;;
  }
}
