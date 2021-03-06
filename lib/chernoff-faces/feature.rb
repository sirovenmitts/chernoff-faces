require 'nokogiri'

module ChernoffFaces
  ##
  # Features express values on size or shape
  # TODO: color? line thickness?
  #
  class Feature
    attr_accessor :window, :values
    def initialize(window, *values)
      @window = window
      @values = values.map{ |m| m * (@window.width / 100)}
    end

    ##
    # Draw the feature
    #
    def draw
    end

    def output
      @window.output
    end

    def first_value
      @values.first
    end
  end

  ##
  # smaller <-> larger
  #
  class Nose < Feature
    def draw
      center = (@window.width / 2)
      top = (@window.height / 10)
      bottom = top + (first_value * 4)
      line_length = first_value
      @window.g do
        # eyebrow
        line(x1: center - line_length, y1: top, x2: center + 5, y2: top)
        # nose height
        line(x1: center + 5, y1: top, x2: center, y2: bottom)
        # nose bottom
        line(x1: center + line_length, y1: bottom, x2: center, y2: bottom)
      end
      super
    end
  end

  ##
  # smaller <-> larger
  #
  class Eyes < Feature
    def draw
      @window.g(transform: "translate(#{window.width * 0.15}, #{window.width * 0.35}) scale(0.#{first_value}, 0.#{first_value})") do
        ellipse( ry: "16.5", rx: "30.5", cy:"10", cx:"10", 'stroke-width' => "1", stroke:"#000000", fill:"none")
        ellipse( ry:"15", rx:"16", cy:"10.5", cx:"10", 'stroke-width' => "1", stroke:"#000000", fill:"none")
      end
      @window.g(transform: "translate(#{@window.width * 0.45}, 0) scale(0.#{first_value}, 0.#{first_value})") do
        ellipse( ry: "16.5", rx: "30.5", cy:"188", cx:"194.5", 'stroke-width' => "1", stroke:"#000000", fill:"none")
        ellipse( ry:"15", rx:"16", cy:"188", cx:"194", 'stroke-width' => "1", stroke:"#000000", fill:"none")
      end
      super
    end
  end

  ##
  # frown <-> smile
  #
  class Mouth < Feature
    def draw
      spot = (@window.height * 0.60)
      center = (@window.width * 0.50)
      width = (@window.width * 0.35)
      @window.g(transform: "scale(0.#{first_value}, 1)") do
        path(fill: 'white',
             stroke: 'black',
             d:"M#{center - width},#{spot} C#{center - width},#{spot + width} #{center + width}, #{spot + width / 2} #{center + width}, #{spot} Z")
      end
      super
    end
  end

  ##
  # smaller <-> larger
  #
  class Ears < Feature
    def draw
      y = (@window.height * 0.40)
      x1 = (@window.width * 0.25)
      x2 = (@window.width * 0.75)
      radius = (first_value * 0.5)
      attributes = { style: "stroke: black; stroke-width: 10; fill: rgba(1,1,1,0)"}
      @window.circle( attributes.merge( { cx: x1, cy: y } ) )
      @window.circle( attributes.merge( { cx: x2, cy: y } ) )
      super
    end
  end

  ##
  # oval <-> round
  #
  class Head < Feature
    def draw
      @window.ellipse( cx: (@window.height * 0.50),
                    cy: (@window.height * 0.50),
                    r1: (@window.height * 0.50),
                    r2: (@window.height * 0.50) - first_value,
                    style: "stroke: black; stroke-width: 10; fill: rgba(1,1,1,0)" )
      super
    end
  end



end
