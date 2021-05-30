class OutboundSmsService
  include ActiveModel::Model

  attr_accessor :from, :to, :call, :text, :current_account

  def initialize(attributes = {})
    super
    @params = assign_params(attributes.to_h)
    @errors = Error.new
  end

  def call
    check_for_errors
    return false if @errors.present?
    return false unless valid_phone_number
    return false unless is_stopped_text?
    return false if limit_reached?
    increment_counter!
    true
  end

  private

  def assign_params(params)
    SmsSchema::Validation.call(params)
  end

  def check_for_errors
    @errors.add_hash(@params.errors.to_h) if @params.errors.to_h.present?
  end

  def limit_reached?
    return false if get_counter.to_i < 50

    @errors.add('from', "limit reached for #{@from}")
    true
  end

  def increment_counter!
    if get_counter
      Rails.cache.increment(@from)
    else
      Rails.cache.increment(@from, expires_in: 24.hours)
    end
  end

  def get_counter
    Rails.cache.read @from, { :raw => true }
  end

  def is_stopped_text?
    key = "#{@to}_#{@from}"
    return true unless Rails.cache.read(key)

    @errors.add('text', 'outbound blocked')
  end

  def valid_phone_number
    return true if current_account.phone_numbers.find_by(number: @from)

    @errors.add('from', 'from parameter not found')
    false
  end
end
