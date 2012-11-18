module Metro
  module UI

    #
    # Draws a string of text.
    #
    # @example Using the Label in a view file
    #    model: "metro::ui::label"
    #
    class Label < Model

      property :position

      property :scale, default: Scale.one

      property :color, default: "rgba(255,255,255,1.0)"

      property :font, default: { size: 20 }

      property :text

      property :align, type: :text, default: "left"
      property :vertical_align, type: :text, default: "top"

      property :dimensions do
        Dimensions.of (longest_line * x_factor), (line_height * line_count * 2 * y_factor)
      end

      def draw
        parsed_text.each_with_index do |line,index|
          font.draw line, x_position, y_position(index), z_order, x_factor, y_factor, color
        end
      end

      def bounds
        Bounds.new x: x, y: y, width: width, height: height
      end

      def contains?(x,y)
        bounds.contains?(x,y)
      end

      private

      def line_height
        font.height
      end

      def half_line_height
        line_height / 2
      end

      def line_count
        parsed_text.count
      end

      def parsed_text
        text.split("\n")
      end

      def longest_line
        parsed_text.map { |line| font.text_width(line) }.max
      end

      def x_left_alignment
        x
      end

      def x_center_alignment
        x - width / 2
      end

      def x_right_alignment
        x - width
      end

      def horizontal_alignments
        { left: :x_left_alignment,
          center: :x_center_alignment,
          right: :x_right_alignment }
      end

      def x_position
        alignment = horizontal_alignments[align.to_sym]
        send(alignment)
      end

      def y_top_alignment(index)
        y + (index * line_height)
      end

      def y_bottom_alignment(index)
        y - line_height * (line_count - index)
      end

      def y_center_alignment(index)
        if line_count.even?
          full_height = (line_count / 2 - index) * line_height
        else
          offset = (line_count / 2 - index)
          if offset < 0
            full_height = (offset + 1) * line_height - half_line_height
          else
            full_height = offset * line_height + half_line_height
          end
        end

        y - full_height
      end

      def vertical_alignments
        { top: :y_top_alignment,
          center: :y_center_alignment,
          bottom: :y_bottom_alignment }
      end

      def y_position(index)
        alignment = vertical_alignments[vertical_align.to_sym]
        send(alignment,index)
      end

    end
  end
end