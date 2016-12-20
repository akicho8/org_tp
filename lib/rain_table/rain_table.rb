# 表の生成

require "active_support/core_ext/string"
require "kconv"

module RainTable
  def self.generate(*args, &block)
    Generator.new(*args, &block).generate
  end

  class Generator
    def initialize(rows, options = {})
      @options = {
        :header       => nil,
        :vertical     => "|",
        :intersection => "+",
        :horizon      => "-",
        :padding      => " ",
        :in_code      => Kconv::UTF8,
      }.merge(options)

      @rows = rows
      @column_names = nil
    end

    def generate
      return "" if @rows.blank?

      functions.each do |e|
        if e[:if][@rows]
          @rows = e[:convert][@rows]
          if @options[:header].nil?
            @options[:header] = e[:header]
          end
        end
      end

      table_rows_build

      out = []
      out << separater
      if @column_names
        out << header
        out << separater
      end
      out << body
      out << separater
      out.flatten.join("\n") + "\n"
    end

    private

    def table_rows_build
      columns = @rows.inject([]) { |a, e| a | e.keys }
      if @options[:header]
        @column_names = columns
      end
      @table_rows = @rows.collect { |e| e.values_at(*columns) }
    end

    def column_widths
      @column_widths ||= ([@column_names] + @table_rows).compact.transpose.collect do |vertical_values|
        vertical_values.collect { |e| width_of(e) }.max
      end
    end

    def separater
      @separater ||= _separater
    end

    def _separater
      s = column_widths.collect { |e|
        @options[:horizon] * (padding.size + e + padding.size)
      }
      s = s.join(@options[:intersection])
      [@options[:intersection], s, @options[:intersection]].join
    end

    def header
      @header ||= line_str(@column_names)
    end

    def body
      @table_rows.collect { |row| line_str(row) }
    end

    def line_str(row)
      s = row.collect.with_index {|e, i|
        padding + just(e, column_widths[i]) + padding
      }
      s = s.join(@options[:vertical])
      [@options[:vertical], s, @options[:vertical]].join
    end

    def padding
      @options[:padding]
    end

    def just(value, max_width)
      align = (Float(value) && "right" rescue "left").to_s
      space = " " * (max_width - width_of(value))
      lspace = ""
      rspace = ""
      if align == "right"
        lspace = space
      else
        rspace = space
      end
      [lspace, value.to_s, rspace].join # value が [] のとき to_s しないと空文字列になってしまう
    end

    def width_of(str)
      str.to_s.kconv(Kconv::EUC, @options[:in_code]).bytesize
    end

    def functions
      [
        {
          :if => -> e { e.kind_of?(Hash) },
          :header => false,
          :convert => -> e {
            e.collect do |k, v|
              {"(key)" => k.to_s, "(value)" => v.to_s}
            end
          },
        },
        {
          :if => -> e { e.kind_of?(Array) && e.any?{|e|!e.kind_of?(Hash)} },
          :header => false,
          :convert => -> e {
            e.collect do |e|
              if e.kind_of? Hash
                e
              else
                {"(array_value)" => e}
              end
            end
          },
        },
        {
          :if => -> e { e.kind_of?(Array) && e.all?{|e|e.kind_of?(Hash)} },
          :header => true,
          :convert => -> e {
            e
          },
        },
      ]
    end
  end
end

if $0 == __FILE__
  rows = [
    {:id => 1, :name => "alice", :description => "0123456789"},
    {:id => 2, :name => "bob",   :description => "あいうえお"},
    {:id => 3, :name => "carol"},
  ]
  puts RainTable.generate({:a => []})
  puts RainTable.generate([])
  puts RainTable.generate(rows)
  puts RainTable.generate({:a => 1, :b => 2}, :header => false)
end
# >> +---+----+
# >> | a | [] |
# >> +---+----+
# >> 
# >> +----+-------+-------------+
# >> | id | name  | description |
# >> +----+-------+-------------+
# >> |  1 | alice |  0123456789 |
# >> |  2 | bob   | あいうえお  |
# >> |  3 | carol |             |
# >> +----+-------+-------------+
# >> +---+---+
# >> | a | 1 |
# >> | b | 2 |
# >> +---+---+
