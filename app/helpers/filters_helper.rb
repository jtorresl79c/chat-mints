module FiltersHelper

  private

  def get_base_filters(default_options = {})
    options = { page: params[:page], pageSize: params[:pageSize], search: params[:search] }.merge(default_options)

    if params[:dates]
      begin
        dates = JSON.parse(params[:dates])
        dfilters = {
          "after": dates['start'],
          "before": dates['end'],
          "dateField": "created_at",
          "range": "between"
        }

        options[:dfilters] = Base64.strict_encode64(JSON.generate(dfilters))
      rescue => e
        #ignored
      end
    end

    options
  end

  def generate_rfilter(relation, table, slug, value, operator = '=')
    rfilters = {
      'type': 'group',
      'operator': 'and',
      'items': [{
                  'type': 'relationship',
                  'relationship': relation,
                  'table': table,
                  'items': [{
                              'type': 'group',
                              'operator': 'and',
                              'items': [{
                                          'type': 'attribute',
                                          'slug': slug,
                                          'value': value,
                                          'operator': operator
                                        }]
                            }]
                }]
    }

    CGI::escape(Base64.encode64(rfilters.to_json))
  end

  def generate_jfilter(items = [], operator = 'and')
    {
      "type": 'group',
      "operator": operator,
      "items": items
    }
  end
end