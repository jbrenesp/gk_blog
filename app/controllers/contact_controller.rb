class ContactController < ApplicationController
  def new
  end

  def create
    name = params[:name]
    email = params[:email]
    message = params[:message]

    if name.blank? || email.blank? || message.blank?
      flash[:alert] = "All fields are required."
      render :new, status: :unprocessable_entity
      return
    end

    ContactMailer.contact_email(name, email, message).deliver_now

    redirect_to contact_path, notice: "Message sent! We'll get back to you soon."
  end
end
