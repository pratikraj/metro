module Metro
  module Models

    #
    # Draws a a menu of options. A menu model inserts itself into the scene as an event
    # target as it needs to maintain the state of the menu. When an option is selected
    # an event is fired based on the name of the option.
    #
    # @note Only one 'menu' can be defined for a given scene
    #
    class Menu < Model

      property :position, default: Game.center

      property :scale, type: ScaleableProperty, default: Scale.default

      property :z_order, type: :numeric, default: 1

      property :padding, type: :numeric, default: 40

      property :color
      property :highlight_color, type: ColorProperty

      def alpha=(value)
        color.alpha = value.floor
        highlight_color.alpha = value.floor
      end

      property :font

      event :on_up, KbLeft, GpLeft, KbUp, GpUp do
        previous_option
      end

      event :on_up, KbRight, GpRight, KbDown, GpDown do
        next_option
      end

      event :on_up, KbEnter, KbReturn, GpButton0 do
        selection
      end

      attr_reader :selected_index, :menu_options

      def after_initialize
        @selected_index = 0
      end

      def window=(value)
        @window = value
        @menu_options = options.map {|option| Option.new option }
      end

      def selection
        scene_method = option_at_index(selected_index).method
        scene.send scene_method
      end

      def previous_option
        @selected_index = @selected_index - 1
        @selected_index = options.length - 1 if @selected_index <= -1
      end

      def next_option
        @selected_index = @selected_index + 1
        @selected_index = 0 if @selected_index >= options.length
      end

      def font
        @font ||= Gosu::Font.new(window, Gosu::default_font_name, 20)
      end

      def contains?(x,y)
        bounds.contains?(x,y)
      end

      def bounds
        Metro::Models::Bounds.new x, y, x + width, y + height
      end

      def width
        font.text_width(longest_option_text)# * x_factor
      end

      def longest_option_text
        longest = options.map {|opt| opt }.inject("") {|longest,opt| opt.length > longest.length ? opt : longest }
      end

      def height
        options.length * font.height + (options.length - 1) * padding
      end

      attr_reader :highlight_color

      def highlight_color=(value)
        @highlight_color = Gosu::Color.new(value)
      end

      def alpha=(value)
        color.alpha = value.floor
        highlight_color.alpha = value.floor
      end

      def option_at_index(index)
        menu_options[index]
      end

      def draw
        options.each_with_index do |option,index|

          option_name = option_at_index(index).name

          draw_color = color
          draw_color = highlight_color if index == selected_index

          y_position = y + padding * index
          font.draw option_name, x, y_position, z_order, x_factor, y_factor, draw_color
        end
      end

      #
      # The Option represents a choice within the menu.
      #
      class Option

        #
        # The raw data that was used to create the option.
        #
        attr_reader :data

        #
        # The human readable name of the option.
        #
        attr_accessor :name

        #
        # The method to execute within the scene when the option is selected.
        #
        attr_accessor :method

        def initialize(data)
          @data = data

          if data.is_a?(Hash)
            @name = data.keys.first
            @method = data.values.first
          else
            @name = data
            @method = data.to_s.downcase.gsub(/\s/,'_').gsub(/^[^a-zA-Z]*/,'').gsub(/[^a-zA-Z0-9\s_]/,'')
          end
        end
      end

    end
  end
end