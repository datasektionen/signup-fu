module FormHelper
  def signup_fu_form_for(*args, &block)
    options = args.extract_options!.merge(:builder => signup_fu_form_builder)
    args << options
    form_for(*args, &block)
  end
  
  def signup_fu_form_builder
    SignupFuFormBuilder
  end
end