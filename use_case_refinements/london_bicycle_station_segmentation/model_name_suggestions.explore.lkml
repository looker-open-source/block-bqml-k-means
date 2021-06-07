include: "/explores/model_name_suggestions.explore"

explore: +model_name_suggestions {
  sql_always_where: ${model_info.explore} = 'london_bicycle_station_segmentation' ;;
}
