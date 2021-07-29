project_name: "block-bqml-k-means"

constant: CONNECTION_NAME {
  value: "bigquery_publicdata_standard_sql"
  export: override_required
}

constant: looker_temp_dataset_name {
  value: "looker_scratch_3"
  export: override_required
}
