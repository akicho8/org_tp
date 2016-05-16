# -*- coding: utf-8 -*-
#
# 表の生成
#

require "active_support/core_ext/string"
require "kconv"
require "set"

module RainTable
  def self.generate(*args, &block)
    Generator.new(*args, &block).generate
  end

  class Generator
    attr_accessor :rows, :options

    def initialize(rows = [], options = {})
      @options = {
        :header       => rows.kind_of?(Hash) ? false : true,
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

      hash_to_hash_array
      magic_value_array_to_hash_array

      table_vars_set_if_auto

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

    def hash_to_hash_array
      if @rows.kind_of? Hash
        @rows = @rows.collect do |k, v|
          {:key => k.to_s, :value => v.to_s}
        end
      end
    end

    # ["a", "b"] => [{"(value)" => "a"}, {"(value)" => "b"}] としてヘッダーも無効にする
    def magic_value_array_to_hash_array
      @rows = @rows.collect do |e|
        if e.kind_of? Hash
          e
        else
          @options[:header] = false
          {"(value)" => e}
        end
      end
    end

    def table_vars_set_if_auto
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
      return @separater if @separater

      s = column_widths.collect { |e|
        @options[:horizon] * (padding.size + e + padding.size)
      }
      s = s.join(@options[:intersection])
      @separater = [@options[:intersection], s, @options[:intersection]].join
    end

    def header
      line_str(@column_names)
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
