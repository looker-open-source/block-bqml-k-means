connection: "@{CONNECTION_NAME}"

include: "/views/model_info.view"

explore: model_info {
  group_label: "Looker + BigQuery ML"
  label: "BQML K-Means: Model Info"
  description: "View all BQML K-means Clustering models created with Looker"
  persist_for: "0 minutes"
}
