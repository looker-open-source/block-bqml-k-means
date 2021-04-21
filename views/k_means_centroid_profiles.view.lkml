view: k_means_centroid_feature_category {
  derived_table: {
    sql:  SELECT k_means_centroids.centroid_id AS centroid_id
          , CONCAT(k_means_centroids.feature,
          CASE
          WHEN categorical_value.category IS NOT NULL THEN CONCAT(': ', categorical_value.category)
          ELSE ''
          END) AS feature_category
          , COALESCE(k_means_centroids.numerical_value, categorical_value.value) AS value
          FROM ${k_means_centroids.SQL_TABLE_NAME} AS k_means_centroids
          LEFT JOIN UNNEST(k_means_centroids.categorical_value) as categorical_value
    ;;
  }
}

view: k_means_centroid_item_count {
  label: "[7] BQML: Centroids"

  derived_table: {
    sql:  SELECT centroid_id
            , item_count
            , item_count / sum(item_count) OVER () AS items_pct_total
          FROM (SELECT CENTROID_ID AS centroid_id
                , count(distinct item_id) AS item_count
                FROM ${k_means_predict.SQL_TABLE_NAME}
                GROUP BY 1) a
    ;;
  }

  dimension: centroid_id {
    hidden: yes
    primary_key: yes
  }

  dimension: item_count {
    type: number
  }

  dimension: items_pct_total {
    label: "Percent of Total Items"
    type: number
    sql: ${TABLE}.items_pct_total ;;
    value_format_name: percent_2
  }
}

view: k_means_centroids_indexed_values {
  label: "[7] BQML: Centroids"

  derived_table: {
    sql:  SELECT k_means_centroid_feature_category.centroid_id AS centroid_id
          , k_means_centroid_feature_category.feature_category AS feature_category
          , k_means_centroid_feature_category.value AS value
          , 100 * (value / SUM(value * k_means_centroid_item_count.items_pct_total) OVER (PARTITION BY k_means_centroid_feature_category.feature_category)) AS indexed_value
          , (value / SUM(value * k_means_centroid_item_count.items_pct_total) OVER (PARTITION BY k_means_centroid_feature_category.feature_category)) - 1 AS pct_diff_from_avg
          FROM ${k_means_centroid_feature_category.SQL_TABLE_NAME} AS k_means_centroid_feature_category
          LEFT JOIN ${k_means_centroid_item_count.SQL_TABLE_NAME} AS k_means_centroid_item_count
            ON k_means_centroid_feature_category.centroid_id = k_means_centroid_item_count.centroid_id
    ;;
  }

  dimension: pk {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${centroid_id}, ${feature_category}) ;;
  }

  dimension: centroid_id {
    hidden: yes
  }

  dimension: feature_category {
    hidden: yes
  }

  dimension: indexed_value {
    type: number
  }

  dimension: pct_diff_from_avg {
    label: "Percent Difference from Average"
    type: number
    value_format_name: percent_2
  }
}
