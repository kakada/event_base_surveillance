class EnableExtensionPgCrypto < ActiveRecord::Migration[5.2]
  def change
    enable_extension "pgcrypto"
    enable_extension "uuid-ossp"
  end
end
