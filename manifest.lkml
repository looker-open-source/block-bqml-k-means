project_name: "block-bqml-k-means"

constant: CONNECTION_NAME {
  value: "advanced_analytics_accelerator"
  export: override_required
}

constant: looker_temp_dataset_name {
  value: "looker_scratch"
  export: override_optional
}
