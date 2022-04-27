# frozen_string_literal: true

# This file is part of Alexandria.
#
# See the file README.md for authorship and licensing information.

require "gettext"

# XXX: Gettext hotfix
module Gem
  class << self
    undef :all_load_paths if method_defined? :all_load_paths
    def all_load_paths
      []
    end
  end
end

require "logger"
require "alexandria/logging"
require "alexandria/about"

module Alexandria
  def self.clear_invalid_proxy
    current_proxy = ENV.fetch("http_proxy", nil)
    return if current_proxy.nil?

    ENV["http_proxy"] = nil if URI.parse(current_proxy).userinfo.nil?
  end

  def self.set_log_level
    log.level = Logger::DEBUG if $DEBUG
    log.debug { "Initializing Alexandria" }
  end

  def self.main
    clear_invalid_proxy
    set_log_level
    Alexandria::UI.main
  end
end

# lrz says 'macui' is obsolete (may be supported again some day)
# unless $MACOSX
require "alexandria/config"
require "alexandria/version"

# else
#  module Alexandria
#    module Config
#      DATA_DIR = OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation
#    end
#    VERSION = OSX::NSBundle.mainBundle.infoDictionary.objectForKey('CFBundleVersion').to_s
#  end
# end

require "alexandria/models/book"
require "alexandria/library_store"
require "alexandria/library_collection"
require "alexandria/models/library"

require "alexandria/smart_library"
require "alexandria/execution_queue"
require "alexandria/import_library"
require "alexandria/export_library"
require "alexandria/book_providers"
require "alexandria/preferences"
require "alexandria/undo_manager"
require "alexandria/web_themes"

# lrz says 'macui' is obsolete (may be supported again some day)
# require $MACOSX ? 'alexandria/macui' : 'alexandria/ui'

require "alexandria/ui"
require "alexandria/console"
