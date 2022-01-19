#Anomalies are identified based on the value of each input data point's normalized distance to its nearest cluster, which, if exceeds a threshold determined by the contamination value, is identified as an anomaly.

view: k_means_detect_anomalies {
  label: "[9] BQML: Anomaly Detection"

  # ML.DETECT_ANOMALIES(MODEL `sandbox.taxi_trip_types_k_means_model_nyc_taxi_trip_segmentation`,
  #   STRUCT(0.01 AS contamination),
  #   TABLE `sandbox.taxi_trip_types_k_means_training_data_nyc_taxi_trip_segmentation`)



  sql_table_name: ML.DETECT_ANOMALIES(MODEL @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %}_k_means_model_{{ _explore._name }} ,
                  STRUCT({% parameter set_contamination_threshold %} AS contamination),
                  TABLE @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %}_k_means_training_data_{{ _explore._name }}
                  )  ;;



  parameter: set_contamination_threshold {
    label: "Contamination Threshold (optional)"
    description: "Set the contamination threshold (value >= 0 and <= 0.5). The default value is 0.02. For example, a contamination value of 0.02 means that the top 2% of descending normalized distance from the training data will be used as the cut-off threshold. If the normalized distance for a data point exceeds the contamination threshold, then it is identified as an anomaly."
    type: number
    default_value: "0.02"
  }

  dimension: item_id {
    type: string
    primary_key: yes
    sql: ${TABLE}.item_id  ;;
  }

  dimension: centroid_id {
    label: "Nearest Centroid"
    type: number
    sql: ${TABLE}.CENTROID_ID ;;
  }

  dimension: is_anomaly {
    type: yesno
    description: "Anomalies are identified based on the value of each input data point's normalized distance to its nearest cluster, which, if exceeds a threshold determined by the contamination value, is identified as an anomaly"
    sql: ${TABLE}.is_anomaly ;;
  }

  dimension: normalized_distance {
    type: number
    description: "Normalized distance of data point to nearest cluster centroid."
    sql: ${TABLE}.normalized_distance ;;
    value_format_name: decimal_4
  }

  measure: total_item_count {
    type: count
  }

  measure: total_anomaly_count {
    description: "Count of data points classified as an anomaly"
    type: count
    filters: [is_anomaly: "Yes"]
  }

  measure: anomaly_percent {
    description: "Percent of data points classified as an anomaly"
    type: average
    sql: case when ${is_anomaly} then 1 else 0 end ;;
    value_format_name: percent_1
  }

  measure: min_normalized_distance {
    type: min
    sql: ${normalized_distance};;
    value_format_name: decimal_4
  }

  measure: max_normalized_distance {
    type: max
    sql: ${normalized_distance};;
    value_format_name: decimal_4
  }

  measure: average_normalized_distance {
    type: average
    sql: ${normalized_distance};;
    value_format_name: decimal_4
  }

}
