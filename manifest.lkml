project_name: "block-bqml-k-means"

constant: CONNECTION_NAME {
  value: "advanced_analytics_accelerator"
  export: override_required
}

constant: LOOKER_TEMP_DATASET_NAME {
  value: "looker_scratch"
  export: override_optional
}
