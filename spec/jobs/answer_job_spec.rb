require 'rails_helper'

RSpec.describe AnswerJob, type: :job do
  let(:service) { double('AnswerService') }
  let(:answer) { create(:answer) }

  before do
    allow(AnswerService).to receive(:new).and_return(service)
  end

  it 'calls AnswerService#notify_subscribers' do
    expect(service).to receive(:notify_subscribers)
    AnswerJob.perform_now(answer)
  end
end
