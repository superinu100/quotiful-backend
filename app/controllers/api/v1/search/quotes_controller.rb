module Api
  module V1
    module Search
      class QuotesController < Api::V1::SearchController
        
        def index
          # SOLR: Can't find query using instance variable?
          author_id = params[:author_id]
          query = @query
          page = @page
          count = @count

          @quotes = Quote.search do
            keywords(query) do
              fields :author_name, :tags, :body, :source
            end

            if author_id.present?
              with :author_id, author_id 
            end

            paginate(page: page, per_page: count)
          end.results

          json = Jbuilder.encode do |json|
            json.data do |data|
              data.quotes @quotes, :id, :author_full_name, :body
              data.page @page
            end
            json.success true
          end

          render json: json, status: 200
        end

        def random
          @quote = Quote.order('rand()').first

          json = Jbuilder.encode do |data|
            data.quote do |quote|
              quote.(@quote, :id, :author_full_name, :body)
            end
          end

          render json: json, status: 200
        end
      end

    end
  end
end