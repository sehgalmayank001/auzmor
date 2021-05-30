# frozen_string_literal: true

# module for error parsing
class Error
  attr_reader :errors

  def initialize
    @errors = Hash.new { |h, k| h[k] = [] }
  end

  def add(key, error)
    raise 'error string can not be empty' if error.empty?

    if compound_key?(key)
      map_compound_errors(key, error)
    else
      map_error_and_key(key, error, @errors)
    end

    self
  end

  def full_messages
    ## To be implemented
  end

  def add_hash(hsh)
    raise 'Invalid Hash' unless hsh.is_a?(Hash)

    merge_hash_to_errors(hsh)
  end

  def present?
    @errors.present?
  end

  private

  def merge_hash_to_errors(hsh)
    hsh.each do |k, val|
      if compound_key?(k)
        map_compound_errors(k, val)
      else
        map_error_and_key(k, val, @errors)
      end
    end
  end

  def map_error_and_key(key, error, hsh)
    key = key.to_sym

    if error.is_a? Array
      merge_array_to_errors(key, error, hsh)
    elsif error.class == Hash
      hsh[key] = error
    elsif error.class.in?([String, Integer, Float])
      hsh[key] << error
    else
      raise 'Error!!! Invalid type'
    end
  end

  def merge_array_to_errors(key, arr, hsh)
    hsh[key] << arr
    hsh[key] = hsh[key].flatten
  end

  def map_compound_errors(key, val)
    parent, child, num = breakdown_key(key)
    parent = parent.to_sym
    child =  child.to_sym

    @errors[parent] = {} if @errors[parent].empty?
    @errors[parent][num] ||= {}
    @errors[parent][num][child] ||= []
    map_error_and_key(child, val, @errors[parent][num])
  end

  def compound_key?(key)
    key.to_s.match?(/\[\d+\]/)
  end

  def breakdown_key(key)
    key = key.to_s
    num = key.match(/\d+/).to_s
    parts = key.gsub(/\[\d+\]/, '').split('.')
    parent, child = parts
    [parent, child, num.to_i]
  end
end
