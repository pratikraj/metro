module Metro
  module UI

    #
    # The grid drawer will draw a grid from the specified position out to the specified
    # dimensions at the spacing interval provided. This is currently used when the edit
    # mode is enabled.
    #
    # @example Drawing a white, translucent, 100 by 100 grid starting at (20,20).
    #
    #     class BuildScene < GameScene
    #       draw :grid, model: "metro::ui::grid_drawer", position: "20,20",
    #         color: "rgba(255,255,255,0.5)", spacing: 20, dimensions: "100,100"
    #     end
    #
    class GridDrawer < Model

      # @attribute
      # The position to start drawing the grid
      property :position, default: Point.at(0,0,100)

      # @attribute
      # The color of the grid lines
      property :color, default: "rgba(255,255,255,0.1)"

      # @attribute
      # The interval which to draw the lines
      property :spacing, type: :numeric, default: 10

      # @attribute
      # The dimension of the grid
      property :dimensions do
        Dimensions.of Game.width, Game.height
      end

      # @attribute
      # This controls whether the grid should be drawn. By default
      # the grid will be drawn.
      property :enabled, type: :boolean, default: true

      def show
        self.saveable_to_view = false
      end

      def draw
        return unless enabled
        draw_horizontal_lines
        draw_vertical_lines
      end

      private

      def draw_vertical_lines
        xs = (width / spacing + 1).to_i.times.map {|segment| segment * spacing }
        xs.each do |x|
          draw_line(x,1,x,height)
        end
      end

      def draw_horizontal_lines
        ys = (height / spacing + 1).to_i.times.map {|segment| segment * spacing }
        ys.each do |y|
          draw_line(1,y,width,y)
        end
      end

      def draw_line(start_x,start_y,finish_x,finish_y)
        window.draw_line(position.x + start_x, position.y + start_y, color,
          position.x + finish_x, position.y + finish_y, color, 0, :additive)
      end

    end
  end
end