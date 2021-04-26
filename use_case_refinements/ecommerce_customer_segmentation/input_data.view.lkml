include: "/views/input_data.view"

view: +input_data {
  derived_table: {
    sql:  SELECT * EXCEPT(id,user_id), users.id as user_id
          FROM `looker-private-demo.ecomm.users` AS users
          LEFT JOIN `advanced-analytics-accelerator.looker_pdts.7L_advanced_analytics_accelerator_user_order_facts` AS user_order_facts
              ON users.id = user_order_facts.user_id
    ;;
  }
}
