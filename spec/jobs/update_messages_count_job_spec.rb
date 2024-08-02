# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateMessagesCountJob, type: :job do
  include ActiveJob::TestHelper

  let(:application) { create(:application, token: 'AppToken-4050') }
  let!(:chat) { create(:chat, application: application) }
  let!(:message1) { create(:message, chat: chat) }
  let!(:message2) { create(:message, chat: chat) }

  before do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  describe '#perform_later' do
    context 'when enqueued' do
      it 'adds the job to the queue' do
        assert_enqueued_jobs 1 do
          UpdateMessagesCountJob.perform_later
        end
      end
    end
  end
end
