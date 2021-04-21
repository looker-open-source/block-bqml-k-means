#profile each centroid by feature category
#use index to overall (derived as both index value and as pct_diff_from_average) as way to highlight which features drive each centroid
#append overall average means by feature category (call centroid 0) for easy comparison

#view references:
#  k_means_centroid_feature_category
#  k_means_overall_feature_category

view: k_means_centroid_feature_category_profile {
  label: "[7] BQML: Centroids"
  derived_table: {
    sql:
              select
                      cfc.centroid_id
                      ,cfc.feature
                      ,cfc.category
                      ,cfc.feature_category
                      ,cfc.feature_category_value
                      ,100* (cfc.feature_category_value / ofc.feature_category_value) as index_to_avg
                      ,(cfc.feature_category_value / ofc.feature_category_value) - 1 as pct_diff_from_avg
                     -- ,cc.item_count
                    --  ,cc.item_count_percent_of_total
                    --  ,cc.total_item_count
              from
              --ML.CENTROIDS(MODEL looker_pdts.age_source_revenue)  AS k_means_centroids
              ${k_means_centroid_feature_category.SQL_TABLE_NAME} as cfc
             JOIN ${k_means_overall_feature_category.SQL_TABLE_NAME} as ofc on cfc.feature_category = ofc.feature_category
            -- JOIN ${k_means_centroid_counts.SQL_TABLE_NAME} cc on cfc.centroid_id = cc.centroid_id

             UNION ALL
             select centroid_id
                    ,feature
                    ,category
                    ,feature_category
                    ,feature_category_value
                    ,100 as index_to_avg
                    ,0 as pct_diff_from_avg
             from ${k_means_overall_feature_category.SQL_TABLE_NAME}


              ;;
  }



dimension: centroid_id {
  type: number
  sql: ${TABLE}.centroid_id ;;
}

dimension: centroid_label {
  type: string
  sql: case  ${centroid_id} when 0 then "Overall Average" else cast(${centroid_id} as string) end ;;
}

dimension: feature {
  type: string
  sql: ${TABLE}.feature ;;
}

dimension: category {
  type: string
  sql: ${TABLE}.category ;;
}

dimension: is_categorical {
  type: yesno
  hidden: yes
  sql: ${category} is not null ;;
}

dimension: centroid_category_id {
  type: string
  hidden: yes
  primary_key: yes
  sql: concat(${centroid_id},${feature},coalesce(${category},'n/a')) ;;
}

dimension: feature_category {
  type: string
  sql: ${TABLE}.feature_category ;;
}

dimension: feature_category_value {
  type: number
  sql: ${TABLE}.feature_category_value ;;
}

dimension: index_to_avg {
  type: number
  sql: ${TABLE}.index_to_avg ;;
}

dimension: pct_diff_from_avg {
  type: number
  sql: ${TABLE}.pct_diff_from_avg ;;
}

measure: centroid_value_compared_to_avg {
  type: average
  sql: ${pct_diff_from_avg} ;;
  value_format_name: percent_1
}

measure: centroid_value {
  type: average
  sql: case when ${is_categorical} then ${feature_category_value} * 100
  else ${feature_category_value} end;;
  value_format_name: decimal_2
}

#for highlight chart, plot pct_diff_from_avg but display the _rendered_value
measure: centroid_value_highlight {
  label: " Value "
  type: average
  sql: ${pct_diff_from_avg} ;;
  html: {% if is_categorical._value == 'Yes' %}{{ centroid_value._rendered_value | round:1 }}%
        {% else %} {{ centroid_value._rendered_value }}
        {% endif %};;
  #html: {{ centroid_value._rendered_value }} ;;
  #times - multiplication e.g {{ 5 | times:4 }} #=> 20
}

}
