include: "/explores/field_suggestions.explore"

view: k_means_training_data {
  label: "[3] BQML: Select Training Data"

  parameter: select_item_id {
    label: "Select an ID Field (REQUIRED)"
    description: "Choose the field that identifies the items you want to cluster"
    type: unquoted
    suggest_explore: field_suggestions
    suggest_dimension: field_suggestions.column_name
  }

  filter: select_features {
    label: "Select Features (REQUIRED)"
    description: "Choose the attribute fields that you want to use to cluster your data"
    type: string
    suggest_explore: field_suggestions
    suggest_dimension: field_suggestions.column_name
  }
}
