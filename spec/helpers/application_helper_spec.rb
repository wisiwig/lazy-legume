require 'rails_helper'

describe ApplicationHelper do
  describe '#bootstrap_alert' do
    it 'creates some pretty html' do
      html = helper.bootstrap_alert(:warning, 'Oh no!')
      expect(html).to include('alert-warning')
      expect(html).to include('Oh no!')
    end
  end

  describe '#truncate' do
    it 'shortens a string to n characters' do
      str = '*' * 100
      short = helper.truncate str, 10
      expect(short.size).to eq(10)
    end

    it 'does not change the length of a string shorter than n' do
      str = '$' * 5
      short = helper.truncate str, 10
      expect(short.size).to eq(5)

      short = helper.truncate str, 5
      expect(short.size).to eq(5)
    end
  end

  describe '#readable_timestamp' do
    it 'nicely formats a time' do
      t = Time.at(1_433_990_054)
      ts = helper.readable_timestamp(t)
      expect(ts).to eq(t.localtime.strftime('%D %r'))
    end
  end

  describe '#orblank' do
    it 'returns the value if it exists' do
      expect(helper.orblank('hello')).to eq('hello')
    end

    it 'returns -- if no value' do
      expect(helper.orblank(nil)).to eq('--')
    end
  end
end
