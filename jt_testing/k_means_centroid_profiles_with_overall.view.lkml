view: k_means_centroid_profiles_with_overall {
  derived_table: {
    sql: with cf as (select  k_means_centroids.centroid_id  AS centroid_id
        ,k_means_centroids.feature as feature
        ,k_means_centroids.numerical_value as feature_value
        ,centroid_categorical_value.category as category
        ,centroid_categorical_value.value as category_value
        ,concat(k_means_centroids.feature,case when centroid_categorical_value.category is not null then concat(': ',centroid_categorical_value.category) else '' end)   AS feature_category

        ,coalesce(k_means_centroids.numerical_value,centroid_categorical_value.value) as centroid_avg_value
from
--ML.CENTROIDS(MODEL looker_pdts.age_source_revenue)  AS k_means_centroids
ML.CENTROIDS(MODEL @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %}) as k_means_centroids
LEFT JOIN UNNEST(k_means_centroids.categorical_value) as centroid_categorical_value
)
,c1 as (select centroid_id
         ,item_count
         ,item_count / sum(item_count) over (partition by 1) as item_pct_total
         ,sum(item_count) over (partition by 1) as total_item_count
  from (
  select centroid_id
         ,count(distinct item_id) as item_count
  from ML.PREDICT(MODEL @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %},
                      TABLE @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %}_training_data
                    )
 -- from ML.PREDICT(MODEL looker_pdts.age_source_revenue,
--                        TABLE looker_pdts.age_source_revenue_training_data
  --                    )
  group by 1 ) c0
  )
,w as
  (select cf.*
       ,100* (cf.centroid_avg_value / sum(cf.centroid_avg_value * c1.item_pct_total) over (partition by cf.feature_category)) as index_to_avg
       ,(cf.centroid_avg_value / sum(cf.centroid_avg_value * c1.item_pct_total) over (partition by cf.feature_category)) - 1 as pct_diff_from_avg
       ,c1.item_pct_total
       ,c1.item_count
       ,c1.total_item_count
from cf
join c1 on cf.centroid_id = c1.centroid_id
)
--find the overall average as assign to centroid 0
--will union to result set in order to compare centroid to average
,overall as (select 0 as centroid_id
        ,w.feature as feature
        ,sum(w.feature_value * w.item_pct_total) as feature_value
        ,w.category as category
        ,sum(w.category_value * w.item_pct_total) as category_value
        ,w.feature_category

        ,sum(w.centroid_avg_value * w.item_pct_total) as centroid_avg_value
        ,100 as index_to_avg
        ,0 as pct_diff_from_avg
        ,1 as user_pct_total
        ,max(w.total_item_count) as item_count
       from w
       group by 1,2,4,6,8,9
)

select * from overall
union all
select * except (total_item_count) from w
 ;;
  }

  dimension: pk {
    primary_key: yes
    sql: concat(${centroid_id},${feature_category}) ;;
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

  dimension: feature_value {
    type: number
    sql: ${TABLE}.feature_value ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: category_value {
    type: number
    sql: ${TABLE}.category_value ;;
  }

  dimension: feature_category {
    type: string
    sql: ${TABLE}.feature_category ;;
  }

  dimension: centroid_avg_value {
    type: number
    sql: ${TABLE}.centroid_avg_value ;;
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
    sql: ${centroid_avg_value} ;;
    value_format_name: decimal_2
  }

  measure: centroid_value_compared_to_avg_label_avg {
    label: " " #hide label for better appearance in table
    type: average
    sql: ${pct_diff_from_avg} ;;
    #html: {{ row [ 'k_means_centroid_profiles_with_overall.centroid_value' ] }} ;;
    html: {{ centroid_value._rendered_value }} ;;
  }

  set: detail {
    fields: [
      centroid_id,
      feature,
      feature_value,
      category,
      category_value,
      feature_category,
      centroid_avg_value,
      index_to_avg,
      pct_diff_from_avg
    ]
  }
}
