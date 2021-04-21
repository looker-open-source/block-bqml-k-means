#derive feature category and merge numercial_value and categorical_value in single feature_category_value field


view: k_means_centroid_feature_category {
derived_table: {
        sql:
              select
                      k_means_centroids.centroid_id  AS centroid_id
                      ,k_means_centroids.feature as feature
                      ,centroid_categorical_value.category as category
                      ,CONCAT(k_means_centroids.centroid_id, k_means_centroids.feature, coalesce(centroid_categorical_value.category,'n/a')) as centroid_category_id
                      ,concat(k_means_centroids.feature,
                              case when centroid_categorical_value.category is not null
                              then concat(': ',centroid_categorical_value.category)
                              else '' end
                              )   AS feature_category
                      ,coalesce(k_means_centroids.numerical_value,centroid_categorical_value.value) as feature_category_value
              from
              --ML.CENTROIDS(MODEL @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %})  AS k_means_centroids
              ${k_means_centroids.SQL_TABLE_NAME} as k_means_centroids
              LEFT JOIN UNNEST(k_means_centroids.categorical_value) as centroid_categorical_value
              ;;
      }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: centroid_id {
    type: number
    sql: ${TABLE}.centroid_id ;;
  }

  dimension: feature {
    type: string
    sql: ${TABLE}.feature ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: centroid_category_id {
    type: string
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.centroid_category_id ;;
  }

  dimension: feature_category {
    type: string
    sql: ${TABLE}.feature_category ;;
  }

  dimension: feature_category_value {
    type: number
    sql: ${TABLE}.feature_category_value ;;
  }

  set: detail {
    fields: [
      centroid_id,
      feature,
      category,
      centroid_category_id,
      feature_category,
      feature_category_value
    ]
  }


}
