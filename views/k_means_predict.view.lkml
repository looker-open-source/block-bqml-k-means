view: k_means_predict {
  label: "[6] BQML: Predictions"

  sql_table_name: ML.PREDICT(MODEL @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %},
                      TABLE @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %}k_means_training_data
                    )
  ;;

  dimension: item_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.item_id ;;
  }

  dimension: centroid_id {
    label: "Nearest Centroid"
    type: string
    sql: ${TABLE}.CENTROID_ID ;;
  }

  dimension: nearest_centroids_distance {
    hidden: yes
    type: string
    sql: ${TABLE}.NEAREST_CENTROIDS_DISTANCE ;;
  }

  measure: count {
    type: count
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