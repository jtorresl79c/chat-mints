namespace :seeder do
    task production: :environment do
      template = ERB.new File.new("#{Rails.root}/mints_config.yml.erb").read
      config = YAML.load template.result(binding)
      
      @user = Mints::User.new(config['mints']['host'], config['mints']['api_key'], config['mints']['api_key'])

      seed_version = ENV.fetch('SEEDS_VERSION', 1)

      p "Leyendo la version #{seed_version} del seeder"
      json_from_file = File.read("seeds_v#{seed_version}.json")
      hash = JSON.parse(json_from_file)
  
      seeds_parts = hash.each_slice(50).to_a
      p "Importanto datos de prod en mints"
      seeds_parts.each_with_index do |part,index|
        p "Subiendo de #{index*50+1} a #{((index+1)*50) > part.length ? ((index)*50) + part.length : ((index+1)*50)}"
        
        response = @user.client.raw('post', '/config/seeds', nil, part.to_json, '/api/user/v1')
  
        if response['result'] != "success"
          p "Hubo un error en este archivo, revisa el siguiente error"
          p response
        else
          p "Completado de #{index*50+1} a #{((index+1)*50) > part.length ? ((index)*50) + part.length : ((index+1)*50)}"
        end
      end   
    end
end