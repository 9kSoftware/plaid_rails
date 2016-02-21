module PlaidRails
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def install_initializer
      initializer 'plaid.rb', File.read(File.expand_path('../templates/initializer.rb', __FILE__))
    end

    def install_route
      route "mount PlaidRails::Engine => '/plaid', as: :plaid_rails"
    end
  end
end
