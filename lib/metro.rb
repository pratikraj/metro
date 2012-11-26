require 'delegate'
require 'logger'
require 'erb'
require 'open3'

require 'gosu'
require 'i18n'
require 'active_support'
require 'active_support/dependencies'
require 'active_support/inflector'
require 'active_support/core_ext/hash'
require 'active_support/hash_with_indifferent_access'

require 'gosu_ext/color'
require 'gosu_ext/gosu_constants'
require 'core_ext/numeric'

require 'locale/locale'

require 'metro/parameters/parameters'
require 'metro/asset_path'
require 'metro/units/units'
require 'metro/logging'
require 'metro/version'
require 'metro/animation'
require 'metro/font'
require 'metro/image'
require 'metro/sample'
require 'metro/song'
require 'metro/template_message'
require 'metro/window'
require 'metro/game'
require 'metro/scene'
require 'metro/scenes'
require 'metro/models/model'
require 'metro/missing_scene'

#
# To allow an author an easier time accessing the Game object from within their game.
# They do not have to use the `Metro::Game` an instead use the `Game` constant.
#
Game = Metro::Game

module Metro
  extend self
  extend GosuConstants

  #
  # @return [String] the filepath to the Metro assets
  #
  def asset_dir
    File.join File.dirname(__FILE__), "assets"
  end

  #
  # @return [Array] an array of all the handlers that will be executed prior
  #   to the game being launched.
  #
  def setup_handlers
    @setup_handlers ||= []
  end

  #
  # Register a setup handler. While this method is present, it is far
  # too late for game code to be executed as these pregame handlers will already
  # have started executing. This allows for modularity within the Metro library
  # with the possibility that this functionality could become available to
  # individual games if the load process were to be updated.
  #
  def register_setup_handler(handler)
    setup_handlers.push handler
  end

  #
  # Run will load the contents of the game contents and game files
  # within the current working directory and start the game.
  #
  # @param [Array<String>] parameters an array of parameters that contains
  #   the commands in the format that would normally be parsed into the
  #   ARGV array.
  #
  def run(*parameters)
    options = Parameters::CommandLineArgsParser.parse(parameters)
    setup_handlers.each { |handler| handler.setup(options) }
    start_game
  end

  #
  # Start the game by lanunching a window with the game configuration and data
  # that has been loaded.
  #
  def start_game
    window = Window.new Game.width, Game.height, Game.fullscreen?
    window.caption = Game.name
    window.scene = Scenes.generate(Game.first_scene)
    window.show
  end

  #
  # When called all the game-related code will be unloaded and reloaded.
  # Providding an opportunity for a game author to tweak the code without having
  # to restart the game.
  #
  def reload!
    SetupHandlers::LoadGameFiles.new.reload!
  end

  def valid_game_code
    SetupHandlers::LoadGameFiles.new.valid_game_code
  end
end

require 'setup_handlers/move_to_game_directory'
require 'setup_handlers/load_game_files'
require 'setup_handlers/load_game_configuration'
require 'setup_handlers/exit_if_dry_run'
