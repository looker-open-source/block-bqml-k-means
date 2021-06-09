include: "/explores/field_suggestions.explore"

view: k_means_training_data {
  label: "[3] BQML: Select Training Data"
  derived_table: {
    persist_for: "1 second"

    create_process: {

      sql_step: CREATE OR REPLACE VIEW @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %}_k_means_input_data_{{ _explore._name }}
                    AS  SELECT * EXCEPT({% parameter select_item_id %})
                          , {% parameter select_item_id %} AS item_id
                        FROM ${input_data.SQL_TABLE_NAME}
      ;;


        sql_step: CREATE OR REPLACE VIEW @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %}_k_means_training_data_{{ _explore._name }}
                    AS  SELECT
                          {% parameter select_item_id %} AS item_id,
                          {% assign features = _filters['select_features'] | sql_quote | remove: '"' | remove: "'" %}
                            {{ features }}
                        FROM ${input_data.SQL_TABLE_NAME}
      ;;
      }
  }

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