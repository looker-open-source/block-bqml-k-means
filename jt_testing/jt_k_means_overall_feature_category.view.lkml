#derive overall feature category weighted average using centroid item count percent of total as weight
#this table will be unioned with centroids_feature_category in order to allow for comparison of each
#centroid feature category profile to overall average
#will be used on visualization to show which features are driving each centroid

view: jt_k_means_overall_feature_category {
 derived_table: {
   sql:
      select
        0 as centroid_id
        ,cfc.feature
        ,cfc.category
        ,cfc.feature_category
        ,sum(cfc.feature_category_value * cc.item_count_percent_of_total) as feature_category_value
        ,max(cc.total_item_count) as item_count
      from ${jt_k_means_centroid_feature_category.SQL_TABLE_NAME} as cfc
      join ${jt_k_means_centroid_counts.SQL_TABLE_NAME} as cc on cfc.centroid_id = cc.centroid_id
      group by 1,2,3,4
      ;;
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
    sql: concat(${centroid_id},${feature},${category}) ;;
  }

  dimension: feature_category {
    type: string
    sql: ${TABLE}.feature_category ;;
  }

  dimension: feature_category_value {
    type: number
    sql: ${TABLE}.feature_category_value ;;
  }

  dimension: item_count {
    type: number
    sql: ${TABLE}.item_count ;;
  }

}
