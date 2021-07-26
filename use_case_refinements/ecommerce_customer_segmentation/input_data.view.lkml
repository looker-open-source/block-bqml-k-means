include: "/views/input_data.view"

view: input_data_ecommerce_customer_segmentation {
  extends: [input_data]
  derived_table: {
    sql:  SELECT * EXCEPT(id,user_id), users.id as user_id
                ,CAST(TIMESTAMP_DIFF(current_timestamp() , users.created_at , DAY) AS INT64) AS days_as_customer
                ,case when CAST(TIMESTAMP_DIFF(current_timestamp() , users.created_at , DAY) AS INT64) <= 90 then 'Yes' else 'No' END as is_new_customer
                ,CAST(TIMESTAMP_DIFF(current_timestamp() , user_order_facts.first_order , DAY) AS INT64) as days_since_first_order
                ,CAST(TIMESTAMP_DIFF(current_timestamp() , user_order_facts.latest_order , DAY) AS INT64) as days_since_latest_order
                ,CASE WHEN (CAST(TIMESTAMP_DIFF(current_timestamp() , user_order_facts.latest_order , DAY) AS INT64))<=90  THEN 'Yes' ELSE 'No' END as has_order_in_past_90_days
                ,case when user_order_facts.lifetime_orders > 1 then TIMESTAMP_DIFF(user_order_facts.latest_order,user_order_facts.first_order , DAY) / user_order_facts.lifetime_orders
                    else TIMESTAMP_DIFF(current_timestamp() , user_order_facts.latest_order , DAY) end as avg_days_between_orders
                ,safe_divide(user_order_facts.lifetime_revenue,user_order_facts.lifetime_orders) as avg_order_revenue
                ,case when user_order_facts.lifetime_orders >= 4 then 'Yes' else 'No' end as has_4p_orders
          FROM `looker-private-demo.ecomm.users` AS users
          LEFT JOIN `advanced-analytics-accelerator.looker_pdts.7L_advanced_analytics_accelerator_user_order_facts` AS user_order_facts
              ON users.id = user_order_facts.user_id
    ;;
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: zip {
    type: string
    sql: ${TABLE}.zip ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension_group: created_at {
    type: time
    sql: ${TABLE}.created_at ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension_group: first_order {
    type: time
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: latest_order {
    type: time
    sql: ${TABLE}.latest_order ;;
  }

  dimension: number_of_distinct_months_with_orders {
    type: number
    sql: ${TABLE}.number_of_distinct_months_with_orders ;;
  }

  dimension: location {
    type: location
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
  }

  dimension: days_as_customer {
    type: number
    sql: ${TABLE}.days_as_customer;;
  }

  dimension: is_new_customer {
    type: yesno
    sql: ${TABLE}.is_new_customer='Yes' ;;
  }

  dimension: days_since_first_order {
    type: number
    sql: ${TABLE}.days_since_latest_order ;;
  }

  dimension: days_since_latest_order {
    type: number
    sql: ${TABLE}.days_since_latest_order ;;
  }

  dimension: has_order_in_past_90_days {
    type: yesno
    sql: ${TABLE}.has_order_in_past_90_days='Yes' ;;
  }

  dimension: avg_days_between_orders {
    type: number
    sql: ${TABLE}.avg_days_between_orders ;;
  }

  dimension: has_4p_orders {
    type: yesno
    sql: ${TABLE}.has_4p_orders='Yes' ;;
  }

  dimension: avg_order_revenue {
    type: number
    sql: ${TABLE}.avg_order_revenue ;;
    value_format_name: usd
  }

  measure: count {
    type: count
  }

  measure: female_count {
    type: count
    hidden: yes
    filters: [gender: "Female"]
  }

  measure: count_with_4p_orders {
    type: count
    hidden: yes
    filters: [has_4p_orders: "Yes"]
  }

  measure: count_with_traffic_source_search {
    type: count
    hidden: yes
    filters: [traffic_source: "Search"]
  }

  measure: count_new_customer {
    type: count
    hidden: yes
    filters: [is_new_customer: "Yes"]
  }

  measure: avg_lifetime_orders {
    type: average
    sql: ${lifetime_orders} ;;
  }

  measure: avg_lifetime_revenue {
    type: average
    sql: ${lifetime_revenue} ;;
  }

  measure: avg_age {
    type: average
    sql: ${age} ;;
  }
  measure: avg_days_since_latest_order {
    type: average
    sql: ${days_since_latest_order} ;;
  }

  measure: avg_days_since_first_order {
    type: average
    sql: ${days_since_first_order} ;;
  }

  measure: avg_days_as_customer {
    type: average
    sql: ${days_since_first_order} ;;
  }
  measure: avg_months_shopped {
    type: average
    sql: ${number_of_distinct_months_with_orders} ;;
  }

  measure: avg_trip_revenue {
    type: average
    sql: ${avg_order_revenue} ;;
  }

  measure: pct_female {
    type: number
    sql: safe_divide(${female_count},${count}) ;;
  }

  measure: pct_with_4p_orders {
    type: number
    sql: safe_divide(${count_with_4p_orders},${count}) ;;
  }

  measure: pct_traffic_source_search {
    type: number
    sql: safe_divide(${count_with_traffic_source_search},${count}) ;;
  }

  measure: pct_new_customer {
    type: number
    sql: safe_divide(${count_new_customer},${count}) ;;
  }

}
