include: "/views/model_info.view"

explore: model_name_suggestions {
  sql_always_where: ${model_info.explore} = 'nyc_taxi_trip_segmentation' ;;
  view_name: model_info
  hidden: yes
  persist_for: "0 minutes"
}
