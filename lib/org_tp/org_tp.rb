# frozen_string_literal: true
require 'active_support/core_ext/string'          # for blank?
require 'active_support/core_ext/class/attribute' # for class_attribute
require 'kconv'

module OrgTp
  def self.generate(*args, &block)
    Generator.new(*args, &block).generate
  end

  class Generator
    class_attribute :default_options
    self.default_options = {
      header: nil,
      vertical: '|',
      intersection: '+',
      intersection_both: '|',
      horizon: '-',
      padding: ' ',
      in_code: Kconv::UTF8,
    }

    def initialize(rows, **options)
      @options = default_options.merge(options)
      @rows = rows
      @column_names = nil
    end

    def generate
      if @rows.blank?
        return ''
      end

      pre_processes.each do |e|
        if e[:_case][@rows]
          @rows = e[:process][@rows]
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
      out.flatten * "\n" + "\n"
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
        vertical_values.collect { |e| str_width(e) }.max
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
      [@options[:intersection_both], s, @options[:intersection_both]].join
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
      align = Float(value) && :right rescue :left
      space = ' ' * (max_width - str_width(value))
      lspace = ''
      rspace = ''
      if align == :right
        lspace = space
      else
        rspace = space
      end
      # If value is `[]`,
      # executing to_s, it becomes `[]`.
      # not executing to_s, it becomes empty string
      [lspace, value.to_s, rspace].join
    end

    def str_width(str)
      str.to_s.kconv(Kconv::EUC, @options[:in_code]).bytesize
    end

    def pre_processes
      [
        {
          _case: -> e { e.kind_of?(Hash) },
          header: false,
          process: -> e {
            e.collect do |k, v|
              {'(key)' => k.to_s, '(value)' => v.to_s}
            end
          },
        },
        {
          _case: -> e { e.kind_of?(Array) && e.any? { |e| !e.kind_of?(Hash) } },
          header: false,
          process: -> e {
            e.collect do |e|
              if e.kind_of? Hash
                e
              else
                {'(array_value)' => e}
              end
            end
          },
        },
        {
          _case: -> e { e.kind_of?(Array) && e.all? { |e| e.kind_of?(Hash) } },
          header: true,
          process: -> e { e },
        },
      ]
    end
  end
end

if $0 == __FILE__
  rows = [
    {id: 1, name: 'alice', description: '0123456789'},
    {id: 2, name: 'bob',   description: 'あいうえお'},
    {id: 3, name: 'carol'},
  ]
  print OrgTp.generate({a: []})
  print OrgTp.generate([])
  print OrgTp.generate(rows)
  print OrgTp.generate({a: 1, b: 2}, header: false)
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
