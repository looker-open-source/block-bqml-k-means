view: k_means_create_model {
  label: "[5] BQML: Create Model"
  derived_table: {
    persist_for: "1 second"

    create_process: {

      sql_step: CREATE OR REPLACE VIEW @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %}_k_means_input_data_{{ _explore._name }}
                    AS  SELECT * EXCEPT({% parameter k_means_training_data.select_item_id %})
                          , {% parameter k_means_training_data.select_item_id %} AS item_id
                        FROM ${input_data.SQL_TABLE_NAME}
      ;;

      sql_step: CREATE OR REPLACE VIEW @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %}_k_means_training_data_{{ _explore._name }}
                    AS  SELECT
                          {% parameter k_means_training_data.select_item_id %} AS item_id,
                          {% assign features = _filters['k_means_training_data.select_features'] | sql_quote | remove: '"' | remove: "'" %}
                            {{ features }}
                        FROM ${input_data.SQL_TABLE_NAME}
      ;;

      sql_step: CREATE OR REPLACE MODEL @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %}_k_means_model_{{ _explore._name }}
                  OPTIONS(MODEL_TYPE = 'KMEANS'
                  {% if k_means_hyper_params.choose_number_of_clusters._parameter_value == 'auto' %}
                  {% else %}
                  , NUM_CLUSTERS = {% parameter k_means_hyper_params.choose_number_of_clusters %}
                  {% endif %}
                  , KMEANS_INIT_METHOD = 'KMEANS++'
                  , STANDARDIZE_FEATURES = TRUE)
                  AS (SELECT * EXCEPT(item_id)
                      FROM @{looker_temp_dataset_name}.{% parameter model_name.select_model_name %}_k_means_training_data_{{ _explore._name }})
      ;;

      sql_step: CREATE TABLE IF NOT EXISTS @{looker_temp_dataset_name}.BQML_K_MEANS_MODEL_INFO
                  (model_name         STRING,
                  number_of_clusters  STRING,
                  item_id             STRING,
                  features            STRING,
                  created_at          TIMESTAMP,
                  explore             STRING)
    ;;

      sql_step: MERGE @{looker_temp_dataset_name}.BQML_K_MEANS_MODEL_INFO AS T
                USING (SELECT '{% parameter model_name.select_model_name %}' AS model_name,
                      '{% parameter k_means_hyper_params.choose_number_of_clusters %}' AS number_of_clusters,
                      '{% parameter k_means_training_data.select_item_id %}' AS item_id,
                      {% assign features = _filters['k_means_training_data.select_features'] | sql_quote | remove: '"' | remove: "'" %}
                        '{{ features }}' AS features,
                      CURRENT_TIMESTAMP AS created_at,
                      '{{ _explore._name }}' AS explore
                      ) AS S
                ON T.model_name = S.model_name AND T.explore = S.explore
                WHEN MATCHED THEN
                  UPDATE SET number_of_clusters=S.number_of_clusters
                      , item_id=S.item_id
                      , features=S.features
                      , created_at=S.created_at
                      , explore=S.explore
                WHEN NOT MATCHED THEN
                  INSERT (model_name, number_of_clusters, item_id, features, created_at, explore)
                  VALUES(model_name, number_of_clusters, item_id, features, created_at, explore)
      ;;
    }
  }

  dimension: train_model {
    view_label: "[5] BQML: Create Model"
    label: "Train Model (REQUIRED)"
    description: "Selecting this field is required to start training your model"
    type: string
    sql: 'Complete' ;;
  }
}
