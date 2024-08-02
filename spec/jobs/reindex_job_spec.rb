require 'rails_helper'

RSpec.describe ReindexJob, type: :job do
  include ActiveJob::TestHelper

  let(:message) { create(:message) }

  before do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  describe '#perform_later' do
    context 'when enqueued' do
      it 'adds the job to the queue' do
        expect {
          ReindexJob.perform_later(message)
        }.to change(enqueued_jobs, :size).by(2)
      end
    end
  end
end
