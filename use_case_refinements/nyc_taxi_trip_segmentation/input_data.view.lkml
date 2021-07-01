include: "/views/input_data.view"

view: input_data_ecommerce_customer_segmentation {
  extends: [input_data]
  derived_table: {
    sql:  SELECT CONCAT(pickup_datetime, pickup_latitude, pickup_longitude) as trip_id
              , vendor_id
              , DATETIME_DIFF(dropoff_datetime, pickup_datetime, second) AS duration_seconds
              , DATETIME_DIFF(dropoff_datetime, pickup_datetime, minute) AS duration_minutes
              , IF
                  (EXTRACT(DAYOFWEEK
                    FROM
                      pickup_datetime) in (1,7),
                    "weekend",
                    "weekday") AS weekday_or_weekend
              , extract(hour from pickup_datetime) as hour_of_day
              , case when
                  EXTRACT(hour FROM pickup_datetime) between 0 and 5 then "12AM to 6AM"
                  when EXTRACT(hour FROM pickup_datetime) between 6 and 11 then "6AM to 12PM"
                  when EXTRACT(hour FROM pickup_datetime) between 12 and 17 then "12PM to 6PM"
                  when EXTRACT(hour FROM pickup_datetime) between 18 and 23 then "6PM to 12AM"
                  end as hour_of_day_group
              , case when
                  EXTRACT(hour FROM pickup_datetime) between 0 and 5 then 1
                  when EXTRACT(hour FROM pickup_datetime) between 6 and 11 then 2
                  when EXTRACT(hour FROM pickup_datetime) between 12 and 17 then 3
                  when EXTRACT(hour FROM pickup_datetime) between 18 and 23 then 4
                  end as hour_of_day_group_sort_order
              , pickup_datetime
              , dropoff_datetime
              , rate_code
              , passenger_count
              , trip_distance
              , payment_type
              , fare_amount
              , tip_amount
              , total_amount
              , safe_divide(tip_amount,fare_amount) as tip_percent
          FROM `nyc-tlc.yellow.trips`
          WHERE ABS(MOD(FARM_FINGERPRINT(CAST(pickup_datetime AS STRING)), 100000)) = 1
                AND
                  trip_distance > 0
                  AND fare_amount >= 2.5 AND fare_amount <= 100.0
                  AND pickup_longitude > -78
                  AND pickup_longitude < -70
                  AND dropoff_longitude > -78
                  AND dropoff_longitude < -70
                  AND pickup_latitude > 37
                  AND pickup_latitude < 45
                  AND dropoff_latitude > 37
                  AND dropoff_latitude < 45
                  AND passenger_count > 0
                  and DATETIME_DIFF(dropoff_datetime, pickup_datetime, minute) < 200
    ;;
  }

  dimension: trip_id {
    label: "Trip ID"
    primary_key: yes
    type: string
  }

  dimension: vendor_id {
    type: string
    sql: ${TABLE}.vendor_id ;;
  }

  dimension_group: pickup {
    type: time
    sql: ${TABLE}.pickup_datetime ;;
  }

  dimension_group: dropoff {
    type: time
    sql: ${TABLE}.dropoff_datetime ;;
  }

  dimension: duration_seconds {
    type: number
    sql: ${TABLE}.duration_seconds ;;
  }

  dimension: duration_minutes {
    type: number
    sql: ${TABLE}.duration_minutes ;;
  }

  dimension: weekday_or_weekend {
    type: string
    sql: ${TABLE}.weekday_or_weekend ;;
  }

  dimension: hour_of_day {
    type: number
    sql: ${TABLE}.hour_of_day ;;
  }

  dimension: hour_of_day_group {
    type: string
    sql: ${TABLE}.hour_of_day_group ;;
    order_by_field: hour_of_day_group_sort_order
  }

  dimension: hour_of_day_group_sort_order {
    type: number
    sql: ${TABLE}.hour_of_day_group_sort_order ;;
  }

  dimension: rate_code {
    type: string
    sql: ${TABLE}.rate_code ;;
  }

  dimension: passenger_count {
    type: number
    sql: ${TABLE}.passenger_count ;;
  }

  dimension: trip_distance {
    type: number
    sql: ${TABLE}.trip_distance ;;
  }

  dimension: payment_type {
    type: string
    sql: ${TABLE}.payment_type ;;
  }

  dimension: fare_amount {
    type: number
    sql: ${TABLE}.fare_amount ;;
    value_format_name: usd
  }

  dimension: tip_amount {
    type: number
    sql: ${TABLE}.tip_amount ;;
    value_format_name: usd
  }

  dimension: total_amount {
    type: number
    sql: ${TABLE}.total_amount ;;
    value_format_name: usd
  }

  dimension: title_selected_segment_trips {
    type: string
    hidden: yes
    sql: concat("Segment ", ${k_means_predict.centroid_id} ,": Percent of Daily Trips by Time of Day");;

  }

  dimension: title_all_trips {
    type: string
    hidden: yes
    sql: "All Trips: Percent of Daily Trips by Time of Day";;

  }

  dimension: cash_or_credit {
    type: string
    sql: case when lower(${payment_type}) in ('cas','csh') then 'Cash'
              when lower(${payment_type}) in ('cre','crd') then 'Credit'
              end;;
  }


  # COUNT MEASURES

  measure: trip_count {
    label: "COUNT of Trips"
    group_label: "COUNTS"
    type: count
  }

  measure: weekend_trip_count {
    label: "COUNT of Trips during Weekend (Fri / Sat)"
    group_label: "COUNTS"
    hidden: yes
    type: count
    filters: [weekday_or_weekend: "weekend"]
  }

  measure: after_midnight_trip_count {
    label: "COUNT of Trips between 12AM to 6AM"
    group_label: "COUNTS"
    hidden: yes
    type: count
    filters: [hour_of_day_group: "12AM to 6AM"]
  }

  # SUM MEASURES

  measure: passenger_count_sum {
    label: "SUM of Passenger Count"
    group_label: "SUMS"
    type: sum
    sql: ${passenger_count} ;;
  }

  measure: trip_distance_sum {
    label: "SUM of Trip Distance"
    group_label: "SUMS"
    type: sum
    sql: ${trip_distance} ;;
    value_format_name: decimal_2
  }

  measure: fare_amount_sum {
    label: "SUM of Fare Amount"
    group_label: "SUMS"
    type: sum
    sql: ${fare_amount} ;;
    value_format_name: usd
  }

  measure: tip_amount_sum {
    label: "SUM of Tip Amount"
    group_label: "SUMS"
    type: sum
    sql: ${tip_amount} ;;
    value_format_name: usd
  }

  measure: total_amount_sum {
    label: "SUM of Total Amount"
    group_label: "SUMS"
    type: sum
    sql: ${total_amount} ;;
    value_format_name: usd
  }

  # AVERAGE MEASURES

  measure: passenger_count_average {
    label: "AVG of Passenger Count"
    group_label: "AVERAGES"
    type: average
    sql: ${passenger_count} ;;
    value_format_name: decimal_2
  }

  measure: trip_distance_average {
    label: "AVG of Trip Distance"
    group_label: "AVERAGES"
    type: average
    sql: ${trip_distance} ;;
    value_format_name: decimal_2
  }

  measure: fare_amount_average {
    label: "AVG of Fare Amount"
    group_label: "AVERAGES"
    type: average
    sql: ${fare_amount} ;;
    value_format_name: usd
  }

  measure: tip_amount_average {
    label: "AVG of Tip Amount"
    group_label: "AVERAGES"
    type: average
    sql: ${tip_amount} ;;
    value_format_name: usd
  }

  measure: total_amount_average {
    label: "AVG of Total Amount"
    group_label: "AVERAGES"
    type: average
    sql: ${total_amount} ;;
    value_format_name: usd
  }

  measure: duration_minutes_average {
    label: "AVG of Duration (minutes)"
    group_label: "AVERAGES"
    type: average
    sql: ${duration_minutes} ;;
    value_format_name: decimal_1
  }

  # PCT OF TOTAL MEASURES

  measure: pct_trips_weekend {
    label: "Percent of Trips during Weekend"
    group_label: "PCT OF TOTAL"
    type: number
    sql: safe_divide(${weekend_trip_count},${trip_count}) ;;
    value_format_name: percent_1
  }

  measure: pct_trips_after_midnight {
    label: "Percent of Trips between 12AM and 6AM"
    group_label: "PCT OF TOTAL"
    type: number
    sql: safe_divide(${after_midnight_trip_count},${trip_count}) ;;
    value_format_name: percent_1
  }

  measure: pct_of_trips {
    type: percent_of_total
    sql: ${trip_count} ;;

  }



}
