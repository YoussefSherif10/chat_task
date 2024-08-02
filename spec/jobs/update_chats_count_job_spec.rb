# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateChatsCountJob, type: :job do
  include ActiveJob::TestHelper

  let!(:application) { create(:application, token: 'AppToken-5040') }
  let!(:chat1) { create(:chat, application: application) }
  let!(:chat2) { create(:chat, application: application) }

  before do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  describe '#perform_later' do
    context 'when enqueued' do
      it 'adds the job to the queue' do
        assert_enqueued_jobs 1 do
          UpdateChatsCountJob.perform_later
        end
      end
    end
  end
end
