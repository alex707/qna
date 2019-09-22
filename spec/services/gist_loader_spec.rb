require 'rails_helper'

RSpec.describe GistLoader do
  let(:gist_link) do
    'https://gist.github.com/alex707/d6a7726c9132942cf755aa8e6fb52bfb'
  end
  subject { GistLoader.new(gist_link) }

  it 'load and return gist content' do
    expect(subject.gist_content).to include('POST запрос')
  end
end
