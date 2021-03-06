require "rails_helper"

RSpec.describe TweetTimeJob, type: :job do
  include ActiveJob::TestHelper

  let(:entry) { create(:entry, twitter_handle: "@lewispb") }
  subject(:job) { described_class.perform_later(entry) }

  it "is in default queue" do
    expect(described_class.new.queue_name).to eq("default")
  end

  it "executes perform" do
    expect(TweetTimeService).to receive(:call).with(twitter_handle: "lewispb", timing: "1.234s")
    perform_enqueued_jobs { job }
  end

  context "entry without twitter handle" do
    let(:entry) { create(:entry, twitter_handle: nil) }

    it "doesn't perform if the twitter handle is missing" do
      expect(TweetTimeService).to_not receive(:call)
      perform_enqueued_jobs { job }
    end
  end
end
