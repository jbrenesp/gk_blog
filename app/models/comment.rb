class Comment < ApplicationRecord
  belongs_to :post

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :body, presence: true

  BANNED_WORDS = %w[fuck shit ass bitch bastard damn].freeze

  LEETSPEAK = {
    "@" => "a",
    "4" => "a",
    "3" => "e",
    "1" => "i",
    "!" => "i",
    "0" => "o",
    "$" => "s",
    "5" => "s",
    "7" => "t",
    "+" => "t"
  }.freeze

  before_save :filter_bad_words

  private

  def filter_bad_words
    normalized = body.dup
    LEETSPEAK.each { |symbol, letter| normalized.gsub!(symbol, letter) }

    BANNED_WORDS.each do |word|
      if normalized.match?(/\b#{word}\b/i)
        body.gsub!(/#{Regexp.escape(word).chars.map { |c| LEETSPEAK.key(c) ? "[#{c}#{LEETSPEAK.key(c)}]" : c }.join}/i, "*" * word.length)
      end
    end
  end
end
