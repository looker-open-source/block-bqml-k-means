include: "/views/input_data.view"

view: +input_data {
  derived_table: {
    sql:  SELECT * EXCEPT(id,user_id), users.id as user_id
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

  measure: count {
    type: count
  }
}
