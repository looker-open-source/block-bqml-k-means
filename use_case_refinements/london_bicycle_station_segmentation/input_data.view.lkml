include: "/views/input_data.view"

### for this example, data is pulled from the BigQuery Public dataset for London Bicycle Hires
### The London Bicycle Hires data contains the number of hires of London's Santander Cycle Hire Scheme from 2015 to mid-June 2017

### bike stations will be clustered based on the following attributes calculated for year 2015:
#     Avg Duration of rentals
#     Number of trips per day
#     Max Distance from city center
#

### additional bike station metrics will be used for profiling:
#    Percent of Trips during Weekend (Sat - Sun)
#    Percent of Trips Roundtrip (i.e, start/end at same station)

### This example uses billable components of Cloud Platform, including:
#     BigQuery
#     BigQuery ML
#     For information on BigQuery costs, see the BigQuery pricing page (https://cloud.google.com/bigquery/pricing).
#     For information on BigQuery ML costs, see the BigQuery ML pricing page (https://cloud.google.com/bigquery-ml/pricing).

### reference: https://cloud.google.com/bigquery-ml/docs/kmeans-tutorial


view: +input_data {
  derived_table: {
    sql:
    SELECT
    station_name,
    AVG(duration) AS duration,
    COUNT(duration) AS num_trips,
    MAX(distance_from_city_center) AS distance_from_city_center,
    count(case when isweekday = 'weekend' then duration end) / count(duration) as pct_trips_weekend,
    count(case when is_returnedSameStation then duration end) / count(duration) as pct_trips_roundtrip
  FROM
    (
  SELECT
    h.start_station_name AS station_name,
    IF
    (EXTRACT(DAYOFWEEK
      FROM
        h.start_date) = 1
      OR EXTRACT(DAYOFWEEK
      FROM
        h.start_date) = 7,
      "weekend",
      "weekday") AS isweekday,
    IF(start_station_name = end_station_name,TRUE,FALSE) is_returnedSameStation,
    h.duration,
    ST_DISTANCE(ST_GEOGPOINT(s.longitude,
        s.latitude),
      ST_GEOGPOINT(-0.1,
        51.5))/1000 AS distance_from_city_center
  FROM
    `bigquery-public-data.london_bicycles.cycle_hire` AS h
  JOIN
    `bigquery-public-data.london_bicycles.cycle_stations` AS s
  ON
    h.start_station_id = s.id
  WHERE
    h.start_date BETWEEN CAST('2015-01-01 00:00:00' AS TIMESTAMP)
    AND CAST('2016-01-01 00:00:00' AS TIMESTAMP) )
  GROUP BY
    station_name

       ;;
  }


  dimension: station_name {
    type: string
    primary_key: yes
    sql: ${TABLE}.station_name ;;
  }

  dimension: duration {
    type: number
    sql: ${TABLE}.duration ;;
  }

  dimension: num_trips {
    type: number
    sql: ${TABLE}.num_trips ;;
  }

  dimension: distance_from_city_center {
    type: number
    sql: ${TABLE}.distance_from_city_center ;;
  }

  dimension: pct_trips_weekend {
    type: number
    sql: ${TABLE}.pct_trips_weekend ;;
  }

  dimension: pct_trips_roundtrip {
    type: number
    sql: ${TABLE}.pct_trips_roundtrip ;;
  }

  measure: station_count {
    type: count
    drill_fields: [detail*]
  }

  measure: avg_duration {
    type: average
    sql: ${duration} ;;
  }

  measure: avg_duration_minutes {
    type: average
    sql: (${duration} / 60) ;;
  }

  measure: avg_num_trips {
    type: average
    sql: ${num_trips} ;;
  }

  measure: avg_distance_from_city_center {
    type: average
    sql: ${distance_from_city_center} ;;
  }

  measure: avg_pct_trips_weekend {
    type: average
    sql: ${pct_trips_weekend} ;;
  }

  measure: avg_pct_trips_roundtrip {
    type: average
    sql: ${pct_trips_roundtrip} ;;
  }


  set: detail {
    fields: [station_name, duration, num_trips, distance_from_city_center]
  }
}
