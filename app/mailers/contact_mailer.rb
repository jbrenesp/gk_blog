class ContactMailer < ApplicationMailer
  def contact_email(name, email, message)
    @name = name
    @email = email
    @message = message

    mail(
      to: "andri_k89@hotmail.com",
      from: email,
      reply_to: email,
      subject: "New contact message from #{name}"
    )
  end
end
