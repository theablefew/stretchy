class EmbeddingModel < StretchyModel

  attribute :passage_text, :text
  attribute :passage_embedding, :rank_features
  attribute :description, :text

end