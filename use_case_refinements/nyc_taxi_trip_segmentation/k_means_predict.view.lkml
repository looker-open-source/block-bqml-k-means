include: "/views/k_means_predict.view"

view: +k_means_predict {
  dimension: item_id {
    label: "Trip ID"
  }
}
