class ActionDispatch::Routing::Mapper
  def draw(*routes_files_names)
    routes_files_names.each do |route_file_name|
      instance_eval(File.read(Rails.root.join("config/routes/#{route_file_name}.rb")))
    end
  end
end

Rails.application.routes.draw do
  draw(:parking)
end
