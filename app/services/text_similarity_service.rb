module TextSimilarityService
  module_function

  def similarity(this_text, that_text)
    ActiveRecord::Base.connection.execute(
      <<~SQL.squish
        SELECT similarity('#{sanitize(this_text)}', '#{sanitize(that_text)}')
      SQL
    ).first['similarity']
  end

  def sanitize(text)
    ActiveRecord::Base.connection.quote_string(text)
  end
end
