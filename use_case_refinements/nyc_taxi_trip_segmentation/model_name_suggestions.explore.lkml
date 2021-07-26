include: "/explores/model_name_suggestions.explore"

explore: +model_name_suggestions {
  sql_always_where: ${model_info.explore} = 'nyc_taxi_trip_segmentation' ;;
}
