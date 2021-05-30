class OutboundsController < ApplicationController

  def sms
    outbound_sms = OutboundSmsService.new(sms_params)
    byebug
    if outbound_sms.call
      json_response({ message: 'outbound sms ok' }, :ok)    
    else
      json_response(outbound_sms.errors, :unprocessable_entity)
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
