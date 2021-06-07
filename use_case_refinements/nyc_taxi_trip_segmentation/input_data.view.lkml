include: "/views/input_data.view"

view: +input_data {
  derived_table: {
    sql: SELECT CONCAT(pickup_datetime, pickup_latitude, pickup_longitude) as trip_id
        ,vendor_id
        ,DATETIME_DIFF(dropoff_datetime, pickup_datetime, second) AS duration_seconds
        ,DATETIME_DIFF(dropoff_datetime, pickup_datetime, minute) AS duration_minutes
        , IF
            (EXTRACT(DAYOFWEEK
              FROM
                pickup_datetime) in (1,7),
              "weekend",
              "weekday") AS weekday_or_weekend
        ,extract(hour from pickup_datetime) as hour_of_day
        , case when
            EXTRACT(hour FROM pickup_datetime) between 0 and 5 then "12AM to 6AM"
            when EXTRACT(hour FROM pickup_datetime) between 6 and 11 then "6AM to 12PM"
            when EXTRACT(hour FROM pickup_datetime) between 12 and 17 then "12PM to 6PM"
            when EXTRACT(hour FROM pickup_datetime) between 18 and 23 then "6PM to 12AM"
            end as hour_of_day_group
        ,pickup_datetime
        ,dropoff_datetime
        ,rate_code
        ,passenger_count
        ,trip_distance
        ,payment_type
        ,fare_amount
        ,tip_amount
        ,total_amount
        ,safe_divide(tip_amount,fare_amount) as tip_percent
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

  dimension_group: pickup_datetime {
    type: time
    sql: ${TABLE}.pickup_datetime ;;
  }

  dimension_group: dropoff_datetime {
    type: time
    sql: ${TABLE}.dropoff_datetime ;;
  }

  # dimension: pickup_longitude {
  #   type: number
  #   sql: ${TABLE}.pickup_longitude ;;
  # }

  # dimension: pickup_latitude {
  #   type: number
  #   sql: ${TABLE}.pickup_latitude ;;
  # }

  # dimension: dropoff_longitude {
  #   type: number
  #   sql: ${TABLE}.dropoff_longitude ;;
  # }

  # dimension: dropoff_latitude {
  #   type: number
  #   sql: ${TABLE}.dropoff_latitude ;;
  # }

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

  # dimension: extra {
  #   type: number
  #   sql: ${TABLE}.extra ;;
  #   value_format_name: usd
  # }

  # dimension: mta_tax {
  #   label: "MTA Tax"
  #   type: number
  #   sql: ${TABLE}.mta_tax ;;
  #   value_format_name: usd
  # }

  # dimension: imp_surcharge {
  #   label: "Improvement Surcharge"
  #   type: number
  #   sql: ${TABLE}.imp_surcharge ;;
  #   value_format_name: usd
  # }

  dimension: tip_amount {
    type: number
    sql: ${TABLE}.tip_amount ;;
    value_format_name: usd
  }

  # dimension: tolls_amount {
  #   type: number
  #   sql: ${TABLE}.tolls_amount ;;
  #   value_format_name: usd
  # }

  dimension: total_amount {
    type: number
    sql: ${TABLE}.total_amount ;;
    value_format_name: usd
  }

  # dimension: store_and_fwd_flag {
  #   type: string
  #   sql: ${TABLE}.store_and_fwd_flag ;;
  # }


  # COUNT MEASURES

  measure: trip_count {
    label: "COUNT of Trips"
    group_label: "COUNTS"
    type: count
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

  # measure: extra_sum {
  #   label: "SUM of Extra"
  #   group_label: "SUMS"
  #   type: sum
  #   sql: ${extra} ;;
  #   value_format_name: usd
  # }

  # measure: mta_tax_sum {
  #   label: "SUM of MTA Tax"
  #   group_label: "SUMS"
  #   type: sum
  #   sql: ${mta_tax} ;;
  #   value_format_name: usd
  # }

  # measure: imp_surcharge_sum {
  #   label: "SUM of Improvement Surcharge"
  #   group_label: "SUMS"
  #   type: sum
  #   sql: ${imp_surcharge} ;;
  #   value_format_name: usd
  # }

  measure: tip_amount_sum {
    label: "SUM of Tip Amount"
    group_label: "SUMS"
    type: sum
    sql: ${tip_amount} ;;
    value_format_name: usd
  }

  # measure: tolls_amount_sum {
  #   label: "SUM of Tolls Amount"
  #   group_label: "SUMS"
  #   type: sum
  #   sql: ${tolls_amount} ;;
  #   value_format_name: usd
  # }

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

  # measure: extra_average {
  #   label: "AVG of Extra"
  #   group_label: "AVERAGES"
  #   type: average
  #   sql: ${extra} ;;
  #   value_format_name: usd
  # }

  # measure: mta_tax_average {
  #   label: "AVG of MTA Tax"
  #   group_label: "AVERAGES"
  #   type: average
  #   sql: ${mta_tax} ;;
  #   value_format_name: usd
  # }

  # measure: imp_surcharge_average {
  #   label: "AVG of Improvement Surcharge"
  #   group_label: "AVERAGES"
  #   type: average
  #   sql: ${imp_surcharge} ;;
  #   value_format_name: usd
  # }

  measure: tip_amount_average {
    label: "AVG of Tip Amount"
    group_label: "AVERAGES"
    type: average
    sql: ${tip_amount} ;;
    value_format_name: usd
  }

  # measure: tolls_amount_average {
  #   label: "AVG of Tolls Amount"
  #   group_label: "AVERAGES"
  #   type: average
  #   sql: ${tolls_amount} ;;
  #   value_format_name: usd
  # }

  measure: total_amount_average {
    label: "AVG of Total Amount"
    group_label: "AVERAGES"
    type: average
    sql: ${total_amount} ;;
    value_format_name: usd
  }
}
