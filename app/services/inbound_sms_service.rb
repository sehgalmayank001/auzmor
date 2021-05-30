class InboundSmsService
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
    return false if !valid_phone_number
    return false if is_stop_text?
    true
  end

  private

  def assign_params(params)
    SmsSchema::Validation.call(params)
  end

  def check_for_errors
    @errors.add_hash(@params.errors.to_h) if @params.errors.to_h.present?
  end

  def is_stop_text?
    return false unless @text.gsub('\r', '').gsub('\n', '')  == 'STOP'

    key = "#{@from}_#{@to}"
    Rails.cache.write(key, 'STOP', expires_in: 4.hours)
    @errors.add('text', 'STOP, text sent')
  end

  def valid_phone_number
    return true if @current_account.phone_numbers.find_by(number: @to)

    @errors.add('to', 'to parameter not found')
    false
  end
end
