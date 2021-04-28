############################################################################################################################
# Logic to generate the weighted average mean for each feature_category in k-means model
# Then compare each centroid to that weighted average and compute percent difference from average and index value to average
# Values can then be used in visualization to highlight the differences
# also UNION the overall weighted average to the Centroids Profile with centroid_id = 0
############################################################################################################################

#combine centroid values from numerical and categorical variables
view: k_means_centroid_feature_category {
  derived_table: {
    sql:  SELECT k_means_centroids.centroid_id AS centroid_id
          , CONCAT(k_means_centroids.feature,
          CASE
          WHEN categorical_value.category IS NOT NULL THEN CONCAT(': ', categorical_value.category)
          ELSE ''
          END) AS feature_category
          , COALESCE(k_means_centroids.numerical_value, categorical_value.value) AS value
          , case when categorical_value.category IS NOT NULL then 1 else 0 end as is_categorical
          FROM ${k_means_centroids.SQL_TABLE_NAME} AS k_means_centroids
          LEFT JOIN UNNEST(k_means_centroids.categorical_value) as categorical_value
    ;;
  }
}

#find number of observations by centroid and compute % of Total for use as a weighting value for overall averages
view: k_means_centroid_item_count {
  label: "[8] BQML: Centroids"

  derived_table: {
    sql:  SELECT centroid_id
            , item_count
            , item_count / sum(item_count) OVER () AS item_pct_total
          FROM (SELECT CENTROID_ID AS centroid_id
                , count(distinct item_id) AS item_count
                FROM ${k_means_predict.SQL_TABLE_NAME}
                GROUP BY 1) a
    ;;
  }

  dimension: centroid_id {
    label: "Nearest Centroid"
    hidden: yes
    primary_key: yes
  }

  dimension: item_count {
    type: number
    description: "Number of Observations in Nearest Centroid"
    hidden: no
  }

  dimension: item_pct_total {
    label: "Percent of Total Items"
    description: "Nearest Centroid Percent of Total Observations in Training Set"
    type: number
    sql: ${TABLE}.item_pct_total ;;
    value_format_name: percent_1
  }
}

#find the weighted average value by feature_category (weight each centroid by % of total in training set)
view: k_means_overall_feature_category {
  derived_table: {
    sql:
      select
        0 as centroid_id
        ,cfc.feature_category
        ,cfc.is_categorical
        ,sum(cfc.value * cc.item_pct_total) as value
        ,max(cc.item_count) as item_count
      from ${k_means_centroid_feature_category.SQL_TABLE_NAME} as cfc
      join ${k_means_centroid_item_count.SQL_TABLE_NAME} as cc on cfc.centroid_id = cc.centroid_id
      group by 1,2, 3
      ;;
  }
}

view: k_means_centroids_indexed_values {
  label: "[8] BQML: Centroids"

  derived_table: {
    sql:  SELECT k_means_centroid_feature_category.centroid_id AS centroid_id
                , k_means_centroid_feature_category.feature_category AS feature_category
                , k_means_centroid_feature_category.value AS value
                , k_means_centroid_feature_category.is_categorical as is_categorical
                , 100 * (value / SUM(value * k_means_centroid_item_count.item_pct_total) OVER (PARTITION BY k_means_centroid_feature_category.feature_category)) AS index_to_weighted_avg
                , (value / SUM(value * k_means_centroid_item_count.item_pct_total) OVER (PARTITION BY k_means_centroid_feature_category.feature_category)) - 1 AS pct_diff_from_training_set_weighted_avg
          FROM ${k_means_centroid_feature_category.SQL_TABLE_NAME} AS k_means_centroid_feature_category
          LEFT JOIN ${k_means_centroid_item_count.SQL_TABLE_NAME} AS k_means_centroid_item_count
            ON k_means_centroid_feature_category.centroid_id = k_means_centroid_item_count.centroid_id

          UNION ALL
             select centroid_id
                    ,feature_category
                    ,value
                    ,is_categorical
                    ,100 as index_to_avg
                    ,0 as pct_diff_from_avg
             from ${k_means_overall_feature_category.SQL_TABLE_NAME}
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

  dimension: nearest_centroid_label {
    type: string
    sql: case when ${centroid_id} = 0 then "Overall Weighted Average" else cast(${centroid_id} as string) end ;;
  }

  dimension: nearest_centroid_label_with_pct_of_total {
    type: string
    sql: case when ${centroid_id} = 0 then "Overall Weighted Average" else cast(${centroid_id} as string) end ;;
    html: {% if centroid_id._value == 0 %}
    {{rendered_value}}
          {% else %}
        <a style="color:#003f5c;font-size:16px"> <b> {{rendered_value}} </b> </a>     <a style="font-size: 10px">({{ k_means_centroid_item_count.item_pct_total._rendered_value }})
          {% endif %};;
  }
  #  <a style="color:#003f5c;font-size:16px"> <b> {{rendered_value}} </b> </a> <br><a style="font-size: 10px">({{ k_means_centroid_item_count.item_pct_total._rendered_value }})

  dimension: feature_category {
    hidden: no
    label: "Feature and Category"
  }

  dimension: is_categorical {
    type: yesno
    hidden: yes
    sql: ${TABLE}.is_categorical = 1 ;;
  }
  dimension: value {
    type: number
    hidden: yes
  }
  dimension: index_to_weighted_avg {
    type: number
    description: "(Centroid Average / Traning Set Weighted Average) * 100"
    hidden: yes
  }

  dimension: pct_diff_from_training_set_weighted_avg {
    type: number
    hidden: yes
    label: "Percent Difference from Average"
    description: "(Centroid Average / Training Set Weighted Average) - 1"
    value_format_name: percent_2
  }

  measure: pct_diff_from_weighted_avg {
    type: average
    description: "(Centroid Average / Training Set Weighted Average) - 1"
    sql: ${pct_diff_from_training_set_weighted_avg} ;;
    value_format_name: percent_1
  }

  measure: centroid_value {
    type: average
    label: "Nearest Centroid Value"
    description: "Nearest Centroid Average Value"
    sql: case when ${is_categorical} then ${value} * 100
          else ${value} end;;
    value_format_name: decimal_2
  }

#for highlight chart, plot pct_diff_from_avg but display centroid_value._rendered_value
  measure: centroid_value_highlight {
    label: "Value "
    description: "Use to Highlight which features are driving each cluster. Underlying value is Percent Difference from Weighted Average for conditional formatting while the Centroid Value is displayed."
    type: average
    sql: ${pct_diff_from_training_set_weighted_avg} ;;
    html: {% if is_categorical._value == 'Yes' %}{{ centroid_value._rendered_value | round:1 }}%
        {% else %} {{ centroid_value._rendered_value }}
        {% endif %};;
  #html: {{ centroid_value._rendered_value }} ;;
  #times - multiplication e.g {{ 5 | times:4 }} #=> 20
    }

}
