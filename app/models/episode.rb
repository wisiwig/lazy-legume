class Episode < ActiveRecord::Base
  validates :name, presence: true
  validates :link, presence: true
  validates :season, presence: true
  validates :show, presence: true
  validates :ep_in_season, presence: true, uniqueness: { scope: :season, message: 'Already fetched this episode' }

  before_validation :parse_season_code

  belongs_to :show

  def parse_season_code
    return unless season.blank? || ep_in_season.blank?
    code = name.scan(/S\d{2}E\d{2}/i)
    return if code.empty?
    code = code.first.scan(/\d{2}/)
    self.season = code.first.to_i
    self.ep_in_season = code.last.to_i
  end

  def season_code
    "S#{ zero_pad season }E#{ zero_pad ep_in_season }"
  end

  def torrent_name
    "#{name.gsub(/\s/, '.')}.torrent"
  end

  def download
    return unless self.valid?
    success = Downloader.save_torrent(torrent_name, link)
    update_attributes(downloaded: success)
  end

  private

  def zero_pad(i)
    i.to_s.rjust(2, '0')
  end
end
