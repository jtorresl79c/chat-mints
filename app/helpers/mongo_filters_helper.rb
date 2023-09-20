module MongoFiltersHelper
  def create_filter_response(query)
    total = query.count

    page = params[:page] ? params[:page].to_i : 1
    page_size = params[:pageSize] ? params[:pageSize].to_i : 5

    query = attach_page_size_filter(query, page_size, page)

    if params[:search] && !params[:search].empty?
      query = attach_search_filter(query, params[:search])
    end

    if params[:dates]
      begin
        query = attach_dates_filter(query, JSON.parse(params[:dates]))
      rescue => e
        #ignored
      end
    end

    response = query.order_by(created_at: 'desc').as_json

    {
      data: response,
      meta: {
        filtered: response.count + (page_size * (page - 1)),
        total: total
      }
    }
  end

  private

  def attach_page_size_filter(query, page_size, page)
    query.paginate(:page => page, :limit => page_size)
  end

  def attach_search_filter(query, string)
    query.search(string)
  end

  def attach_dates_filter(query, dates)
    if dates['end'] === dates['start'] || (dates['end'] || '').empty?
      dates['end'] = DateTime.parse(dates['start']) + 1
    else
      dates['end'] = DateTime.parse(dates['end'])
    end

    dates_query = {
      "$gte": DateTime.parse(dates['start']),
      "$lte": dates['end']
    }

    query.where(created_at: dates_query)
  end
end