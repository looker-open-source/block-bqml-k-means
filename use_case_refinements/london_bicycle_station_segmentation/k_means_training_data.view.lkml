include: "/views/k_means_training_data.view"

view: +k_means_training_data {

  parameter: select_item_id {
    hidden: yes
    default_value: "station_name"
    allowed_value: {
      value: "station_name"
    }
  }
}
