# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply-fviz@rambler.ru'
  layout 'mailer'
end
