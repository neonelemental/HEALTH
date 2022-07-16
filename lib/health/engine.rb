module Health
  class Engine < ::Rails::Engine
    isolate_namespace Health

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
          app.config.paths["db/migrate"] = app.config.paths["db/migrate"].uniq
        end
      end
    end
  end
end
