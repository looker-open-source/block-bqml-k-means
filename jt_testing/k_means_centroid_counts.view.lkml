#find the item counts from centroid and compute percent of total
#will use the centroid percent of total as weight to compute overall weighted average

view: k_means_centroid_counts {
  derived_table: {
    sql: select centroid_id
               ,item_count
               ,item_count / sum(item_count) over (partition by 1) as item_count_percent_of_total
               ,sum(item_count) over (partition by 1) as total_item_count
          from (
          select centroid_id
                 ,count(distinct item_id) as item_count
          from ${k_means_predict.SQL_TABLE_NAME}
          group by 1 ) t1
  ;;
  }

  # measure: count {
  #   type: count
  #   drill_fields: [detail*]
  # }

  dimension: centroid_id {
    type: number
    sql: ${TABLE}.centroid_id ;;
  }

  dimension: item_count {
    type: number
    sql: ${TABLE}.item_count ;;
  }

  dimension: item_count_percent_of_total {
    type: number
    sql: ${TABLE}.item_count_percent_of_total ;;
  }

  dimension: total_item_count {
    type: number
    sql: ${TABLE}.total_item_count ;;
  }

  set: detail {
    fields: [centroid_id, item_count, item_count_percent_of_total, total_item_count]
  }
}
