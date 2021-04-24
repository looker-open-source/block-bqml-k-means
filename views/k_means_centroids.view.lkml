view: k_means_centroids {
  label: "[7] BQML: Centroids"

  sql_table_name: ML.CENTROIDS(MODEL @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %}_k_means_model) ;;

  dimension: centroid_id {
    primary_key: yes
    type: number
    label: "Nearest Centroid"
    sql: coalesce(${TABLE}.centroid_id,0) ;;
  }

  dimension: feature {
    type: string
    sql: ${TABLE}.feature ;;
  }

  dimension: numerical_value {
    hidden: yes
    type: number
    sql: ${TABLE}.numerical_value ;;
  }

  dimension: categorical_value {
    hidden: yes
    type: string
    sql: ${TABLE}.categorical_value ;;
  }
}

view: categorical_value {
  label: "[7] BQML: Centroids"

  dimension: centroid_category_id {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${k_means_centroids.centroid_id}, ${k_means_centroids.feature}, coalesce(${category},'n/a')) ;;
  }

  dimension: category {
  }

  dimension: value {
    hidden: yes
  }

  dimension: feature_category {
    label: "Feature and Category"
    type: string
    hidden: yes #user will select from k_means_centroid_profiles
    sql:  CONCAT(${k_means_centroids.feature},
            CASE
              WHEN ${category} IS NOT NULL THEN CONCAT(': ', ${category})
              ELSE ''
            END) ;;
  }

  dimension: feature_category_value {
    label: "Value"
    description: "Nearest Centroid Average Value"
    type: number
    sql: COALESCE(${k_means_centroids.numerical_value}, ${value}) ;;
  }
}