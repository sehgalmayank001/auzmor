class InboundsController < ApplicationController

  def sms
    Rails.logger.info params
    inbound_sms = InboundSmsService.new(sms_params)
    if inbound_sms.call
      json_response({ message: 'inbound sms ok' }, :ok)      
    else
      json_response(inbound_sms.errors, :unprocessable_entity)
    end
  end

  private

  def sms_params
    params.require(:sms).permit(
      :from, :to, :text, :call
    ).tap do |whitelisted|
      whitelisted[:current_account] = @current_account
    end
  end
end
