include: "/explores/model_name_suggestions.explore"

view: model_name {
  label: "[2] BQML: Name Your Model"
  derived_table: {
    sql: SELECT '{% parameter select_model_name %}' AS model_name ;;
  }

  parameter: select_model_name {
    label: "BQML Model Name (REQUIRED)"
    description: "Enter a unique name to create a new BQML model or select an existing model to use in your analysis"
    type: unquoted
    suggest_explore: model_name_suggestions
    suggest_dimension: model_info.model_name
    suggest_persist_for: "0 minutes"
  }
}
