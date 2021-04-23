view: jt_k_means_centroid_feature {
  label: "[7] BQML: Centroids"

  sql_table_name: ML.CENTROIDS(MODEL @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %}) ;;

  dimension: centroid_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.centroid_id ;;
  }

  dimension: feature {
    type: string
    sql: ${TABLE}.feature ;;
  }

  dimension: numerical_value {
    type: number
    sql: ${TABLE}.numerical_value ;;
  }

  dimension: k_means_centroid_category_values {
    hidden: yes
    type: string
    sql: ${TABLE}.categorical_value ;;
  }
}

view: jt_k_means_centroid_category_values {
  label: "[7] BQML: Centroids"

  dimension: centroid_category_id {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${jt_k_means_centroids.centroid_id}, ${jt_k_means_centroids.feature}, coalesce(${category},'n/a')) ;;
  }

  dimension: category {
    #group_label: "Categorical Feature Values"
  }

  dimension: feature_category {
    group_label: "Combined Feature Values"
    label: "Feature: Category"
    type: string
    sql:  CONCAT(${jt_k_means_centroids.feature},
            CASE
              WHEN ${category} IS NOT NULL THEN CONCAT(': ', ${category})
              ELSE ''
            END) ;;
  }

  dimension: value {
    group_label: "Categorical Feature Values"
    hidden: yes
  }

  dimension: feature_category_value {
    #group_label: "Combined Feature Values"
    label: "Feature: Category Value"
    type: number
    sql: COALESCE(${jt_k_means_centroids.numerical_value}, ${value}) ;;
  }
}
