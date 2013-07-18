# -*- coding: utf-8 -*-
#
# 表の生成
#
#   rows = [
#     {:id => 1, :name => "alice", :description => "あいうえお"},
#     {:id => 2, :name => "bob",   :description => "あいうえお"},
#   ]
#   select = [
#     {:key => :id,          :label => "ID",   :size => nil},
#     {:key => :name,        :label => "名前", :size => nil},
#     {:key => :description, :label => "説明", :size => 3},
#   ]
#   print RainTable.generate(rows, :select => select)
#   +----+-------+--------+
#   | ID | 名前  | 説明   |
#   +----+-------+--------+
#   |  2 | bob   | あいう |
#   |  1 | alice | あいう |
#   +----+-------+--------+
#

require "active_support/core_ext/string"
require "kconv"

module RainTable
  def self.generate(*args, &block)
    Generator.new(*args, &block).generate
  end

  class Generator
    attr_accessor :rows, :options

    def initialize(rows = [], options = {}, &block)
      @options = {
        :header       => true,
        :select       => nil,
        :vertical     => "|",
        :intersection => "+",
        :horizon      => "-",
        :padding      => " ",
        :in_code      => Kconv::UTF8,
        :sort_by      => nil,
        :reverse      => false,
        :normalize    => true,
      }.merge(options)
      @rows = rows
      if block_given?
        yield @options
      end
    end

    def generate
      if @rows.blank?
        return ""
      end

      rows = @rows

      if @options[:normalize]
        rows = rows.collect{|row|
          row = row.collect{|k, v|
            if v.kind_of? String
              v = v.kconv(Kconv::EUC, @options[:in_code]).kconv(@options[:in_code], Kconv::EUC)
            end
            [k, v]
          }
          Hash[*row.flatten(1)]
        }
      end

      if @options[:sort_by]
        if @options[:sort_by].kind_of? Proc
          rows = rows.sort_by(&@options[:sort_by])
        else
          rows = rows.sort_by{|row|row[@options[:sort_by]]}
        end
        if @options[:reverse]
          rows = rows.reverse
        end
      end

      if @options[:select]
        @table_rows = rows.collect{|row|
          @options[:select].collect{|select_column|
            str = row[select_column[:key]].to_s
            if select_column[:size]
              str = bytesize_truncate(str, select_column[:size])
            end
            str
          }
        }
        if @options[:header]
          @column_names = @options[:select].collect{|select_column|
            str = select_column[:label] || select_column[:key].to_s.titleize
            if select_column[:size]
              str = bytesize_truncate(str, select_column[:size])
            end
            str
          }
        else
          @column_names = nil
        end
      else
        @table_rows = rows.collect{|row|row.values}
        @column_names = rows.first.keys
      end

      @column_widths = ([@column_names] + @table_rows).compact.transpose.collect{|vertical_values|
        vertical_values.collect{|value|width_of(value)}.max
      }

      out = [separater]
      if @column_names
        out += [header, separater]
      end
      out += [body, separater]
      out.flatten.join("\n") + "\n"
    end

    private

    def separater
      @options[:intersection] + @column_widths.enum_for(:each_with_index).collect{|column_width, i|
        @options[:horizon] * (padding(i).size + column_width + padding(i).size)
      }.join(@options[:intersection]) + @options[:intersection]
    end

    def header
      line_str(@column_names)
    end

    def body
      @table_rows.collect{|row|line_str(row)}
    end

    def line_str(row)
      @options[:vertical] + row.enum_for(:each_with_index).collect{|value, i|
        padding(i) + just(value, @column_widths[i], align(i)) + padding(i)
      }.join(@options[:vertical]) + @options[:vertical]
    end

    def align(index)
      if @options[:select]
        @options[:select][index][:align]
      end
    end

    def padding(index)
      v = nil
      if @options[:select] && @options[:select][index].has_key?(:padding)
        v = @options[:select][index][:padding]
      end
      if v.nil?
        v = @options[:padding]
      end
      padding_to_s(v)
    end

    def just(value, max_width, align)
      align = (align || (Float(value) && "right" rescue "left")).to_s
      space = " " * (max_width - width_of(value))
      lspace = ""
      rspace = ""
      if align == "right"
        lspace = space
      else
        rspace = space
      end
      [lspace, value, rspace].join
    end

    def width_of(str)
      str.to_s.kconv(Kconv::EUC, @options[:in_code]).bytesize
    end

    # 全角文字を2カラムとして計算するtruncate
    #
    # bytesize_truncate("あいうえお", 5) => "あい"
    # bytesize_truncate("0123456789", 5) => "01234"
    #
    def bytesize_truncate(str, limit)
      generate = ""
      str.each_char{|char|
        next_str = generate + char
        if width_of(next_str) > limit
          break
        end
        generate = next_str
      }
      generate
    end

    def padding_to_s(v)
      case v
      when String
        v
      when Integer
        " " * v
      when TrueClass
        padding_to_s(1)
      else
        padding_to_s(0)
      end
    end
  end
end

if $0 == __FILE__
  rows = [
    {:id => 1, :name => "alice", :description => "0123456789"},
    {:id => 2, :name => "bob",   :description => "あいうえお"},
    {:id => 3, :name => "bob",   :description => "あいう"},
  ]
  select = [
    {:key => :id,          :label => "ID",   :size => nil},
    {:key => :name,        :label => "名前", :size => nil, :align => :right},
    {:key => :description, :label => "説明", :size => 8, :align => :right},
  ]
  puts RainTable.generate([])
  puts RainTable.generate(rows)
  puts RainTable.generate(rows, :select => select)
  puts RainTable.generate(rows, :select => select, :sort_by => :id)
  puts RainTable.generate(rows, :select => select, :sort_by => proc{|row|-row[:id]})
  puts RainTable.generate(rows, :select => select, :header => false)
  puts RainTable.generate(rows, :select => select, :padding => false)
  puts RainTable.generate(rows){|options|
    options[:sort_by] = false
    options[:select] = select
  }
end
