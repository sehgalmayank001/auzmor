module SmsSchema
  Validation = Dry::Schema.Params do
    required(:from).value(:string) { size?(6..16) }
    required(:to).value(:string) { size?(6..16) }
    required(:call).value(:string) { size?(6..16) }
    required(:text).filled(:string)
  end
end
