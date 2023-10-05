# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'confirmation_email' do
    let(:mail) { UserMailer.confirmation_email }

    it 'renders the headers' do
      expect(mail.subject).to eq('Confirmation email')
      expect(mail.to).to eq(['to@example.org'])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi')
    end
  end

  describe 'new_password_email' do
    let(:mail) { UserMailer.new_password_email }

    it 'renders the headers' do
      expect(mail.subject).to eq('New password email')
      expect(mail.to).to eq(['to@example.org'])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi')
    end
  end

  describe 'reset_password_email' do
    let(:mail) { UserMailer.reset_password_email }

    it 'renders the headers' do
      expect(mail.subject).to eq('Reset password email')
      expect(mail.to).to eq(['to@example.org'])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi')
    end
  end
end
